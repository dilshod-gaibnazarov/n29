import { config } from 'dotenv';
config();

export const env = {
  PORT: Number(process.env.PORT),
  DB_URI: String(process.env.DB_URI),
  SUPERADMIN: {
    PHONE: String(process.env.SUPERADMIN_PHONE),
    PASSWORD: String(process.env.SUPERADMIN_PASSWORD),
  },
  REDIS_URL: String(process.env.REDIS_URL),
  OTP: {
    TTL: Number(process.env.OTP_TTL),
    RESEND: Number(process.env.OTP_RESEND),
    ATTEMPTS: Number(process.env.OTP_ATTEMPTS),
    SECRET: String(process.env.OTP_SECRET),
  },
  ESKIZ: {
    BASE_URL: String(process.env.ESKIZ_BASE_URL),
    EMAIL: String(process.env.ESKIZ_EMAIL),
    PASSWORD: String(process.env.ESKIZ_PASSWORD),
    FROM: String(process.env.ESKIZ_FROM),
  },
};
