import { Module } from '@nestjs/common';
import { PrismaModule } from './config/database/prisma.module';
import { AuthModule } from './modules/auth/auth.module';
import { RedisModule } from './config/redis/redis.module';
import { OtpModule } from './modules/otp/otp.module';

@Module({
  imports: [PrismaModule, RedisModule, OtpModule, AuthModule],
})
export class AppModule {}
