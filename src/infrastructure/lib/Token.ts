import { IPayload } from '../../common/interface/payload-token';
import { JwtService, JwtSignOptions } from '@nestjs/jwt';
import { conf } from '../../core/config';
import { UnauthorizedException } from '@nestjs/common';

export class Token {
  private static readonly jwt = new JwtService();

  static async generateAccess(payload: IPayload) {
    return this.jwt.signAsync(payload, {
      secret: conf.TOKEN.ACCESS_KEY,
      expiresIn: conf.TOKEN.ACCESS_TIME as JwtSignOptions['expiresIn'],
    });
  }

  static async generateRefresh(payload: IPayload) {
    return this.jwt.signAsync(payload, {
      secret: conf.TOKEN.REFRESH_KEY,
      expiresIn: conf.TOKEN.REFRESH_TIME as JwtSignOptions['expiresIn'],
    });
  }

  static async verifyRefreshToken(refreshToken: string) {
    try {
      const verifiedData = await this.jwt.verifyAsync(refreshToken, {
        secret: conf.TOKEN.REFRESH_KEY,
      });
      return verifiedData;
    } catch (error) {
      throw new UnauthorizedException('Tizimga kirishda nosozlik');
    }
  }
}
