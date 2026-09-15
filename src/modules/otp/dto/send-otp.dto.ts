import { ApiProperty } from '@nestjs/swagger';
import { IsNotEmpty, IsPhoneNumber } from 'class-validator';

export class SendOTPDto {
  @ApiProperty({
    type: String,
    example: '+998990116606'
  })
  @IsPhoneNumber('UZ')
  @IsNotEmpty()
  phone!: string;
}
