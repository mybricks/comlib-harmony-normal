import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'
// import { mediaPlayer } from './AiMusic/Index'
import MediaPlayer, { PlayState, Time, Lyric, WorksItemWithLabelsModel } from './AiMusic/model/AppMusicMediaPlayer'
import { PlayMode, PositionItem } from './AiMusic/model/AppMusicPlayerModel'
import { LyricLine, LyricData } from './AiMusic/model/AppMusicLyricModel'
import promptAction from '@ohos.promptAction'
import { Event } from './AiMusic/Event'
import common from '@ohos.app.ability.common'
import { BusinessError } from '@kit.BasicServicesKit'

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

  @Local playMode: PlayMode = MediaPlayer.playMode
  @Local value: number = 0
  @Local isPlaying: boolean = MediaPlayer.isPlaying
  @Local rotationAngle: number = MediaPlayer.rotationAngle
  @Local needleRotation: number = MediaPlayer.needleRotation
  @Local time: Time = MediaPlayer.time
  @Local lyric: Lyric = MediaPlayer.lyric
  @Local targetAudio: WorksItemWithLabelsModel | null = MediaPlayer.targetAudio


  private context: common.UIAbilityContext = getContext() as common.UIAbilityContext
  private uiContext = this.getUIContext()

  rotationAngleListener = (rotationAngle: number) => {
    this.rotationAngle = rotationAngle
  }

  needleRotationListener = (needleRotation: number) => {
    this.needleRotation = needleRotation
  }

  targetAudioListener = (targetAudio: WorksItemWithLabelsModel) => {
    this.targetAudio = targetAudio
  }

  timeListener = (time: Time) => {
    this.time = time
  }

  isPlayingListener = (isPlaying: boolean) => {
    this.isPlaying = isPlaying
  }

  lyricListener = (lyric: Lyric) => {
    this.lyric = lyric
  }

  playModeListener = (playMode: PlayMode) => {
    this.playMode = playMode
    switch (playMode) {
      case PlayMode.SEQUENCE:
        promptAction.showToast({ message: '顺序播放' })
        break
      case PlayMode.SINGLE:
        promptAction.showToast({ message: '单曲循环' })
        break
      case PlayMode.RANDOM:
        promptAction.showToast({ message: '随机播放' })
        break
    }
  }

  aboutToAppear(): void {
    MediaPlayer.addEventListener("rotationAngle", this.rotationAngleListener)
    MediaPlayer.addEventListener("needleRotation", this.needleRotationListener)
    MediaPlayer.addEventListener("targetAudio", this.targetAudioListener)
    MediaPlayer.addEventListener("time", this.timeListener)
    MediaPlayer.addEventListener("isPlaying", this.isPlayingListener)
    MediaPlayer.addEventListener("lyric", this.lyricListener)
    MediaPlayer.addEventListener("playMode", this.playModeListener)
  }

  aboutToDisappear() {
    MediaPlayer.removeEventListener("rotationAngle", this.rotationAngleListener)
    MediaPlayer.removeEventListener("needleRotation", this.needleRotationListener)
    MediaPlayer.removeEventListener("targetAudio", this.targetAudioListener)
    MediaPlayer.removeEventListener("time", this.timeListener)
    MediaPlayer.removeEventListener("isPlaying", this.isPlayingListener)
    MediaPlayer.removeEventListener("lyric", this.lyricListener)
    MediaPlayer.removeEventListener("playMode", this.playModeListener)
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
    this.outputs?.onPlayListClick("")
  }

  // 播放/暂停
  private async togglePlay() {
    if (this.isPlaying) {
      MediaPlayer.pause();
    } else {
      MediaPlayer.play();
    }
    // try {
    //   if (this.isPlaying) {
    //     MediaPlayer.stopVinylRotation();
    //     await MediaPlayer.pause();
    //   } else {
    //     if (MediaPlayer.currentSong?.file?.cloudFileUrl) {
    //       MediaPlayer.startVinylRotation();
    //       await MediaPlayer.play();
    //     } else {
    //       console.error('No audio source available');
    //     }
    //   }
    // } catch (error) {
    //   console.error('Failed to toggle play state:', error);
    // }
  }

  // 歌词滚动效果
  playLrc(duration: number) {
    this.uiContext.animateTo({
      duration: duration,
      finishCallbackType: FinishCallbackType.LOGICALLY,
      curve: Curve.Linear,
      iterations: 1,
      onFinish: () => {
        this.value = 0
        MediaPlayer.currentIndex++;
        let currentLine = MediaPlayer.lyrics[MediaPlayer.currentLineIndex]
        if (MediaPlayer.currentIndex < currentLine?.text?.length) {
          MediaPlayer.lrcDuration = currentLine.time;
          this.playLrc(MediaPlayer.lrcDuration);
        } else {
          MediaPlayer.currentIndex = 0
          MediaPlayer.currentLineIndex++
          if (MediaPlayer.currentLineIndex < MediaPlayer.lyrics.length) {
            let nextLine = MediaPlayer.lyrics[MediaPlayer.currentLineIndex]
            MediaPlayer.lrcDuration = nextLine.time;
            this.playLrc(MediaPlayer.lrcDuration);
          }
        }
      }
    }, () => {
      this.value = 1
    })
  }

  @Builder
  VinylPlayer() {
    Stack({ alignContent: Alignment.TopStart }) {
      // 背景
      Row() {
      }
      .width('100%')
      .height(300)
      .backgroundColor('#88151A26')
      .borderRadius(32)
      .borderWidth(2)
      .borderColor('#FF181E2B')

      // 黑胶唱片
      Stack({ alignContent: Alignment.Center }) {
        // 黑胶
        Stack() {
          Image('https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_img_vinyl_record.png')
            .width('100%')
            .aspectRatio(1)
            .rotate({ angle: this.rotationAngle })

          // 封面
          Image(this.targetAudio?.file?.thumbnailImgUrl || 'https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_img_cover.png')
            .width('50%')
            .aspectRatio(1)
            .borderRadius(200)
        }
        .width('80%')
        .aspectRatio(1)
      }
      .width('100%')
      .height(300)

      Row() {
        Column() {
          // 唱针旋转点
          Circle()
            .width(20)
            .height(20)
            .margin({ left: 18 })
            .fill('#333')

          // 唱针
          Image('https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_img_vinyl_pointer.png')
            .height(240)
            .margin({ top: -20 })
            .objectFit(ImageFit.Contain)
            .rotate({ centerX: '66%', centerY: 0, angle: this.needleRotation })
            .animation({
              duration: 500,
              curve: Curve.EaseInOut
            })
        }
        .alignItems(HorizontalAlign.Center)
        .position({ x: '75%', y: 0 })
      }.width('100%')

    }
    .width('80%')
    .margin({ top: 101 })
    .height(300)
  }

  @Builder
  customBuilder() {}

  @BuilderParam customBuilderParam: () => void = this.customBuilder;

  build() {
    Column() {
      // 唱片机部分
      this.VinylPlayer()

      // 歌曲信息
      Column() {
        Row() {
          Text(this.targetAudio?.file?.title || '未知歌曲')
            .fontSize(24)
            .fontColor('#fff')
            .fontWeight(FontWeight.Bold)
          Column() {
            this.slots({
              id: 'toolbar',
              style: {
                "width":50,
              }
            })
          }
          .layoutWeight(1)
          // this.customBuilderParam()
        }
        .margin({ top: 20, bottom: 8 })
      }
      .width('100%')
      .padding({ left: 20, right: 20 })
      .alignItems(HorizontalAlign.Start)

      // 歌词显示
      Stack() {
        List({ initialIndex: 0, scroller: MediaPlayer.lyricListScroller }) {
          ForEach(this.lyric.lyrics, (line: LyricLine, lineIndex: number) => {
            ListItem() {
              Column() {
                // Word-by-word rendering
                Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
                  ForEach(line.text.split(''), (word: string, wordIndex: number) => {
                    Row() {
                      Text(word)
                        .fontSize(lineIndex === this.lyric.currentLineIndex ? 16 : 14)
                        .blendMode(BlendMode.DST_IN, BlendApplyType.OFFSCREEN)
                        .fontWeight(lineIndex === this.lyric.currentLineIndex ? 800 : FontWeight.Normal)
                    }
                    .margin({
                      right: word.match(/[a-zA-Z0-9]/) ? 4 : 0,
                      bottom: 2
                    })
                    .blendMode(BlendMode.SRC_OVER, BlendApplyType.OFFSCREEN)
                    .linearGradient({
                      direction: GradientDirection.Right,
                      colors: [['#FFFFFFFF', 0], ['#FFFFFFFF', 1.0]]
                      // colors: (() => {
                      //   if (MediaPlayer.currentLineIndex !== lineIndex) {
                      //     // 当前行未激活，全部白色
                      //     return [['#FFFFFFFF', 0], ['#FFFFFFFF', 1.0]];
                      //   }
                      //
                      //   if (wordIndex < MediaPlayer.currentIndex) {
                      //     // 已播放的字：全红
                      //     return [[0xFF1949, 0.0], [0xFF1949, 1.0]];
                      //   } else if (wordIndex === MediaPlayer.currentIndex) {
                      //     // 正在播放的字：红色渐变（从 0 到 this.value）
                      //     return [
                      //       [0xFF1949, 0.0],
                      //       [0xFF1949, this.value],
                      //       ['#FFFFFFFF', this.value],
                      //       ['#FFFFFFFF', 1.0]
                      //     ];
                      //   } else {
                      //     // 未播放的字：全白
                      //     return [['#FFFFFFFF', 0], ['#FFFFFFFF', 1.0]];
                      //   }
                      // })(),
                    })
                    .onAppear(() => {
                      // MediaPlayer.lrcDuration = line.time;
                      // if (lineIndex === MediaPlayer.currentLineIndex && wordIndex === 0) {
                      //   this.playLrc(line.time);
                      // }

                    })
                  })
                }
                .width('100%')
                .padding({
                  top: 10,
                  right: 20,
                  bottom: 10,
                  left: 20
                })
              }
              .width('100%')
            }
            .opacity(lineIndex === this.lyric.currentLineIndex ? 1 : 0.8)
          })
        }
      }
      .width('100%')
      .layoutWeight(1)
      .margin({ top: 20 })

      // 进度条
      Column() {
        Slider({
          // value: MediaPlayer.sliderValue,
          value: this.time.currentTime,
          min: 0,
          // max: MediaPlayer.duration,
          max: this.time.duration,
          step: 1,
          style: SliderStyle.OutSet
        })
          .blockColor('#FFFFFF')
          .trackColor('#33FFFFFF')
          .selectedColor('#FFFFFF')
          .showSteps(false)
          .showTips(false)
          .width('100%')
          .onChange((value: number, mode) => {
            if (mode === SliderChangeMode.Begin) {
              MediaPlayer.isSliderDragging = true
            } else if (mode === SliderChangeMode.End) {
              MediaPlayer.isSliderDragging = false
            }

            MediaPlayer.seek(value * 1000)
          })
          .padding({
            left: 11,
            right: 11
          })

        Row() {
          Text(this.formatTime(this.time.currentTime))
            .fontSize(12)
            .fontColor('#999999')
          Text(this.formatTime(this.time.duration))
            .fontSize(12)
            .fontColor('#999999')
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          left: 20,
          right: 20
        })
      }
      .width('100%')
      .margin({ top: 10 })
      // .padding({
      //   left: 11,
      //   right: 11
      // })


      // 控制按钮
      Row() {
        // 播放模式按钮
        Image(this.playMode === PlayMode.SEQUENCE ?
          'https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_ic_play_list_cycle.png' :
          this.playMode === PlayMode.SINGLE ?
            'https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_ic_play_one_cycle.png' :
            'https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_ic_shuffle.png')
          .width(24)
          .height(24)
          .margin({ right: 40 })
          .onClick(() => MediaPlayer.togglePlayMode())
          // .onClick(() => this.togglePlayMode())

        // 上一首按钮
        Image('https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_ic_previous.png')
          .width(32)
          .height(32)
          .margin({ right: 40 })
          .onClick(() => MediaPlayer.playPrevious())

        // 播放/暂停按钮
        Image(this.isPlaying ? 'https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_ic_pause.png' : 'https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_ic_play.png')
          .width(64)
          .height(64)
          .onClick(() => this.togglePlay())

        // 下一首按钮
        Image('https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_ic_next.png')
          .width(32)
          .height(32)
          .margin({ left: 40 })
          .onClick(() => MediaPlayer.playNext())

        // 播放列表按钮
        Image('https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_ic_music_list.png')
          .width(24)
          .height(24)
          .margin({ left: 40 })
          .onClick(() => this.showPlaylistDialog())
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 10, bottom: 20 })



    }
    .padding(20)
    .backgroundImage(this.targetAudio?.file?.thumbnailImgUrl || 'https://p66-ec.becukwai.com/udata/pkg/eshop/fangzhou/image/app_play_page_img_cover.png')
    .backgroundImageSize(ImageSize.Cover)
    .backgroundBlurStyle(BlurStyle.Thin)
    .backgroundEffect({ radius: 120, brightness: 0.9, saturation: 0.5 })
    .justifyContent(FlexAlign.Center)
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(this.modifier)
  }

  private formatTime(seconds: number): string {
    if (!isFinite(seconds) || seconds < 0) {
      return '00:00'
    }
    const min = Math.floor(seconds / 60)
    const sec = Math.floor(seconds % 60)
    return `${min.toString().padStart(2, '0')}:${sec.toString().padStart(2, '0')}`
  }
}