import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const PORT = Number(process.env.PORT);

  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true
    })
  )
  console.log('n29 dan serverga salom');
  console.log('dangggg');
  await app.listen(PORT, () => console.log('Server listening on PORT', PORT));
}
bootstrap();
