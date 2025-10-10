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
    MediaPlayer.setPlayListener('stateChange',(PlayState :AnyType) => {
      console.log("stateChange",PlayState)
      if (PlayState === 'playing' && data.type === 'onPlay') {
        outputs?.then()
      }
      if (PlayState === 'paused' && data.type === 'onPause') {
        outputs?.then()
      }
    })


    // mediaPlayer.stateChange((state: string) => {
    //   if (state === 'playing' && data.type === 'onPlay') {
    //     outputs?.then()
    //   }
    //   if (state === 'paused' && data.type === 'onPause') {
    //     outputs?.then()
    //   }
    // })
    if (data.type === 'onChange') {
      MediaPlayer.setPlayListener('onChange',(PlayState :AnyType) => {
          outputs?.then()
      })

      // mediaPlayer.onChange((work: AnyType) => {
      //   outputs?.then(work)
      // })
    }
  } else {
    inputs.call?.(async (val: AnyType) => {
      switch (true) {
        case data.type === 'play': {
          if (MediaPlayer.currentSong?.file?.cloudFileUrl) {
            MediaPlayer.startVinylRotation();
            await MediaPlayer.play(MediaPlayer.currentSong.file.cloudFileUrl);
            outputs?.then()
          } else {
            console.error('No audio source available');
          }

          return
        }
        case data.type === 'pause': {

          if (MediaPlayer.isPlaying) {
            MediaPlayer.stopVinylRotation();
            await MediaPlayer.pause();
          }
          outputs?.then()
          return
        }
        case data.type === 'playSong': {
          if (val) {
            MediaPlayer.startVinylRotation();
            await MediaPlayer.play(val.file.cloudFileUrl);
            // mediaPlayer.play(val)
            outputs?.then()
          }
          return
        }
        case data.type === 'setPlayList': {
          // mediaPlayer.setPlaylist(val)
          MediaPlayer.playlist = val
          console.log("MediaPlayer",MediaPlayer.playlist)
          MediaPlayer.currentIndex = 0
          MediaPlayer.currentSong = MediaPlayer.playlist[MediaPlayer.currentIndex]

          // 设置初始时长（duration 已经是以秒为单位）
          if (MediaPlayer.currentSong.file.duration > 0) {
            MediaPlayer.duration = MediaPlayer.currentSong.file.duration
          }

          // 解析歌词
          MediaPlayer.parseLyrics()
          return
        }
        case data.type === 'editSong': {

        }
      }
    })
  }
}