import { Module } from '@nestjs/common';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { OtpModule } from '../otp/otp.module';
import { DeviceController } from './device.controller';
import { DeviceService } from './device.service';

@Module({
  imports: [OtpModule],
  controllers: [AuthController, DeviceController],
  providers: [AuthService, DeviceService],
})
export class AuthModule {}
