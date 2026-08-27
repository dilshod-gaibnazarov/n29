import { IPayload } from '../../common/interface/IPayload.interface';
import { JwtService, JwtSignOptions } from '@nestjs/jwt';
import { env } from '../../config';
import { UnauthorizedException } from '@nestjs/common';

export class Token {
  private static readonly jwt = new JwtService();

  static async generateAccess(payload: IPayload) {
    return this.jwt.signAsync(payload, {
      secret: env.TOKEN.ACCESS_KEY,
      expiresIn: env.TOKEN.ACCESS_TIME as JwtSignOptions['expiresIn'],
    });
  }

  static async generateRefresh(payload: IPayload) {
    return this.jwt.signAsync(payload, {
      secret: env.TOKEN.REFRESH_KEY,
      expiresIn: env.TOKEN.REFRESH_TIME as JwtSignOptions['expiresIn'],
    });
  }

  static async verifyRefreshToken(refreshToken: string) {
    try {
      const verifiedData = await this.jwt.verifyAsync(refreshToken, {
        secret: env.TOKEN.REFRESH_KEY,
      });
      return verifiedData;
    } catch (error) {
      throw new UnauthorizedException('Tizimga kirishda nosozlik');
    }
  }
}
