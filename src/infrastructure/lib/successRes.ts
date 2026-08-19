import { ISuccess } from '../../common/interface/success-response';

export async function successRes(
  data: object,
  statusCode: number = 200,
): Promise<ISuccess> {
  return {
    statusCode,
    data,
  };
}
