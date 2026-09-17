import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
  Injectable,
  Logger,
} from '@nestjs/common';
import type { Request, Response } from 'express';
import { LoggerBot } from '../bot/logger.bot';
import { ai } from '../openai/open.ai';

@Catch()
@Injectable()
export class AllExceptionsFilter implements ExceptionFilter {
  private readonly logger = new Logger(AllExceptionsFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();

    const response = ctx.getResponse<Response>();

    const request = ctx.getRequest<Request>();

    let statusCode = HttpStatus.INTERNAL_SERVER_ERROR;

    let code = 'INTERNAL_SERVER_ERROR';
    let message = 'Internal server error';
    let details: unknown;

    if (exception instanceof HttpException) {
      statusCode = exception.getStatus();

      code = HttpStatus[statusCode] ?? 'HTTP_ERROR';

      const exceptionResponse = exception.getResponse();

      if (typeof exceptionResponse === 'string') {
        message = exceptionResponse;
      }

      if (typeof exceptionResponse === 'object' && exceptionResponse !== null) {
        const data = exceptionResponse as {
          error?: string;
          code?: string;
          message?: string | string[];
          details?: unknown;
        };

        code = data.code ?? data.error ?? code;

        if (typeof data.message === 'string') {
          message = data.message;
        } else if (Array.isArray(data.message)) {
          message = data.message.join(', ');
        }

        details = data.details;
      }
    }

    const errorStack =
      exception instanceof Error ? exception.stack : JSON.stringify(exception);

    this.logger.error(
      `${request.method} ${request.url} -> ${statusCode} ${message}`,
      errorStack,
    );

    if (statusCode === 500) {
      void this.sendErrorToTelegram({
        request,
        statusCode,
        code,
        message,
        details,
        errorStack,
      });
    }

    response.status(statusCode).json({
      statusCode,
      code,
      message,
      ...(details !== undefined ? { details } : {}),
      path: request.url,
      timestamp: new Date().toISOString(),
    });
  }

  private buildTelegramMessage(data: {
    request: Request;
    statusCode: number;
    code: string;
    message: string;
    details?: unknown;
    errorStack?: string;
  }): string {
    const { request, statusCode, code, message, details, errorStack } = data;

    const method = this.escapeHtml(request.method);

    const path = this.escapeHtml(request.originalUrl ?? request.url);

    const safeCode = this.escapeHtml(code);

    const safeMessage = this.escapeHtml(message);

    const ip = this.escapeHtml(request.ip ?? 'unknown');

    const userAgent = this.escapeHtml(
      request.headers['user-agent'] ?? 'unknown',
    );

    const detailsText = details !== undefined ? this.safeJson(details) : 'N/A';

    const stackText = errorStack ?? 'No stack trace';

    const fullMessage = [
      '🚨 <b>BACKEND ERROR</b>',
      '',
      `<b>Status:</b> ${statusCode}`,
      `<b>Code:</b> ${safeCode}`,
      `<b>Method:</b> ${method}`,
      `<b>Path:</b> <code>${path}</code>`,
      `<b>IP:</b> ${ip}`,
      '',
      `<b>Message:</b> ${safeMessage}`,
      '',
      `<b>Details:</b>`,
      `<pre>${this.escapeHtml(detailsText)}</pre>`,
      '',
      `<b>Stack:</b>`,
      `<pre>${this.escapeHtml(stackText)}</pre>`,
      '',
      `<b>User-Agent:</b>`,
      `<pre>${userAgent}</pre>`,
      '',
      `<b>Time:</b> ${new Date().toLocaleString()}`,
    ].join('\n');

    return fullMessage.slice(0, 3900);
  }

  private safeJson(value: unknown): string {
    try {
      return JSON.stringify(value, null, 2);
    } catch {
      return String(value);
    }
  }

  private escapeHtml(value: unknown): string {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#039;');
  }

  private async sendErrorToTelegram(data: {
    request: Request;
    statusCode: number;
    code: string;
    message: string;
    details?: unknown;
    errorStack?: string;
  }) {
    const { request, statusCode, code, message, details, errorStack } = data;

    const errorMessage = this.buildTelegramMessage({
      request,
      statusCode,
      code,
      message,
      details,
      errorStack,
    });

    const aiInput = `
Backend error:

Status: ${statusCode}
Code: ${code}
Method: ${request.method}
Path: ${request.originalUrl ?? request.url}

Message:
${message}

Details:
${this.safeJson(details)}

Stack:
${errorStack ?? 'No stack trace'}
`;

    const fixMessage = await ai(aiInput);

    const telegramMessage = [
      errorMessage,
      '',
      '━━━━━━━━━━━━━━━━━━━━',
      '',
      '🤖 <b>AI FIX</b>',
      '',
      this.formatAiFix(fixMessage),
    ].join('\n');

    await LoggerBot.sendMessage(telegramMessage);
  }

  private formatAiFix(text: string): string {
    const parts = text.split(/```/g);

    return parts
      .map((part, index) => {
        // Oddiy text qismi
        if (index % 2 === 0) {
          return this.escapeHtml(part);
        }

        // Code block qismi
        let code = part;

        // ```ts yoki ```typescript kabi language belgisini olib tashlash
        code = code.replace(
          /^(typescript|ts|javascript|js|json|bash|sh)\n/i,
          '',
        );

        return `<pre>${this.escapeHtml(code.trim())}</pre>`;
      })
      .join('');
  }
}
