import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UsersModule } from './users/users.module';
import { PostsModule } from './posts/posts.module';
import { GraphQLModule } from '@nestjs/graphql';
import { ApolloDriver, ApolloDriverConfig } from '@nestjs/apollo';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env'
    }),
    TypeOrmModule.forRoot({
      type: 'postgres',
      url: String(process.env.DB_URL),
      autoLoadEntities: true,
      synchronize: true,
      entities: [process.cwd() + '/**/*.entity{.ts}']
    }),
    GraphQLModule.forRoot<ApolloDriverConfig>({
      driver: ApolloDriver,
      graphiql: true,
      typePaths: ['./**/*.graphql'],
    }),
    UsersModule,
    PostsModule
  ]
})
export class AppModule { }
