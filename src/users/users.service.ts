import { ConflictException, Injectable, NotFoundException } from '@nestjs/common';
import { CreateUserInput } from './dto/create-user.input';
import { UpdateUserInput } from './dto/update-user.input';
import { InjectRepository } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { Repository } from 'typeorm';

@Injectable()
export class UsersService {
  constructor(@InjectRepository(User) private readonly userRepo: Repository<User>) { }

  async create(createUserInput: CreateUserInput) {
    const existsUser = await this.userRepo.findOneBy({ username: createUserInput.username });
    if (existsUser) {
      throw new ConflictException('Username already exists');
    }
    const newUser = this.userRepo.create(createUserInput);
    await this.userRepo.save(newUser);
    return newUser;
  }

  async findAll() {
    return this.userRepo.find({ relations: { posts: true } });
  }

  async findOne(id: number) {
    const user = await this.userRepo.findOne({ where: { id }, relations: { posts: true } });
    if (!user) {
      throw new NotFoundException('User not found');
    }
    return user;
  }

  async update(id: number, updateUserInput: UpdateUserInput) {
    await this.findOne(id);
    await this.userRepo.update({ id }, updateUserInput);
    const updated = await this.userRepo.findOneBy({ id });
    return updated;
  }

  async remove(id: number) {
    const user = await this.findOne(id);
    await this.userRepo.delete({ id });
    return user;
  }
}
