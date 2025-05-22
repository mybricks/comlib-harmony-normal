import { JSON } from "@kit.ArkTS";
import { spManager } from "../data/SpManager";
import { UserInfo } from "./UserInfo";

const USER_SP_NAME = 'user_info';

class UserInfoMgr {
  private userInfo?: UserInfo;
  private loginStatusListenerArray: LoginStatusListener[] = [];
  private userInfoChangeListenerArray: UserInfoChangeListener[] = [];

  constructor() {
  }

  initCacheInfo() {
    const cacheInfo = spManager.getStringSync(USER_SP_NAME, '');
    if (!cacheInfo) {
      return;
    }
    this.userInfo = JSON.parse(cacheInfo) as UserInfo;
  }

  getUserInfo() {
    return this.userInfo;
  }

  updateUserInfo(userInfo?: UserInfo) {
    this.userInfo = this.userInfo;
    let userStr = ''
    if (userInfo) {
      userStr = JSON.stringify(userInfo);
    }
    spManager.putStringSync(USER_SP_NAME, userStr);
  }

  isLogin(): boolean {
    return this.userInfo ? true : false;
  }

  addLoginStatusListener(loginStatusListener: LoginStatusListener) {
    this.loginStatusListenerArray.push(loginStatusListener);
  }

  removeBackPressListener(loginStatusListener: LoginStatusListener) {
    const index = this.loginStatusListenerArray.indexOf(loginStatusListener);
    if (index < 0) {
      return;
    }
    this.loginStatusListenerArray.splice(index, 1);
  }

  addUserInfoChangeListener(userInfoChangeListener: UserInfoChangeListener) {
    this.userInfoChangeListenerArray.push(userInfoChangeListener);
  }

  removeUserInfoChangeListener(userInfoChangeListener: UserInfoChangeListener) {
    const index = this.userInfoChangeListenerArray.indexOf(userInfoChangeListener);
    if (index < 0) {
      return;
    }
    this.userInfoChangeListenerArray.splice(index, 1);
  }
}

export interface LoginStatusListener {
  onLogin: () => void;
  onLogout: () => void;
}

export interface UserInfoChangeListener {
  onUserInfoChanged: (userInfo: UserInfo) => void;
}

export const userInfoMgr: UserInfoMgr = new UserInfoMgr();

