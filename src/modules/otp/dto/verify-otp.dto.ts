import { IsNotEmpty, IsString, Length } from 'class-validator';
import { SendOTPDto } from './send-otp.dto';
import { ApiProperty } from '@nestjs/swagger';

export class VerifyOTPDto extends SendOTPDto {
  @ApiProperty({
    type: String,
    example: '111111',
  })
  @Length(6)
  @IsString()
  @IsNotEmpty()
  code!: string;
}
