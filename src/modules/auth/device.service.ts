import { BadRequestException, Injectable } from '@nestjs/common';
import { PrismaService } from '../../config/database/prisma.service';
import { successRes } from '../../common/helper/success-response';
import { Token } from '../../infrastructure/lib/Token';

@Injectable()
export class DeviceService {
  constructor(private readonly db: PrismaService) {}

  async findAll(userId: number) {
    const devices = await this.db.devices.findMany({
      where: { userId },
      select: {
        deviceId: true,
        device: true,
        createdAt: true,
      },
    });
    return successRes(devices);
  }

  async remove(refreshToken: string, id: number) {
    const verifiedData = await Token.verifyToken(refreshToken, 'refresh');
    const iatDate = new Date(verifiedData.iat * 1000);
    const currentDate = new Date();
    const diffInMinutes = Math.floor(
      (currentDate.getTime() - iatDate.getTime()) / (1000 * 60),
    );
    if (diffInMinutes < 1440) {
      throw new BadRequestException(
        "Eski qurilmani o'chirish uchun 24 soat talab etiladi",
      );
    }
    if (verifiedData.deviceId === id) {
      throw new BadRequestException("Joriy qurilmani o'chirib bo'lmaydi");
    }
    await this.db.devices.delete({ where: { deviceId: id } });
    return successRes({});
  }
}
