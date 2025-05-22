//支付平台代码(微信002，支付宝003，云闪付004,电子储值卡009)
export const PAY_METHOD_WX = "002"
export const PAY_METHOD_ALI = "003"
export const PAY_METHOD_CLOUD = "004"
export const PAY_METHOD_WALLET = "009"

export class UserInfo {
  userId: number = 0;
  /**
   * 用户名
   */
  username: string = "";
  /**
   * 电话号码
   */
  phone: string = "";
  /**
   * 头像地址
   */
  avatar: string = "";
  /**
   * 用户code
   */
  userCode: string = "";
  /**
   * 全名
   */
  fullName: string = "";
  /**
   * 用户token
   */
  token?: string;
  /**
   * 支付方式信息
   */
  payInfo?: PayInfo;
}

export class PayInfo {
  /**
   * 是否开通人脸
   */
  openFace: boolean = false;
  /**
   * 是否实名
   */
  isCertified: boolean = false;
  openTime?: string;
  certName: string = '';
  certNo: string = '';
  methodList?: PayAccount[];
}

export class PayAccount {
  payMethod: string = '';
  active: boolean = false;
  locked: boolean = false;
  signTime: string = "";
  //0-签约中 1-签约 2-解约 3-解约中 目前未用到
  status: number = 0;
}