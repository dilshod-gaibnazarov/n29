import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { conf } from './core/config';
import { ValidationPipe } from '@nestjs/common';
import helmet from 'helmet';
import cookieParser from 'cookie-parser';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';

export class App {
  static async main() {
    const app = await NestFactory.create(AppModule);
    const PORT = conf.PORT;

    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        forbidNonWhitelisted: true,
        transform: true,
      }),
    );

    app.use(helmet());

    app.use(cookieParser());

    app.enableCors('127.0.0.1'); // replace prod mode
    const docs = '/api/v1';
    app.setGlobalPrefix(docs);
    const config = new DocumentBuilder()
      .setTitle('N29 ERP backend')
      .setDescription('Bu education organizationlar uchun ERP')
      .setVersion('1.0')
      .build();
    const documentFactory = () => SwaggerModule.createDocument(app, config);
    SwaggerModule.setup(`${docs}/docs`, app, documentFactory);

    app.listen(PORT, () => console.log('Server running on port', PORT));
  }
}
