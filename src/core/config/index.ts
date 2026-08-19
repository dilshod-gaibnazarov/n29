import { config } from 'dotenv';
config();

export const conf = {
  PORT: Number(process.env.PORT),
  DB_URL:
    String(process.env.NODE_ENV) === 'dev'
      ? String(process.env.DB_DEV)
      : String(process.env.DB_PROD),
  SUPERADMIN: {
    PHONE: String(process.env.SUPERADMIN_PHONE),
    PASSWORD: String(process.env.SUPERADMIN_PASS),
  },
  TOKEN: {
    ACCESS_KEY: String(process.env.ACCESS_TOKEN_KEY),
    ACCESS_TIME: String(process.env.ACCESS_TOKEN_TIME),
    REFRESH_KEY: String(process.env.REFRESH_TOKEN_KEY),
    REFRESH_TIME: String(process.env.REFRESH_TOKEN_TIME),
  },
};
