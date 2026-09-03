import { ConflictException, Injectable } from '@nestjs/common';
import { CreateAdminDto } from './dto/create-admin.dto';
import { UpdateAdminDto } from './dto/update-admin.dto';
import { PrismaService } from '../../config/database/prisma.service';
import { Crypt } from '../../infrastructure/lib/Crypt';
import { Roles } from '../../common/enum';
import { successRes } from '../../common/helper/success-response';

@Injectable()
export class AdminService {
  constructor(private readonly db: PrismaService) { }

  async create(createAdminDto: CreateAdminDto) {
    const { phone, password } = createAdminDto;
    const existsPhone = await this.db.user.findUnique({ where: { phone } });
    if (existsPhone) {
      throw new ConflictException('Bunday telefon raqam allaqachon mavjud');
    }
    const hashedPassword = await Crypt.hash(password);
    const admin = await this.db.user.create({
      data: { phone, hashedPassword, role: Roles.ADMIN }
    });
    return successRes(admin, 201);
  }

  findAll() {
    return `This action returns all admin`;
  }

  findOne(id: number) {
    return `This action returns a #${id} admin`;
  }

  update(id: number, updateAdminDto: UpdateAdminDto) {
    return `This action updates a #${id} admin`;
  }

  remove(id: number) {
    return `This action removes a #${id} admin`;
  }
}
