import {
  NotFoundException,
  BadRequestException,
  Injectable,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../../config/database/prisma.service';
import { SignInDto } from './dto/sign-in.dto';
import { Crypt } from '../../infrastructure/lib/Crypt';
import { successRes } from '../../common/helper/success-response';
import { OtpService } from '../otp/otp.service';
import { VerifyOTPDto } from '../otp/dto/verify-otp.dto';
import { Token } from '../../infrastructure/lib/Token';
import type { Response, Request } from 'express';
import { getDeviceInfo } from '../../common/helper/device-info';

@Injectable()
export class AuthService {
  constructor(
    private readonly db: PrismaService,
    private readonly otp: OtpService,
  ) {}

  async signIn(dto: SignInDto) {
    const user: any = await this.db.user.findUnique({
      where: { phone: dto.phone },
    });
    const isMatchPass = await Crypt.compare(
      dto.password,
      user ? user.hashedPassword : '',
    );
    if (!isMatchPass) {
      throw new BadRequestException('Telefon raqam yoki parol xato');
    }
    const data = await this.otp.sendOtp(user.phone);
    return successRes(data, 201);
  }

  async confirmSignIn(dto: VerifyOTPDto, req: Request, res: Response) {
    const user = await this.db.user.findUnique({ where: { phone: dto.phone } });
    if (!user) {
      throw new NotFoundException('Foydalanuvchi topilmadi');
    }
    await this.otp.verifyOtp(user.phone, dto.code);
    const devices = await this.db.devices.findMany({
      where: { userId: user.id },
    });
    if (devices.length >= 2) {
      throw new ForbiddenException(
        'Qurilmalar soni 2 tadan oshishi taqiqlanadi',
      );
    }
    const { client, os } = getDeviceInfo(req);
    const device = await this.db.devices.create({
      data: {
        user: { connect: { id: user.id } },
        device: `${client?.name} ${os?.name ? os.name : 'unknown'}`,
        hashedRefreshToken: '',
      },
    });
    const payload = {
      sub: user.id,
      role: user.role,
      status: user.status,
      deviceId: device.deviceId,
    };
    const { accessToken, refreshToken } = await Token.getToken(payload);
    const hashedRefreshToken = await Crypt.hash(refreshToken);
    await this.db.devices.update({
      where: { deviceId: device.deviceId },
      data: {
        hashedRefreshToken,
      },
    });
    Token.setCookie(res, accessToken, refreshToken);
    return successRes(
      {
        userId: device.userId,
        deviceId: device.deviceId,
        device: device.device,
        createdAt: device.createdAt,
      },
      201,
    );
  }

  async refreshToken(refreshToken: string, res: Response) {
    const verifiedData = await Token.verifyToken(refreshToken, 'refresh');
    const device = await this.db.devices.findUnique({
      where: {
        deviceId: verifiedData.deviceId,
        userId: verifiedData.userId,
      },
    });
    if (!device) {
      throw new BadRequestException(
        'Tizimda bunday foydalanuvchi yoki qurilma topilmadi',
      );
    }
    const isMatchToken = await Crypt.compare(
      refreshToken,
      device.hashedRefreshToken,
    );
    if (!isMatchToken) {
      throw new BadRequestException("Qurilma tizimda ro'yxatdan o'tmagan");
    }
    delete verifiedData.iat;
    delete verifiedData.exp;
    const { accessToken } = await Token.getToken(verifiedData);
    Token.setCookie(res, accessToken);
    return successRes(
      {
        userId: device.userId,
        deviceId: device.deviceId,
        device: device.device,
        createdAt: device.createdAt,
      },
      201,
    );
  }

  async signOut(refreshToken: string, res: Response) {
    const verifiedData = await Token.verifyToken(refreshToken, 'refresh');
    await this.db.devices.delete({
      where: {
        deviceId: verifiedData.deviceId,
        userId: verifiedData.userId,
      },
    });
    Token.clearCookie(res);
    return successRes({});
  }
}
