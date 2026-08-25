import { IsNotEmpty, IsPhoneNumber } from 'class-validator';

export class SendOTPDto {
  @IsPhoneNumber('UZ')
  @IsNotEmpty()
  phone!: string;
}
