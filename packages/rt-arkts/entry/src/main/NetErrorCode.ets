export namespace NetErrorCode {
  /**
   * 接口请求成功code
   */
  export const HTTP_SUCCESS = 0;

  /**
   * 网络错误
   */
  export const CODE_NET_ERROR = 1002;

  /**
   * 网络请求超时
   */
  export const CODE_TIMEOUT = 1001;

  /**
   * 解析错误
   */
  export const CODE_JSON_PARSE_ERROR = 4010;

  /**
   * 数据结果
   */
  export const CODE_ERROR_DATA = 666;

  /**
   * 登录token失效
   */
  export const HTTP_TOKEN_OVERDUE = 401;

  /**
   * 未知错误
   */
  export const UNKNOWN = 1000;
}