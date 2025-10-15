import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit';

export class PermissionUtil {
  static async requestPermissionsFromUser(permission: Permissions, context: common.UIAbilityContext) {
    const atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    const result = await atManager.requestPermissionsFromUser(context, [permission]);
    return result.authResults[0] === 0;
  }
}
