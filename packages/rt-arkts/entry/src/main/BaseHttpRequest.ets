import axios, { AxiosError, AxiosHeaders, AxiosInstance, AxiosResponse, RawAxiosRequestHeaders } from "@ohos/axios";
import { HttpConfig } from "./HttpConfig";
import deviceInfo from "@ohos.deviceInfo";
import { logger } from "../utils/Logger";
import { BaseResponse } from "./BaseResponse";
import { NetErrorCode } from "./NetErrorCode";

const TAG: string = "requestInfo";

class BaseHttpRequest {
  private axiosInstance?: AxiosInstance;

  constructor() {
  }

  init(versionName: string, userToken?: string) {
    this.axiosInstance = axios.create({
      baseURL: HttpConfig.BASE_URL,
      timeout: 3000,
      headers: {
        "system": "HarmonyOs",
        "system-version": deviceInfo.distributionOSVersion,
        "version": versionName,
        "liscenes-token": userToken
      }
    });
  }

  get<T>(url: string, param?: Record<string, string | number>): Promise<T | undefined> {
    return new Promise<T | undefined>((resolve, reject) => {
      this.axiosInstance?.get<BaseResponse<T>, AxiosResponse<BaseResponse<T>>, null>(url, { params: param })
        .then((response: AxiosResponse<BaseResponse<T>>) => {
          if (!response || !response.data) {
            resolve(undefined);
          }
          if (response.data.code === NetErrorCode.HTTP_SUCCESS) {
            resolve(response.data.data)
            return;
          }
          this.dealErrorCode(response.data.code);
          resolve(undefined);
        })
        .catch((error: AxiosError) => {
          logger.info(TAG, `request error: ${error.code}, message: ${error.message}`);
          reject(error);
          this.dealErrorCode(Number(error.code));
        })
    })
  }

  postJson<T>(url: string, param?: Record<string, string | number>): Promise<T | undefined> {
    return new Promise<T | undefined>((resolve, reject) => {
      this.axiosInstance?.post<BaseResponse<T>, AxiosResponse<BaseResponse<T>>, Record<string, string | number>>(url,
        param, {
          headers: {
            'Content-Type': 'application/json',
            'Accept': '*/*'
          }
        })
        .then((response: AxiosResponse<BaseResponse<T>>) => {
          if (!response || !response.data) {
            resolve(undefined);
          }
          if (response.data.code === NetErrorCode.HTTP_SUCCESS) {
            resolve(response.data.data)
            return;
          }
          this.dealErrorCode(response.data.code);
          resolve(undefined);
        })
        .catch((error: AxiosError) => {
          logger.info(TAG, `request error: ${error.code}, message: ${error.message}`);
          reject(error);
          this.dealErrorCode(Number(error.code));
        })
    })
  }

  dealErrorCode(code: number) {
    // todo 登录失效，跳转登录页面
    if (code === NetErrorCode.HTTP_TOKEN_OVERDUE) {

    }
  }
}

let _request: BaseHttpRequest | undefined = undefined;

export function getRequestInstance(): BaseHttpRequest {
  if (!_request) {
    _request = new BaseHttpRequest();
  }
  return _request;
}



