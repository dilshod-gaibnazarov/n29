import { Module } from '@nestjs/common';
import { PrismaModule } from './config/database/prisma.module';
import { RedisModule } from './config/redis/redis.module';
import { OtpModule } from './modules/otp/otp.module';
import { MailModule } from './modules/mail/mail.module';
import { AuthModule } from './modules/auth/auth.module';

@Module({
  imports: [PrismaModule, RedisModule, OtpModule, MailModule, AuthModule],
})
export class AppModule {}
