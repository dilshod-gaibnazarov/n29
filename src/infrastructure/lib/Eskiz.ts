import { InternalServerErrorException, Logger } from '@nestjs/common';
import { env } from '../../config';

interface EskizLoginResponse {
  message?: string;
  data?: {
    token?: string;
  };
}

interface EskizSendResponse {
  id?: string;
  message?: string;
  status?: string;
}

export class Eskiz {
  static readonly logger = new Logger(Eskiz.name);
  static token: string | null = null;
  constructor() {}

  static async login(): Promise<string> {
    const formData = new FormData();

    formData.append('email', env.ESKIZ.EMAIL);

    formData.append('password', env.ESKIZ.PASSWORD);

    const response = await fetch(`${env.ESKIZ.BASE_URL}/api/auth/login`, {
      method: 'POST',
      body: formData,
    });
    const data = (await response.json()) as EskizLoginResponse;
    if (!response.ok) {
      this.logger.error(`Eskiz login failed: ${JSON.stringify(data)}`);
      throw new InternalServerErrorException('SMS servisiga ulanishda xatolik');
    }
    const token = data.data?.token;
    if (!token) {
      throw new InternalServerErrorException('Eskiz token olinmadi');
    }
    this.token = token;
    return token;
  }

  static async getToken(): Promise<string> {
    if (Eskiz.token) {
      return Eskiz.token;
    }
    return Eskiz.login();
  }

  static async requestSms(token: string, phone: string, message: string) {
    const formData = new FormData();

    formData.append('mobile_phone', phone);

    formData.append('message', message);

    formData.append('from', env.ESKIZ.FROM);

    return fetch(`${env.ESKIZ.BASE_URL}/api/message/sms/send`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
      },
      body: formData,
    });
  }

  static async sendSms(
    phone: string,
    message: string = 'Bu Eskiz dan test',
  ): Promise<EskizSendResponse> {
    let token = await this.getToken();
    let response = await this.requestSms(token, phone, message);
    if (response.status === 401) {
      Eskiz.token = null;
      token = await Eskiz.login();
      response = await this.requestSms(token, phone, message);
    }
    const data = (await response.json()) as EskizSendResponse;
    if (!response.ok) {
      Eskiz.logger.error(
        `Eskiz SMS failed (${response.status}): ${JSON.stringify(data)}`,
      );
      throw new InternalServerErrorException(
        'SMS yuborishda xatolik yuz berdi',
      );
    }
    return data;
  }
}
