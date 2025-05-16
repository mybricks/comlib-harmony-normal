import { ApplyRootStyleModifier, ApplyStyleModifier, CSSProperties } from '../styles/getDesignStyle'
import { AnyType } from './../types'

export type DataType = AnyType

// export interface DataType extends AnyType {
//   background: string
// }

@ObservedV2
export class Data implements DataType {
  @Trace background: string
  enabledPulldown: boolean = false

  constructor(config: DataType) {
    this.background = config.background
  }
}


interface Inputs {
}

interface Outputs {
}


export interface SlotsParams_content {
  id: string,
}
export interface SlotsParams {
  item: SlotsParams_content
}
@Builder function emptySlot(params: AnyType) {}

@ComponentV2
export default struct System_Page {
  @Param data: Data = new Data({
    background: '#ffffff',
    enabledPulldown: false
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;

  @BuilderParam slots: (params: AnyType) => void = emptySlot;

  @Local isRefreshing: boolean = false;

  aboutToAppear(): void {

  }

  @Builder
  renderContent () {
    Column() {
      this.slots({
        id: 'header'
      })
      Scroll() {
        Column() {
          this.slots({
            id: 'content'
          })
        }
        .width('100%')
        .alignItems(HorizontalAlign.Start)
        .align(Alignment.Start)
      }
      .height('100%')
      .align(Alignment.TopStart)
    }
    .height('100%')
    .width('100%')
  }

  build() {
    if (this.data.enabledPulldown) {
      Refresh({ refreshing: this.isRefreshing }) {
        this.renderContent()
      }
        .backgroundColor(this.data?.background)
        .onRefreshing(() => {
          // 数据刷新逻辑
        })
    } else {
      Column() {
        this.renderContent()
      }
        .backgroundColor(this.data?.background)
    }
  }
}
