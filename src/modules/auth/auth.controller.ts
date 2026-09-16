import { Res, Body, Controller, Post, Req } from '@nestjs/common';
import { AuthService } from './auth.service';
import { SignInDto } from './dto/sign-in.dto';
import { VerifyOTPDto } from '../otp/dto/verify-otp.dto';
import type { Response, Request } from 'express';
import { RefreshToken } from '../../common/decorator/get-cookie.decorator';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('signin')
  signIn(@Body() dto: SignInDto) {
    return this.authService.signIn(dto);
  }

  @Post('confirm')
  confirmSignIn(
    @Body() dto: VerifyOTPDto,
    @Req() req: Request,
    @Res({ passthrough: true }) res: Response,
  ) {
    return this.authService.confirmSignIn(dto, req, res);
  }

  @Post('refresh')
  refreshToken(
    @RefreshToken() refreshToken: string,
    @Res({ passthrough: true }) res: Response,
  ) {
    return this.authService.refreshToken(refreshToken, res);
  }

  @Post('signout')
  signout(
    @RefreshToken() refreshToken: string,
    @Res({ passthrough: true }) res: Response,
  ) {
    return this.authService.signOut(refreshToken, res);
  }
}
