import {
  Injectable,
  Logger,
  OnModuleDestroy,
  OnModuleInit,
} from '@nestjs/common';
import { PrismaPg } from '@prisma/adapter-pg';
import { PrismaClient } from '../../../generated/prisma/client';
import { conf } from '../config';
import { PlatformRoles } from '../../common/enum';
import { Crypt } from '../../infrastructure/lib/Crypt';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  private readonly logger = new Logger(PrismaService.name);

  constructor() {
    const connectionString = conf.DB_URL;
    if (!connectionString) {
      throw new Error('DATABASE URL is not defined');
    }
    const adapter = new PrismaPg({
      connectionString,
    });
    super({
      adapter,
    });
  }

  async onModuleInit(): Promise<void> {
    await this.$connect();
    this.logger.log('PostgreSQL connected successfully');

    const superAdminExists = await this.platformUserRole.findFirst({
      where: { roleCode: PlatformRoles.SUPERADMIN },
    });
    if (!superAdminExists?.userId) {
      const user = await this.user.create({
        data: {
          phone: conf.SUPERADMIN.PHONE,
          passwordHash: await Crypt.hash(conf.SUPERADMIN.PASSWORD),
        },
      });
      await this.platformUserRole.create({
        data: {
          userId: user.id,
          roleCode: PlatformRoles.SUPERADMIN,
        },
      });
      console.log('Super admin created');
    }
  }

  async onModuleDestroy(): Promise<void> {
    await this.$disconnect();
    this.logger.log('PostgreSQL disconnected');
  }
}
