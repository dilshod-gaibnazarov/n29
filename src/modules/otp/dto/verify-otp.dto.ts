import { IsNotEmpty, IsString, Length } from 'class-validator';
import { SendOTPDto } from './send-otp.dto';

export class VerifyOTPDto extends SendOTPDto {
  @Length(6)
  @IsString()
  @IsNotEmpty()
  code!: string;
}
