import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { PrismaService } from '../../core/database/prisma.service';
import { SignInDto } from './dto/sign-in.dto';
import { Crypt } from '../../infrastructure/lib/Crypt';
import { IPayload } from '../../common/interface/payload-token';
import { Token } from '../../infrastructure/lib/Token';
import { Response } from 'express';
import { conf } from '../../core/config';
import { UserStatus } from '../../common/enum';
import { successRes } from '../../infrastructure/lib/successRes';

@Injectable()
export class AuthService {
  constructor(private readonly prisma: PrismaService) {}

  async signIn(dto: SignInDto, res: Response) {
    const { phone, password } = dto;
    const user = await this.prisma.user.findUnique({ where: { phone } });
    const isMatchPass = await Crypt.compare(
      password,
      user ? user.passwordHash : '',
    );
    if (!user || !isMatchPass) {
      throw new BadRequestException('Telefon raqam yoki parol xato');
    }
    const userRole = await this.prisma.platformUserRole.findFirst({
      where: { userId: user.id },
    });
    if (!userRole) {
      throw new NotFoundException('Foydalanuvchi topilmadi');
    }
    const payload: IPayload = {
      id: user.id,
      status: user.status,
      role: userRole.roleCode,
    };
    const accessToken = await Token.generateAccess(payload);
    const refreshToken = await Token.generateRefresh(payload);
    res.cookie('refreshToken', refreshToken, {
      httpOnly: true, // dev mode
      secure: false,
      maxAge: parseInt(conf.TOKEN.REFRESH_TIME) * 24 * 60 * 60 * 1000,
    });
    return successRes({ token: accessToken }, 201);
  }

  async getToken(refreshToken: string) {
    const verifiedData = await Token.verifyRefreshToken(refreshToken);
    const user = await this.prisma.user.findUnique({
      where: { id: verifiedData.id },
    });
    if (!user) {
      throw new NotFoundException('Foydalanuvchi topilmadi');
    }
    if (user.status === UserStatus.INACTIVE) {
      throw new BadRequestException('Foydalanuvchi aktiv holatda emas');
    }
    delete verifiedData.iat;
    delete verifiedData.exp;
    const accessToken = await Token.generateAccess(verifiedData);
    return successRes({ token: accessToken }, 201);
  }
}
