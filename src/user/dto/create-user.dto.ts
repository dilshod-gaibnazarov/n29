import { IsString, IsPhoneNumber, IsNotEmpty } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @IsNotEmpty()
  fullName!: string;

  @IsPhoneNumber('UZ')
  @IsString()
  @IsNotEmpty()
  phone!: string;
}
