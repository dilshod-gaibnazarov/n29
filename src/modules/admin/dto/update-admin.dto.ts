import { PartialType } from '@nestjs/swagger';
import { CreateAdminDto } from './create-admin.dto';
import { IsEnum, IsOptional, IsString } from 'class-validator';
import { Status } from '../../../common/enum';

export class UpdateAdminDto extends PartialType(CreateAdminDto) {
  @IsString()
  @IsOptional()
  fullName?: string;

  @IsEnum(Status)
  @IsOptional()
  status?: Status;
}
