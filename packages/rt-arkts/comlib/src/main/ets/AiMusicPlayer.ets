import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'
import { mediaPlayer } from './AiMusic/Index'

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

  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  @Local name: string = '歌曲名称'

  aboutToAppear(): void {
    mediaPlayer.onChange((work: AnyType) => {
      this.name = work?.file?.title
    })
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