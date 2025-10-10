import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'
import { mediaPlayer } from './AiMusic/Index'
import MediaPlayer, { PlayState } from './AiMusic/model/AppMusicMediaPlayer'
import { PlayMode, PositionItem } from './AiMusic/model/AppMusicPlayerModel'
import promptAction from '@ohos.promptAction'
import { Event } from './AiMusic/Event'

export interface DataType {
}

interface _Env {
  currentScenes: _EnvCurrentScenes
}

interface Env {
  currentScenes: EnvCurrentScenes
}

interface _EnvCurrentScenes {
  close: () => void
}

interface EnvCurrentScenes {
  close: () => void
}

@ObservedV2
export class Data implements DataType {
  constructor(config: DataType) {
  }
}

interface Inputs {

}

interface Outputs {
  onEditClick: (value: string) => void
  onPlayListClick: (value: string) => void
}

export interface SlotsParams {
  id: string,
  style?: CSSProperties
}

@Builder function emptySlot(params: SlotsParams) {}

@ComponentV2
export default struct MyBricksAIMusicPlayer {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  @Local name: string = '歌曲名称'

  private vinylRotationTimer: number = -1

  @Local playMode: PlayMode = PlayMode.SEQUENCE

  aboutToAppear(): void {
    mediaPlayer.onChange((work: AnyType) => {
      this.name = work?.file?.title
    })

    if(mediaPlayer.curruntWork) {
      this.name = mediaPlayer.curruntWork?.file?.title
    }
  }

  aboutToDisappear() {
    // 释放播放器资源
    MediaPlayer.release()
    // 清除定时器
    if (this.vinylRotationTimer !== -1) {
      clearInterval(this.vinylRotationTimer)
    }
  }

  // 切换播放模式
  private togglePlayMode() {
    MediaPlayer.listener?.get('stateChange')?.(this.playMode)
    switch (this.playMode) {
      case PlayMode.SEQUENCE:
        this.playMode = PlayMode.SINGLE
        promptAction.showToast({ message: '单曲循环' })
        break
      case PlayMode.SINGLE:
        this.playMode = PlayMode.RANDOM
        promptAction.showToast({ message: '随机播放' })
        break
      case PlayMode.RANDOM:
        this.playMode = PlayMode.SEQUENCE
        promptAction.showToast({ message: '顺序播放' })
        break
    }
  }

  // 显示播放列表
  private showPlaylistDialog() {
    Event.getInstance().emit('showPlaylist', '111')
  }

  build() {
    Column() {
      Row() {
        Text(this.name)
          .fontSize(16)
          .fontWeight(500)
          .fontColor('#ffffff')
          .onClick(() => {
            this.outputs?.onEditClick?.(this.name)
          })
        Column() {
          this.slots({
            id: 'toolbar',
            style: {}
          })
        }.flexGrow(1)
      }.height(40)

      Row() {
        Text('播放列表')
          .fontSize(14)
          .fontColor('#ffffff')
          .onClick(() => {
            this.outputs?.onPlayListClick?.('')
          })
      }.margin({
        top: 40
      })
    }
    .padding(20)
    .backgroundColor('#090D17')
    .justifyContent(FlexAlign.Center)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(this.modifier)
  }
}