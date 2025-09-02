import { window } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { AnyType } from './types';

export type DataType = AnyType;

@ObservedV2
export class Data implements DataType {
  constructor(config?: DataType) {
    // Constructor implementation
  }
}

interface Inputs {
  setPreferences?: (fn: (val: AnyType, relOutputs?: AnyType) => void) => void;
}

interface Outputs {
  onSuccess: (value?: AnyType) => void;
  onFail: (value?: AnyType) => void;
}

interface IOContext {
  data: DataType;
  inputs: Inputs;
  outputs: Outputs;
}

export default (context: IOContext) => {
  const data: Data = context.data;
  const inputs: Inputs = context.inputs;
  const outputs: Outputs = context.outputs;

  const PREFERENCES_NAME = 'app_preferences';

  let preferencesInstance: preferences.Preferences | null = null;

  inputs?.setPreferences?.(async (val: AnyType) => {
    try {
      const windowClass = await window.getLastWindow(getContext());
      const uiContext = windowClass.getUIContext().getHostContext();

      preferencesInstance = await new Promise((resolve, reject) => {
        preferences.getPreferences(uiContext, PREFERENCES_NAME, (err: BusinessError, val: preferences.Preferences) => {
          if (err) {
            reject(err);
            return;
          }
          resolve(val);
        });
      });

      console.log(`Preferences实例[${PREFERENCES_NAME}]初始化成功`);

      if (!preferencesInstance) {
        outputs.onFail?.({
          errorCode: 15500000,
          errorMsg: 'Preferences实例未初始化'
        });
        return;
      }

      const keys = Object.keys(val);
      for (const key of keys) {
        await preferencesInstance.put(key, val[key]);
        console.info(`存储成功: key=${key}, value=${val[key]}`);
      }

      await preferencesInstance.flush();
      outputs?.onSuccess?.(val);

    } catch (err) {
      const e = err as BusinessError;
      console.error(`操作失败: code=${e.code}, message=${e.message}`);
      outputs?.onFail?.({
        errorCode: e.code,
        errorMsg: e.message
      });
    }
  });
};