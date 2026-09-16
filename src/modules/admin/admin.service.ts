import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { CreateAdminDto } from './dto/create-admin.dto';
import { UpdateAdminDto } from './dto/update-admin.dto';
import { PrismaService } from '../../config/database/prisma.service';
import { Crypt } from '../../infrastructure/lib/Crypt';
import { Roles } from '../../common/enum';
import { successRes } from '../../common/helper/success-response';
import { File } from '../../infrastructure/lib/File';

@Injectable()
export class AdminService {
  constructor(private readonly db: PrismaService) {}

  async create(createAdminDto: CreateAdminDto) {
    const { phone, password } = createAdminDto;
    const existsPhone = await this.db.user.findUnique({ where: { phone } });
    if (existsPhone) {
      throw new ConflictException('Bunday telefon raqam allaqachon mavjud');
    }
    const hashedPassword = await Crypt.hash(password);
    const admin = await this.db.user.create({
      data: { phone, hashedPassword, role: Roles.ADMIN },
    });
    return successRes(admin, 201);
  }

  async findAll() {
    const admins = await this.db.user.findMany({
      where: {
        role: Roles.ADMIN,
      },
      select: {
        id: true,
        phone: true,
        status: true,
        fullName: true,
        imageUrl: true,
      },
      orderBy: { updatedAt: 'desc' },
    });
    return successRes(admins);
  }

  async findOne(id: number) {
    const admin = await this.db.user.findUnique({
      where: { id },
      select: {
        id: true,
        phone: true,
        status: true,
        fullName: true,
        imageUrl: true,
      },
    });
    if (!admin) {
      throw new NotFoundException();
    }
    return successRes(admin);
  }

  async update(
    id: number,
    updateAdminDto: UpdateAdminDto,
    image?: Express.Multer.File,
  ) {
    const admin = await this.db.user.findUnique({ where: { id } });
    if (!admin) {
      throw new NotFoundException();
    }
    let hashedPassword = admin.hashedPassword;
    if (updateAdminDto.password) {
      hashedPassword = await Crypt.hash(updateAdminDto.password);
    }
    let imageUrl = admin.imageUrl;
    if (image) {
      if (imageUrl && (await File.exist(imageUrl))) {
        await File.delete(imageUrl);
      }
      imageUrl = await File.create(image);
    }
    delete updateAdminDto.password;
    await this.db.user.update({
      where: { id },
      data: { imageUrl, hashedPassword, ...updateAdminDto },
    });
    return successRes({});
  }

  async remove(id: number) {
    const admin = await this.db.user.findUnique({ where: { id } });
    if (!admin) {
      throw new NotFoundException();
    }
    if (admin.imageUrl && (await File.exist(admin.imageUrl))) {
      await File.delete(admin.imageUrl);
    }
    await this.db.user.delete({ where: { id } });
    return successRes({});
  }
}
