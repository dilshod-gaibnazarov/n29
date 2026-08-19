import {
  ArgumentsHost,
  Catch,
  ExceptionFilter,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { Request, Response } from 'express';

@Catch()
export class AllExceptionsFilter implements ExceptionFilter {
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

      if (
        typeof exceptionResponse === 'object' &&
        exceptionResponse !== null
      ) {
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

    response.status(statusCode).json({
      statusCode,
      code,
      message,
      ...(details ? { details } : {}),
      path: request.url,
      timestamp: new Date().toISOString(),
    });
  }
}