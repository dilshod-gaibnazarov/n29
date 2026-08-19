import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsPhoneNumber, IsString } from 'class-validator';

export class SignInDto {
  @ApiProperty({
    type: String,
    example: '+998990116606',
    description: 'Phone number of user',
  })
  @IsPhoneNumber('UZ')
  @IsNotEmpty()
  phone!: string;

  @ApiProperty({
    type: String,
    example: 'Superadmin1!',
    description: 'Password of user',
  })
  @IsString()
  @IsNotEmpty()
  password!: string;
}
