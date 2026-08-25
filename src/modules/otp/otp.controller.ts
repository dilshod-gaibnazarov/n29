import { Body, Controller, Post } from '@nestjs/common';
import { OtpService } from './otp.service';
import { SendOTPDto } from './dto/send-otp.dto';
import { VerifyOTPDto } from './dto/verify-otp.dto';

@Controller('otp')
export class OtpController {
  constructor(private readonly otpService: OtpService) {}

  @Post('send')
  send(@Body() dto: SendOTPDto) {
    return this.otpService.sendOtp(dto.phone);
  }

  @Post('verify')
  verify(@Body() dto: VerifyOTPDto) {
    return this.otpService.verifyOtp(dto.phone, dto.code);
  }
}
