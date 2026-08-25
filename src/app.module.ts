import { Module } from '@nestjs/common';
import { PrismaModule } from './config/database/prisma.module';
import { AdminModule } from './modules/admin/admin.module';
import { RedisModule } from './config/redis/redis.module';
import { OtpModule } from './modules/otp/otp.module';

@Module({
  imports: [PrismaModule, RedisModule, OtpModule, AdminModule],
})
export class AppModule {}
