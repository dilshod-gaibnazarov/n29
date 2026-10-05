import { Column, Entity, OneToMany, PrimaryGeneratedColumn } from 'typeorm';
import { Post } from '../../posts/entities/post.entity';

@Entity('users')
export class User {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column({ type: 'varchar', unique: true })
    username!: string;

    @Column({ type: 'varchar' })
    fullName!: string;

    @OneToMany(() => Post, posts => posts.user)
    posts!: Post[];
}
