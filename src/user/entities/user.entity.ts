import { Column, Entity, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class User {
  @PrimaryGeneratedColumn()
  id!: number;

  @Column({
    type: String
  })
  fullName!: string;

  @Column({
    type: String,
    unique: true 
})
  phone!: string;
}