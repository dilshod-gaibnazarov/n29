import { Body, Controller, Post } from '@nestjs/common';
import { MailService } from './mail.service';

@Controller('mail')
export class MailController {
  constructor(private readonly mailService: MailService) {}

  @Post()
  sendMail(@Body() { email }: any) {
    return this.mailService.sendMail(email);
  }
}
