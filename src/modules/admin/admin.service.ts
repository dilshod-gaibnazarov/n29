import {
  BadRequestException,
  ConflictException,
  Injectable,
} from '@nestjs/common';
import { PrismaService } from '../../config/database/prisma.service';
import { AdminDto } from './dto/admin.dto';
import { Crypt } from '../../infrastructure/lib/Crypt';
import { successRes } from '../../common/helper/success-response';
import { OtpService } from '../otp/otp.service';
import { VerifyOTPDto } from '../otp/dto/verify-otp.dto';

@Injectable()
export class AdminService {
  constructor(
    private readonly db: PrismaService,
    private readonly otp: OtpService,
  ) { }

  async create(dto: AdminDto) {
    const { phone, password } = dto;
    const existsPhone = await this.db.user.findUnique({
      where: { phone },
    });
    if (existsPhone) {
      throw new ConflictException('Bunday telefon raqam allaqachon mavjud');
    }
    const hashedPassword = await Crypt.hash(password);
    const user = await this.db.user.create({
      data: { phone, hashedPassword },
    });
    await this.db.admin.create({
      data: { userId: user.id },
    });
    return successRes(user, 201);
  }

  async signIn(dto: AdminDto) {
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

  async confirmSignIn(dto: VerifyOTPDto) {
    return this.otp.verifyOtp(dto.phone, dto.code);
  }
}
