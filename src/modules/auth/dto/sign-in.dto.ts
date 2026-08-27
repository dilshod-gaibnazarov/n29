import { IsNotEmpty, IsPhoneNumber, IsString } from 'class-validator';

export class SignInDto {
  @IsPhoneNumber('UZ')
  @IsNotEmpty()
  phone!: string;

  @IsString()
  @IsNotEmpty()
  password!: string;
}
