import { Body, Controller, Post } from '@nestjs/common';
import { AdminService } from './admin.service';
import { AdminDto } from './dto/admin.dto';
import { VerifyOTPDto } from '../otp/dto/verify-otp.dto';

@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) { }

  @Post()
  create(@Body() dto: AdminDto) {
    return this.adminService.create(dto);
  }

  @Post('signin')
  signIn(@Body() dto: AdminDto) {
    return this.adminService.signIn(dto);
  }

  @Post('confirm')
  confirmSignIn(@Body() dto: VerifyOTPDto) {
    return this.adminService.confirmSignIn(dto);
  }
}
