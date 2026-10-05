import { Column, Entity, ManyToOne, PrimaryGeneratedColumn } from "typeorm";
import { User } from "../../users/entities/user.entity";

@Entity('posts')
export class Post {
    @PrimaryGeneratedColumn()
    id!: number;

    @Column()
    title!: string;

    @Column()
    description!: string;

    @ManyToOne(() => User, user => user.posts, {
        onDelete: 'CASCADE',
        onUpdate: 'CASCADE'
    })
    user!: User;
}
