import { Injectable, NotFoundException } from '@nestjs/common';
import { CreatePostInput } from './dto/create-post.input';
import { UpdatePostInput } from './dto/update-post.input';
import { InjectRepository } from '@nestjs/typeorm';
import { Post } from './entities/post.entity';
import { Repository } from 'typeorm';
import { UsersService } from '../users/users.service';

@Injectable()
export class PostsService {
  constructor(
    @InjectRepository(Post) private readonly postRepo: Repository<Post>,
    private readonly userService: UsersService
  ) { }

  async create(createPostInput: CreatePostInput) {
    const user = await this.userService.findOne(createPostInput.userId);
    const newPost = this.postRepo.create({ ...createPostInput, user });
    await this.postRepo.save(newPost);
    return newPost;
  }

  async findAll() {
    return this.postRepo.find({ relations: { user: true } });
  }

  async findOne(id: number) {
    const post = await this.postRepo.findOne({ where: { id }, relations: { user: true } });
    if (!post) {
      throw new NotFoundException('Post not found');
    }
    return post;
  }

  async update(id: number, updatePostInput: UpdatePostInput) {
    await this.findOne(id);
    await this.postRepo.update({ id }, updatePostInput);
    return this.postRepo.findOneBy({ id });
  }

  async remove(id: number) {
    const post = await this.findOne(id);
    await this.postRepo.delete({ id });
    return post;
  }
}
