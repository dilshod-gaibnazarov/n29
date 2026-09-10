import { BadRequestException, Injectable } from '@nestjs/common';
import { MailerService } from '@nestjs-modules/mailer';

@Injectable()
export class MailService {
  constructor(private readonly mailerService: MailerService) {}

  async sendMail(
    to: string,
    subject: string = 'N29',
    text: string = 'Guruhdan salom',
  ): Promise<object> {
    try {
      await this.mailerService.sendMail({
        to,
        subject,
        text,
      });
      return { success: true };
    } catch (error) {
      throw new BadRequestException("Gmailga xabar jo'natishda xatolik");
    }
  }
}
