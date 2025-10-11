// import { mediaPlayer, PlayState } from './AiMusic/Index'

import MediaPlayer, { PlayState } from './AiMusic/model/AppMusicMediaPlayer'

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

    MediaPlayer.addEventListener("stateChange", (state: string) => {
      if (state === "playing" && data.type === 'onPlay') {
        outputs?.then()
      } else if (state === "paused" && data.type === 'onPause') {
        outputs?.then()
      }
    })


    // MediaPlayer.setPlayListener('stateChange', (playState: AnyType) => {
    //   if (playState === PlayState.playing && data.type === 'onPlay') {
    //     outputs?.then()
    //   } else if (playState === PlayState.paused && data.type === 'onPause') {
    //     outputs?.then()
    //   }
    // })


    // mediaPlayer.stateChange((state: string) => {
    //   if (state === 'playing' && data.type === 'onPlay') {
    //     outputs?.then()
    //   }
    //   if (state === 'paused' && data.type === 'onPause') {
    //     outputs?.then()
    //   }
    // })
    if (data.type === 'onChange') {
      MediaPlayer.addEventListener("onChange", (audio: AnyType) => {
        outputs?.then(audio)
      })


      // MediaPlayer.setPlayListener('onChange', (PlayState: AnyType) => {
      //   outputs?.then()
      // })

      // mediaPlayer.onChange((work: AnyType) => {
      //   outputs?.then(work)
      // })
    }
  } else {
    inputs.call?.(async (val: AnyType) => {
      switch (true) {
        case data.type === 'play': {
          if (MediaPlayer.targetAudio?.file?.cloudFileUrl) {
            // MediaPlayer.startVinylRotation();
            await MediaPlayer.play();
            outputs?.then()
          } else {
            console.error('No audio source available');
          }
          // if (MediaPlayer.currentSong?.file?.cloudFileUrl) {
          //   // MediaPlayer.startVinylRotation();
          //   await MediaPlayer.play();
          //   outputs?.then()
          // } else {
          //   console.error('No audio source available');
          // }

          return
        }
        case data.type === 'pause': {
          // MediaPlayer.stopVinylRotation();
          await MediaPlayer.pause();
          outputs?.then()
          return
        }
        case data.type === 'playSong': {
          if (val) {

            // const index = MediaPlayer.audioList?.findIndex((audio) => {
            //   return audio.file.id === val.id
            // })
            //
            // MediaPlayer.setAudioListIndex(index === -1 ? 0 : index)
            // MediaPlayer.setTargetAudio(val)

            MediaPlayer.play(val)

            // MediaPlayer.startVinylRotation();
            // await MediaPlayer.play();
            // mediaPlayer.play(val)
            outputs?.then()
          }
          return
        }
        case data.type === 'setPlayList': {
          // mediaPlayer.setPlaylist(val)

          MediaPlayer.setAudioList(val)
          MediaPlayer.setAudioListIndex(0)
          MediaPlayer.setTargetAudio(val[0])

          // // 设置初始时长（duration 已经是以秒为单位）
          // if (MediaPlayer.currentSong.file.duration > 0) {
          //   MediaPlayer.time = {
          //     currentTime: 0,
          //     duration: MediaPlayer.currentSong.file.duration
          //   }
          //   // MediaPlayer.duration = MediaPlayer.currentSong.file.duration
          // }
          //
          // // 解析歌词
          // MediaPlayer.parseLyrics()
          return
        }
        case data.type === 'editSong': {

        }
      }
    })
  }
}