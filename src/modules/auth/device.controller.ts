import {
  Controller,
  Delete,
  Get,
  Param,
  ParseIntPipe,
  UseGuards,
} from '@nestjs/common';
import { DeviceService } from './device.service';
import { UserId } from '../../common/decorator/current-user.decorator';
import { AuthGuard } from '../../common/guard/jwt-auth.guard';
import { RolesGuard } from '../../common/guard/roles.guard';
import { AccessRoles } from '../../common/decorator/roles.decorator';
import { RefreshToken } from '../../common/decorator/get-cookie.decorator';

@UseGuards(AuthGuard, RolesGuard)
@Controller('device')
export class DeviceController {
  constructor(private readonly deviceService: DeviceService) {}

  @AccessRoles('ID')
  @Get()
  findAll(@UserId() userId: number) {
    return this.deviceService.findAll(userId);
  }

  @AccessRoles('ID')
  @Delete(':id')
  remove(
    @RefreshToken() refreshToken: string,
    @Param('id', ParseIntPipe) id: number,
  ) {
    return this.deviceService.remove(refreshToken, id);
  }
}
