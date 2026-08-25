import {
  BadRequestException,
  HttpException,
  HttpStatus,
  Injectable,
} from '@nestjs/common';
import { createHmac, randomInt } from 'crypto';
// import { Eskiz } from '../../infrastructure/lib/Eskiz';
import { RedisService } from '../../config/redis/redis.service';
import { env } from '../../config';

@Injectable()
export class OtpService {
  constructor(private readonly redisService: RedisService) {}

  private normalizePhone(value: string): string {
    const phone = value.replace(/\D/g, '');
    if (!/^998\d{9}$/.test(phone)) {
      throw new BadRequestException(
        'Telefon raqam noto‘g‘ri. Masalan: +998901234567',
      );
    }
    return phone;
  }

  private generateOtp(): string {
    return randomInt(0, 1_000_000).toString().padStart(6, '0');
  }

  private hashOtp(phone: string, code: string): string {
    return createHmac('sha256', env.OTP.SECRET)
      .update(`${phone}:${code}`)
      .digest('hex');
  }

  private otpKey(phone: string) {
    return `otp:value:${phone}`;
  }

  private attemptsKey(phone: string) {
    return `otp:attempts:${phone}`;
  }

  private resendKey(phone: string) {
    return `otp:resend:${phone}`;
  }

  async sendOtp(phoneInput: string) {
    const redis = this.redisService.client;
    const phone = this.normalizePhone(phoneInput);
    const otpKey = this.otpKey(phone);
    const attemptsKey = this.attemptsKey(phone);
    const resendKey = this.resendKey(phone);
    const cooldown = await redis.set(
      resendKey,
      '1',
      'EX',
      env.OTP.RESEND,
      'NX',
    );

    if (cooldown !== 'OK') {
      const remaining = await redis.ttl(resendKey);
      throw new HttpException(
        {
          statusCode: HttpStatus.TOO_MANY_REQUESTS,
          message: `OTP qayta yuborish uchun ${Math.max(
            remaining,
            1,
          )} sekund kuting`,
          retryAfter: Math.max(remaining, 1),
        },
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }
    const code = this.generateOtp();
    const otpHash = this.hashOtp(phone, code);
    try {
      await redis
        .multi()
        .set(otpKey, otpHash, 'EX', env.OTP.TTL)
        .set(attemptsKey, '0', 'EX', env.OTP.TTL)
        .exec();
      // await Eskiz.sendSms(phone);
    } catch (error) {
      await redis.del(otpKey, attemptsKey, resendKey);
      throw error;
    }
    return {
      code,
      expiresIn: env.OTP.TTL,
      resendAfter: env.OTP.RESEND,
    };
  }

  async verifyOtp(phoneInput: string, code: string) {
    const redis = this.redisService.client;
    const phone = this.normalizePhone(phoneInput);
    const otpKey = this.otpKey(phone);
    const attemptsKey = this.attemptsKey(phone);
    const candidateHash = this.hashOtp(phone, code);
    const script = `
      local stored = redis.call('GET', KEYS[1])

      if not stored then
        return -2
      end

      local attempts =
        tonumber(redis.call('GET', KEYS[2]) or '0')

      local maxAttempts =
        tonumber(ARGV[2])

      if attempts >= maxAttempts then
        redis.call('DEL', KEYS[1], KEYS[2])
        return -1
      end

      if stored == ARGV[1] then
        redis.call('DEL', KEYS[1], KEYS[2])
        return 1
      end

      attempts =
        redis.call('INCR', KEYS[2])

      local otpTtl =
        redis.call('TTL', KEYS[1])

      if otpTtl > 0 then
        redis.call(
          'EXPIRE',
          KEYS[2],
          otpTtl
        )
      end

      if attempts >= maxAttempts then
        redis.call('DEL', KEYS[1], KEYS[2])
        return -1
      end

      return 0
    `;

    const result = Number(
      await redis.eval(
        script,
        2,
        otpKey,
        attemptsKey,
        candidateHash,
        String(env.OTP.ATTEMPTS),
      ),
    );

    if (result === -2) {
      throw new BadRequestException(
        'OTP kodi mavjud emas yoki muddati tugagan',
      );
    }

    if (result === -1) {
      throw new HttpException(
        {
          statusCode: HttpStatus.TOO_MANY_REQUESTS,

          message: 'OTP kiritish urinishlari soni tugadi. Yangi kod so‘rang.',
        },

        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    if (result === 0) {
      throw new BadRequestException('OTP kodi noto‘g‘ri');
    }

    return {
      success: true,
      verified: true,
      phone,
    };
  }
}
