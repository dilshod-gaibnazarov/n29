import { ObjectType, Field, Int } from '@nestjs/graphql';

@ObjectType()
export class User {
  @Field(() => Int)
  id!: number;

  @Field()
  username!: string;

  @Field()
  password!: string;

  @Field()
  createdAt!: Date;

  @Field()
  updatedAt!: Date;
}
