import {
  createParamDecorator,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';

export const UserId = createParamDecorator(
  (key: string | undefined, ctx: ExecutionContext) => {
    const req = ctx.switchToHttp().getRequest();
    const userId = req.user?.sub;
    if (!userId) {
      throw new UnauthorizedException('Foydalanuvchi topilmadi');
    }
    return Number(userId);
  },
);
