import { abilityAccessCtrl, bundleManager, Permissions, common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';

interface CheckRes {
  success: Boolean;
  result?: abilityAccessCtrl.GrantStatus;
  error?: BusinessError
}

export interface RequestResResult {
  authResult: number
  dialogShownResult: Boolean
}
interface RequestRes {
  success: Boolean;
  result?: RequestResResult,
  error?: BusinessError
}

// 检查当前应用程序是否已经被授予权限
export async function checkPermissionGrant(permission: Permissions): Promise<CheckRes> {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  let grantStatus: abilityAccessCtrl.GrantStatus = abilityAccessCtrl.GrantStatus.PERMISSION_DENIED;

  // 获取应用程序的accessTokenID。
  let tokenId: number = 0;
  try {
    let bundleInfo: bundleManager.BundleInfo = await bundleManager.getBundleInfoForSelf(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    let appInfo: bundleManager.ApplicationInfo = bundleInfo.appInfo;
    tokenId = appInfo.accessTokenId;
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to get bundle info for self, code: ${err.code}, message: ${err.message}`);
    return {
      success: false,
      error: err
    }
  }

  // 校验应用是否被授予权限。
  try {
    grantStatus = await atManager.checkAccessToken(tokenId, permission);
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to check access token, code: ${err.code}, message: ${err.message}`);
    return {
      success: false,
      error: err
    }
  }

  return {
    success: true,
    result: grantStatus
  };
}

// 动态向用户申请授权
export async function reqPermissionsFromUser(permissions: Permissions, context: common.UIAbilityContext): Promise<RequestRes> {
  let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  try {
    const res = await atManager.requestPermissionsFromUser(context, [permissions])
    const authResult = res.authResults[0]
    const dialogShownResult = res.dialogShownResults?.[0] ?? false
    if (authResult === 0) {
      return {
        success: true,
        result: {
          authResult,
          dialogShownResult
        }
      }
    } else {
      return {
        success: false,
        result: {
          authResult,
          dialogShownResult
        }
      }
    }
  } catch (error) {
    const err: BusinessError = error as BusinessError;
    console.error(`Failed to request permissions from user. Code is ${err.code}, message is ${err.message}`);
    return {
      success: false,
      error: err
    }
  }
}