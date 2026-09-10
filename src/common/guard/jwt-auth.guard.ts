import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { Token } from '../../infrastructure/lib/Token';

@Injectable()
export class AuthGuard implements CanActivate {
  async canActivate(context: ExecutionContext) {
    const req = context.switchToHttp().getRequest();
    const accessToken = req.cookies?.accessToken;
    if (!accessToken) {
      throw new UnauthorizedException('Tizimga kirishda nosozlik');
    }
    const data = await Token.verifyAccessToken(accessToken);
    if (!data) {
      throw new UnauthorizedException('Tizimga kirishda nosozlik');
    }
    req.user = { id: data.id, role: data.role, status: data.status };
    return true;
  }
}
