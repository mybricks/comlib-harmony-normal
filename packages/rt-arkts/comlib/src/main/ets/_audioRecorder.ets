import { window } from '@kit.ArkUI';
import { audio } from '@kit.AudioKit';
import { AudioCapturer } from './audio/AudioCapturer';

export interface Data {
  /** 是否自执行 */
  immediate: boolean;
  /**
   * 调用类型
   * start 开始
   * pause 暂停
   * stop 结束/销毁
   */
  callType: 'start' | 'pause' | 'stop'
}

interface InputsCallRelOutputs {
  then: (value: ESObject) => void;
}

interface Inputs {
  call: (fn: (value: string, relOutputs: InputsCallRelOutputs) => void) => void;
}

interface Outputs {
  then: (value: ESObject) => void;
  amplitude: (value: number) => void;
  duration: (value: number) => void;
}

interface IOContext {
  data: Data;
  inputs: Inputs;
  outputs: Outputs;
}

let audioCapturerPromise: Promise<AudioCapturer>

export default (context: IOContext) => {
  const data = context.data;
  const inputs = context.inputs;
  const outputs = context.outputs;

  if (!audioCapturerPromise) {
    audioCapturerPromise = new Promise((resolve) => {
      window.getLastWindow(getContext()).then(async (windowClass) => {
        const uiContext = windowClass.getUIContext();
        resolve(new AudioCapturer({
          uiContext,
          minHeight: 10,
          maxHeight: 50
        }));
      })
    })
  }

  if (data.immediate) {
    audioCapturerPromise.then((audioCapturer) => {
      let intervalId: number | undefined;
      // 监听状态变更
      audioCapturer.addEventListener('stateChange', (state: audio.AudioState) => {
        if (state === audio.AudioState.STATE_RUNNING) {
          intervalId = setInterval(async () => {
            outputs.amplitude(audioCapturer.calculateDecibelHeight())
            outputs.duration(await audioCapturer.getDuration())
          }, 80)
        } else {
          clearInterval(intervalId);
          intervalId = undefined;
        }
      })

      audioCapturer.addEventListener('readData', (arrayBuffer: ArrayBuffer) => {
        outputs.then(arrayBuffer);
      })
    })
  } else {
    inputs.call(() => {
      audioCapturerPromise.then((audioCapturer) => {
        const callType = data.callType;
        if (callType === 'start') {
          audioCapturer.start().then((result) => {
            if(result){
              outputs.then(undefined);
            }
          });
        } else if (callType === 'pause') {
          audioCapturer.stop().then(() => {
            outputs.then(undefined);
          });
        } else if (callType === 'stop') {
          audioCapturer.destroy().then((buffer) => {
            outputs.then(buffer);
          });
        }
      })
    })
  }
}

export type DataType = Data;
