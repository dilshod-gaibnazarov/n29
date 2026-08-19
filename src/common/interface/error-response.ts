export interface IError {
  statusCode: number;
  code: string;
  message: string;
  details?: Record<string, string[]>;
  path: string;
  timestamp: string;
}
