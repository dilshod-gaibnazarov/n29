import { IsNotEmpty, IsPhoneNumber, IsStrongPassword } from 'class-validator';

export class CreateAdminDto {
  @IsPhoneNumber('UZ')
  @IsNotEmpty()
  phone!: string;

  @IsStrongPassword()
  @IsNotEmpty()
  password!: string;
}
