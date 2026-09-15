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
import { env } from '../../config';
import { Status } from '../../../generated/prisma/enums';
import { getDeviceInfo } from '../../common/helper/device-info';

@Injectable()
export class AuthService {
  constructor(
    private readonly db: PrismaService,
    private readonly otp: OtpService,
  ) { }

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
    const devices = await this.db.devices.findMany({ where: { userId: user.id } });
    if (devices.length >= 2) {
      throw new ForbiddenException("Qurilmalar soni 2 tadan oshishi taqiqlanadi");
    }
    const { client, os } = getDeviceInfo(req);
    const device = await this.db.devices.create({
      data: {
        user: { connect: { id: user.id } },
        device: `${client?.name} ${os?.name ? os.name : 'unknown'}`
      }
    });
    const payload = {
      sub: user.id,
      role: user.role,
      status: user.status,
      deviceId: device.deviceId
    };
    const accessToken = await Token.generateAccess(payload);
    const refreshToken = await Token.generateRefresh(payload);
    res.cookie('refreshToken', refreshToken, {
      httpOnly: true,
      secure: false,
      maxAge: parseInt(env.TOKEN.REFRESH_TIME) * 24 * 60 * 60 * 1000,
    });
    res.cookie('accessToken', accessToken, {
      httpOnly: true,
      secure: false,
      maxAge: parseInt(env.TOKEN.ACCESS_TIME) * 24 * 60 * 60 * 1000,
    });
    return successRes(device, 201);
  }

  async refreshToken(refreshToken: string) {
    const verifiedData = await Token.verifyRefreshToken(refreshToken);
    const user = await this.db.user.findUnique({
      where: { id: verifiedData.id },
    });
    if (!user) {
      throw new NotFoundException('Foydalanuvchi topilmadi');
    }
    if (user.status === Status.INACTIVE) {
      throw new BadRequestException('Foydalanuvchi aktiv holatda emas');
    }
    delete verifiedData.iat;
    delete verifiedData.exp;
    const accessToken = await Token.generateAccess(verifiedData);
    return successRes({ token: accessToken }, 201);
  }

  async signOut(refreshToken: string, res: Response){
    
  }
}
