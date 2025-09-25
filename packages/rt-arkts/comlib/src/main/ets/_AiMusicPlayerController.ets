import { mediaPlayer, PlayState } from './AiMusic/Index'

import { AnyType } from './types'

export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  @Trace type: string
  @Trace immediate: boolean

  constructor(config?: DataType) {
    this.immediate = config?.immediate ?? false
    this.type = config?.type
  }
}

interface Inputs {
  call?: (fn: (number: DataType, relOutputs?: AnyType) => void) => void
}

interface Outputs {
  then: (value?: AnyType) => void
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

  if (data.immediate) {
    mediaPlayer.onStateChange((state: string) => {
      if (state === 'playing' && data.type === 'onPlay') {
        outputs?.then()
      }
      if (state === 'paused' && data.type === 'onPause') {
        outputs?.then()
      }
    })
  } else {
    inputs.call?.((val: AnyType) => {
      switch (true) {
        case data.type === 'play': {
          mediaPlayer.resume();
          outputs?.then()
          return
        }
        case data.type === 'pause': {
          mediaPlayer.pause();
          outputs?.then()
          return
        }
        case data.type === 'playSong': {
          if (val?.file?.cloudFileUrl ?? val?.file?.localFileUrl) {
            mediaPlayer.play(val?.file?.cloudFileUrl ?? val?.file?.localFileUrl)
            outputs?.then()
          }
          return
        }
        case data.type === 'setPlayList': {

        }
        case data.type === 'editSong': {

        }
      }
    })
  }
}