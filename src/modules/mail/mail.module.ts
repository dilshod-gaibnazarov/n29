import { Module } from '@nestjs/common';
import { MailerModule } from '@nestjs-modules/mailer';
import { MailService } from './mail.service';
import { env } from '../../config';
import { MailController } from './mail.controller';

@Module({
  imports: [
    MailerModule.forRoot({
      transport: {
        host: env.SMTP.HOST,
        port: env.SMTP.PORT,
        auth: {
          user: env.SMTP.FROM,
          pass: env.SMTP.PASSWORD,
        },
      },
      defaults: {
        from: env.SMTP.FROM,
      },
    }),
  ],
  controllers: [MailController],
  providers: [MailService],
  exports: [MailService],
})
export class MailModule {}
