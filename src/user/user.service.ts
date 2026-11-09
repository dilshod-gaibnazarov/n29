import {
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

import { CreateUserDto } from './dto/create-user.dto';
import { UpdateUserDto } from './dto/update-user.dto';
import { User } from './entities/user.entity';

@Injectable()
export class UserService {
  constructor(
    @InjectRepository(User)
    private readonly db: Repository<User>,
  ) {}

  async create(createUserDto: CreateUserDto) {
    console.log('ci cd ozgarishi');
    
    const user = await this.db.findOne({
      where: { phone: createUserDto.phone },
    });

    if (user) {
      throw new ConflictException(
        'Bunday telefon raqam allaqachon ro`yxatdan o`tgan',
      );
    }

    const newUser = this.db.create(createUserDto);

    return this.db.save(newUser);
  }

  async findAll() {
    return this.db.find();
  }

  async findOne(id: number) {
    const user = await this.db.findOne({
      where: { id },
    });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return user;
  }

  async update(id: number, updateUserDto: UpdateUserDto) {
    const user = await this.db.findOneBy({ id });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (updateUserDto.phone) {
      const existingUser = await this.db.findOne({
        where: { phone: updateUserDto.phone },
      });

      if (existingUser && existingUser.id !== id) {
        throw new ConflictException(
          'Bunday telefon raqam boshqa userga tegishli',
        );
      }
    }

    Object.assign(user, updateUserDto);

    return this.db.save(user);
  }

  async remove(id: number) {
    const user = await this.db.findOneBy({ id });

    if (!user) {
      throw new NotFoundException('User not found');
    }

    return this.db.delete(id);
  }
}