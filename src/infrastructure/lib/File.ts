import {
  BadRequestException,
  InternalServerErrorException,
} from '@nestjs/common';
import { existsSync, mkdirSync, unlink, writeFile } from 'fs';
import { join } from 'path';
import { env } from '../../config';

export class File {
  static filePath = join(process.cwd(), env.FILE_PATH);

  static async create(file: Express.Multer.File): Promise<string> {
    try {
      const fileName = `${Date.now()}_${file.originalname}`;
      if (!existsSync(File.filePath)) {
        mkdirSync(File.filePath, { recursive: true });
      }
      await new Promise<void>((res, rej) => {
        writeFile(join(File.filePath, fileName), file.buffer, (err: any) => {
          if (err) rej(err);
          res();
        });
      });
      return `${env.BASE_URL}/${fileName}`;
    } catch (error) {
      throw new InternalServerErrorException('Fayl yuklashda muammo');
    }
  }

  static async delete(fileName: string): Promise<void> {
    try {
      const file = fileName.split(`${env.BASE_URL}/`)[1];
      const fileUrl = join(File.filePath, file);
      if (!existsSync(fileUrl)) {
        throw new BadRequestException('Fayl topilmadi');
      }
      await new Promise<void>((res, rej) => {
        unlink(fileUrl, (err: any) => {
          if (err) rej(err);
          res();
        });
      });
    } catch (error) {
      throw new InternalServerErrorException("Faylni o'chirishda muammo");
    }
  }

  static async exist(fileName: string): Promise<boolean> {
    try {
      const file = fileName.split(`${env.BASE_URL}/`)[1];
      const fileUrl = join(File.filePath, file);
      if (existsSync(fileUrl)) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      throw new InternalServerErrorException('Fayl topilmadi');
    }
  }
}
