import { BadRequestException, Injectable, PipeTransform } from '@nestjs/common';
import { extname } from 'path';
import sharp from 'sharp';

@Injectable()
export class ImageValidationPipe implements PipeTransform<
  Express.Multer.File | undefined
> {
  private readonly allowedExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.webp',
    '.heic',
  ];

  private readonly allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/jpg',
    'image/webp',
    'image/heic',
  ];

  private readonly maxFileSize = 20 * 1024 * 1024;

  async transform(file: Express.Multer.File | undefined) {
    if (!file) {
      return file;
    }

    if (file.size > this.maxFileSize) {
      throw new BadRequestException('Fayl hajmi 10 MB dan oshmasin');
    }

    const extension = extname(file.originalname).toLowerCase();
    if (!this.allowedExtensions.includes(extension)) {
      throw new BadRequestException('Faqat rasm fayllarini yuboring');
    }
    if (!this.allowedMimeTypes.includes(file.mimetype)) {
      throw new BadRequestException('Fayl turi noto‘g‘ri');
    }

    try {
      const optimizedBuffer = await sharp(file.buffer)
        .rotate()
        .resize({
          width: 1600,
          height: 1600,
          fit: 'inside',
          withoutEnlargement: true,
        })
        .webp({
          quality: 80,
        })
        .toBuffer();

      file.buffer = optimizedBuffer;
      file.size = optimizedBuffer.length;
      file.mimetype = 'image/webp';
      file.originalname = `${Date.now()}.webp`;
      return file;
    } catch (error) {
      throw new BadRequestException(
        'Yuborilgan fayl haqiqiy rasm emas yoki buzilgan',
      );
    }
  }
}
