import { Body, Controller, Post, Res } from '@nestjs/common';
import { AuthService } from './auth.service';
import { SignInDto } from './dto/sign-in.dto';
import { ApiResponse } from '@nestjs/swagger';
import { Throttle } from '@nestjs/throttler';
import type { Response } from 'express';
import { RefreshToken } from '../../common/decorator/RefreshToken';
import { successRes } from '../../infrastructure/lib/successRes';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @ApiResponse({
    status: 201,
    example: {
      statusCode: 201,
      data: {
        token: 'token data',
      },
    },
  })
  @ApiResponse({
    status: 400,
    example: {
      statusCode: 400,
      message: 'Phone number or password is wrong',
      error: 'Bad Request',
    },
  })
  @Throttle({ default: { limit: 3, ttl: 60000 } })
  @Post('signin')
  signIn(@Body() dto: SignInDto, @Res({ passthrough: true }) res: Response) {
    return this.authService.signIn(dto, res);
  }

  @ApiResponse({
    status: 201,
    example: {
      statusCode: 201,
      data: {
        token: 'data token',
      },
    },
  })
  @ApiResponse({
    status: 401,
    example: {
      statusCode: 401,
      message: 'Unauthorizated user',
      error: 'Unauthorizated',
    },
  })
  @Post('refresh')
  token(@RefreshToken() refreshToken: string) {
    return this.authService.getToken(refreshToken);
  }

  @ApiResponse({
    status: 201,
    example: {
      statusCode: 201,
      data: {},
    },
  })
  @ApiResponse({
    status: 400,
    example: {
      statusCode: 401,
      message: 'Unauthorizated user',
      error: 'Unauthorizated',
    },
  })
  @Post('signout')
  signout(@Res({ passthrough: true }) res: Response) {
    res.clearCookie('refreshToken');
    return successRes({}, 201);
  }
}
