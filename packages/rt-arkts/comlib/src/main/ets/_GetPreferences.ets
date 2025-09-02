import { window } from '@kit.ArkUI';
import { preferences } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { AnyType } from './types';

export type DataType = AnyType;

@ObservedV2
export class Data implements DataType {
  @Trace useDynamicKey: boolean = false
  @Trace key: string = ''
  constructor(config?: DataType) {
    this.useDynamicKey = config?.useDynamicKey
    this.key = config?.key
  }
}

interface Inputs {
  getPreferences?: (fn: (key: AnyType, relOutputs?: AnyType) => void) => void;
}

interface Outputs {
  onComplete: (value?: AnyType) => void;
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


  inputs?.getPreferences?.(async (key: AnyType) => {
    let _key:AnyType = ''
    if(data?.useDynamicKey){
      _key = key
    }else {
      _key = data.key
    }
    try {
      const windowClass = await window.getLastWindow(getContext());
      const uiContext = windowClass.getUIContext().getHostContext();

      preferencesInstance = await new Promise<preferences.Preferences>((resolve, reject) => {
        preferences.getPreferences(uiContext, PREFERENCES_NAME, (err: BusinessError, val: preferences.Preferences) => {
          if (err) {
            reject(err);
            return;
          }
          resolve(val);
        });
      });

      console.log(`Preferences实例[${PREFERENCES_NAME}]初始化成功`);


        try {
          if (!preferencesInstance) {
            return
          }

          const value = await preferencesInstance.get(_key, null);
          console.info(`获取缓存成功: key=${_key}, value=${value}`);
          outputs?.onComplete?.(value);
        } catch (err) {
          const e = err as BusinessError;
          console.error(`获取缓存失败: code=${e.code}, message=${e.message}`);
          outputs?.onComplete?.(null);
        }


    } catch (err) {
      const e = err as BusinessError;
      console.error(`操作失败: code=${e.code}, message=${e.message}`);
      outputs.onFail?.(e);
    }

  });
};