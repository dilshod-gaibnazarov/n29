import { Module } from '@nestjs/common';
import { PrismaModule } from './config/database/prisma.module';
import { AdminModule } from './modules/admin/admin.module';
import { RedisModule } from './config/redis/redis.module';

@Module({
  imports: [PrismaModule, RedisModule, AdminModule],
})
export class AppModule { }
