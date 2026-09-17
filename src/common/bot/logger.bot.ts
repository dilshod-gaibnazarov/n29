import { Logger } from '@nestjs/common';
import { env } from '../../config';

export class LoggerBot {
  static logger = new Logger(LoggerBot.name);

  static async sendMessage(message: string): Promise<void> {
    if (!env.TELEGRAM.TOKEN || !env.TELEGRAM.ID) {
      this.logger.warn('Telegram configuration is missing');
      return;
    }
    const url = `https://api.telegram.org/bot${env.TELEGRAM.TOKEN}/sendMessage`;
    try {
      const response = await fetch(url, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          chat_id: env.TELEGRAM.ID,
          text: message,
          message_thread_id: env.TELEGRAM.TOPIC,
          parse_mode: 'HTML',
          disable_web_page_preview: true,
        }),
      });
      if (!response.ok) {
        const errorText = await response.text();
        this.logger.error(
          `Telegram API error: ${response.status} ${errorText}`,
        );
      }
    } catch (error) {
      this.logger.error(
        'Failed to send Telegram message',
        error instanceof Error ? error.stack : String(error),
      );
    }
  }
}
