import { window } from '@kit.ArkUI';
import { audio } from '@kit.AudioKit';
import { AudioCapturer } from './audio/AudioCapturer';
import { AudioInner } from './audio/AudioInner';
import { JSON } from '@kit.ArkTS';

export interface Data {
  /** 是否自执行 */
  immediate: boolean;
  /**
   * 调用类型
   * start 开始
   * pause 暂停
   * stop 结束/销毁
   * reset 重置
   */
  callType: 'start' | 'pause' | 'stop' | 'reset'
}

interface InputCallValue {
  innerRecorder: boolean
}

interface InputsCallRelOutputs {
  then: (value: ESObject) => void;
}

interface Inputs {
  call: (fn: (value: InputCallValue, relOutputs: InputsCallRelOutputs) => void) => void;
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
let isInnerRecord: boolean = false
let innerRecord: AudioInner

export default (context: IOContext) => {
  const data = context.data;
  const inputs = context.inputs;
  const outputs = context.outputs;

  if (!audioCapturerPromise) {
    audioCapturerPromise = new Promise((resolve) => {
      window.getLastWindow(getContext()).then(async (windowClass) => {
        const uiContext = windowClass.getUIContext();

        // 内录
        innerRecord = new AudioInner({
          uiContext,
          minHeight: 10,
          maxHeight: 50,
        })

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
          clearInterval(intervalId)
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

      innerRecord.addEventListener('readData', (arrayBuffer: ArrayBuffer) => {
        outputs.then(arrayBuffer);
      })
      innerRecord.addEventListener('durationChange', (duration: number) => {
        outputs?.duration(duration)
      })
      innerRecord.addEventListener('amplitudeChange', (amplitude: number) => {
        outputs?.amplitude(amplitude)
      })
    })
  } else {
    inputs.call((callVal: InputCallValue) => {
      audioCapturerPromise.then(async  (audioCapturer) => {
        const callType = data.callType;

        if (callType === 'start') {
          isInnerRecord = callVal?.innerRecorder ?? false
          if (!isInnerRecord) {
            await audioCapturer.start().then((result) => {
              if(result){
                outputs.then(undefined);
              }
            });
          } else {
            innerRecord.start()
            outputs.then(undefined);
          }
        } else if (callType === 'pause') {
          audioCapturer?.stop().then(() => {
            if (!isInnerRecord) {
              outputs.then(undefined);
            }
          });
          innerRecord?.stop()
          if (isInnerRecord) {
            outputs.then(undefined);
          }
        } else if (callType === 'stop') {
          audioCapturer.destroy().then((buffer) => {
            if (!isInnerRecord) {
              outputs.then(buffer);
            }
          });
          innerRecord.destroy().then((buffer) => {
            if (isInnerRecord) {
              outputs.then(buffer);
            }
          });
        } else if (callType === 'reset') {
          audioCapturer?.reset().then((buffer) => {
            if (!isInnerRecord) {
              outputs.then(buffer);
            }
          });
          innerRecord.reset().then((buffer) => {
            if (isInnerRecord) {
              outputs.then(buffer);
            }
          });
        }
      })
    })
  }
}

export type DataType = Data;
