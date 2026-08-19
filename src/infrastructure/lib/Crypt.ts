import bcrypt from 'bcrypt';

export class Crypt {
  static async hash(data: string) {
    const hashedData = await bcrypt.hash(data, 7);
    return hashedData;
  }

  static async compare(data: string, hashedData: string) {
    return bcrypt.compare(data, hashedData);
  }
}
