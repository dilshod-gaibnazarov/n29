import { Res, Body, Controller, Post } from '@nestjs/common';
import { AuthService } from './auth.service';
import { SignInDto } from './dto/sign-in.dto';
import { VerifyOTPDto } from '../otp/dto/verify-otp.dto';
import type { Response } from 'express';
import { RefreshToken } from '../../common/decorator/get-cookie.decorator';
import { successRes } from '../../common/helper/success-response';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) { }

  @Post('signin')
  signIn(@Body() dto: SignInDto) {
    return this.authService.signIn(dto);
  }

  @Post('confirm')
  confirmSignIn(
    @Body() dto: VerifyOTPDto,
    @Res({ passthrough: true }) res: Response
  ) {
    return this.authService.confirmSignIn(dto, res);
  }

  @Post('refresh')
  refreshToken(@RefreshToken() refreshToken: string) {
    return this.authService.refreshToken(refreshToken);
  }

  @Post('signout')
  signout(@Res({ passthrough: true }) res: Response) {
    res.clearCookie('refreshToken');
    return successRes({}, 201);
  }
}
