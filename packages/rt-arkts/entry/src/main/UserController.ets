import { AESEntryUtil, dialogMgr, getRequestInstance, UserInfo } from "base";

export class UserController {
  isUserExist(phone: string): Promise<boolean | undefined> {
    return new Promise<boolean | undefined>((resolve, reject) => {
      getRequestInstance().postJson<boolean>('/admin/liscenes/user/isUserExist', {
        'mobile': phone
      }).then(data => {
        resolve(data);
      }).catch((err: Error) => {
        resolve(undefined);
        dialogMgr.showToast('数据异常');
      })
    })
  }

  sendSmsCode(phone: string): Promise<boolean | undefined> {
    return new Promise<boolean | undefined>((resolve, reject) => {
      getRequestInstance().get<boolean>('/admin/mobile/smsCode', {
        'mobile': phone
      }).then(data => {
        resolve(data);
      }).catch((err: Error) => {
        resolve(undefined);
        dialogMgr.showToast('数据异常');
      })
    })
  }

  checkSmsCode(mobile: string, code: string): Promise<boolean | undefined> {
    return new Promise<boolean | undefined>((resolve, reject) => {
      getRequestInstance().postJson<boolean>('/admin/mobile/checkCode', {
        'mobile': mobile,
        'code': code
      }).then(data => {
        resolve(data);
      }).catch((err: Error) => {
        resolve(undefined);
        dialogMgr.showToast('数据异常');
      })
    })
  }

  register(mobile: string, pwd: string, confirmPwd: string, code: string): Promise<boolean | undefined> {
    if (pwd !== confirmPwd) {
      dialogMgr.showToast('两次密码不一致，请重新确认');
      return Promise.resolve(undefined);
    }
    return new Promise<boolean | undefined>((resolve, reject) => {
      getRequestInstance().postJson<boolean>('/admin/liscenes/user/register', {
        'mobile': mobile,
        'code': code,
        'password': AESEntryUtil.encryptMessage(pwd)
      }).then(data => {
        resolve(data);
      }).catch((err: Error) => {
        resolve(undefined);
        dialogMgr.showToast('数据异常');
      })
    })
  }

  forgetPassword(mobile: string, pwd: string, confirmPwd: string, code: string): Promise<boolean | undefined> {
    if (pwd !== confirmPwd) {
      dialogMgr.showToast('两次密码不一致，请重新确认');
      return Promise.resolve(undefined);
    }
    return new Promise<boolean | undefined>((resolve, reject) => {
      getRequestInstance().postJson<boolean>('/admin/liscenes/password/forgetPassword', {
        'mobile': mobile,
        'code': code,
        'password': AESEntryUtil.encryptMessage(pwd)
      }).then(data => {
        resolve(data);
      }).catch((err: Error) => {
        resolve(undefined);
        dialogMgr.showToast('数据异常');
      })
    })
  }

  setPassword(mobile: string, pwd: string, confirmPwd: string, code: string): Promise<boolean | undefined> {
    if (pwd !== confirmPwd) {
      dialogMgr.showToast('两次密码不一致，请重新确认');
      return Promise.resolve(undefined);
    }
    return new Promise<boolean | undefined>((resolve, reject) => {
      getRequestInstance().postJson<boolean>('/admin/liscenes/password/setPassword', {
        'mobile': mobile,
        'code': code,
        'password': AESEntryUtil.encryptMessage(pwd)
      }).then(data => {
        resolve(data);
      }).catch((err: Error) => {
        resolve(undefined);
        dialogMgr.showToast('数据异常');
      })
    })
  }

  loginByPwd(phone: string, pwd: string): Promise<UserInfo | undefined> {
    return new Promise<UserInfo | undefined>((resolve, reject) => {
      getRequestInstance().postJson<UserInfo>('/admin/liscenes/user/login', {
        'username': phone,
        'password': AESEntryUtil.encryptMessage(pwd)
      }).then(data => {
        resolve(data);
      }).catch((err: Error) => {
        resolve(undefined);
        dialogMgr.showToast('数据异常');
      })
    })
  }

  changePhoneSmsCode(phone: string): Promise<boolean | undefined> {
    return new Promise<boolean | undefined>((resolve, reject) => {
      getRequestInstance().get<boolean>('/admin/liscenes/user/mobile/change/code', {
        'newMobile': phone
      }).then(data => {
        resolve(data);
      }).catch((err: Error) => {
        resolve(undefined);
        dialogMgr.showToast('数据异常');
      })
    })
  }

  changePhone(phone: string, code: string): Promise<boolean | undefined> {
    return new Promise<boolean | undefined>((resolve, reject) => {
      getRequestInstance().postJson<boolean>('/admin/liscenes/user/mobile/change', {
        'newMobile': phone,
        'code': code
      }).then(data => {
        resolve(data);
      }).catch((err: Error) => {
        resolve(undefined);
        dialogMgr.showToast('数据异常');
      })
    })
  }

  loginBySmsCode(phone: string, code: string): Promise<UserInfo | undefined> {
    return new Promise<UserInfo | undefined>((resolve, reject) => {
      getRequestInstance().postJson<UserInfo>('/admin/liscenes/user/sms/login', {
        'mobile': phone,
        'code': code
      }).then(data => {
        resolve(data);
      }).catch((err: Error) => {
        resolve(undefined);
        dialogMgr.showToast('数据异常');
      })
    })
  }

  getUserInfo(): Promise<UserInfo | undefined> {
    return new Promise<UserInfo | undefined>((resolve, reject) => {
      getRequestInstance().get<UserInfo>('admin/liscenes/user/info').then(data => {
        resolve(data);
      }).catch((err: Error) => {
        resolve(undefined);
        dialogMgr.showToast('数据异常');
      })
    })
  }
}