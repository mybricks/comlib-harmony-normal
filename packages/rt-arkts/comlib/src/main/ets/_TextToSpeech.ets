import { promptAction } from '@kit.ArkUI';
import { call, observer } from '@kit.TelephonyKit'
import { BusinessError } from '@kit.BasicServicesKit';
import { textToSpeech } from '@kit.CoreSpeechKit';

import { AnyType } from './types'

export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  constructor(config?: DataType) {
  }
}

interface Inputs {
  text?: (fn: (number: DataType, relOutputs?: AnyType) => void) => void
}

interface Outputs {
  onStart: (value?: AnyType) => void
  onStop: (value?: AnyType) => void
  onComplete: (value?: AnyType) => void
  onError: (value?: AnyType) => void
}

interface IOContext {
  data: DataType
  inputs: Inputs
  outputs: Outputs
}

export default (context: IOContext) => {
  const data: Data = context.data
  const inputs: Inputs = context.inputs
  const outputs: Outputs = context.outputs


  inputs.text?.((val: AnyType) => {

    textToSpeech.createEngine({
      language: 'zh-CN',
      person: 0,
      online: 1
    }).then((engine: textToSpeech.TextToSpeechEngine) => {
      engine.setListener({
        onStart: (id) => {
          console.info("onStart");
          outputs?.onStart(id)
        },
        onComplete: (id) => {
          console.info("onComplete")
          outputs?.onComplete(id)
        },
        onError: (id, code) => {
          console.error(`Error: ${code}`)
          outputs?.onError(id)
        },
        onStop: (id) => {
          console.log("stop")
          outputs?.onStop(id)
        }
      });

      engine.speak(val, {
        requestId: 'req1',
        extraParams: { speed: 1.2 }
      });

    })


  })

}