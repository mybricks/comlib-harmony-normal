import { CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

interface ItemType {
  id: string
  title: string
  outputId: string
}

export interface DataType {
  defaultActiveId: string
  _editSelectId_?: string
  items: ItemType[]
  renderMode?: 'lazy' | 'pre'
}

@ObservedV2
export class Data implements DataType {
  @Trace defaultActiveId: string
  @Trace _editSelectId_?: string
  @Trace items: ItemType[]
  @Trace renderMode?: 'lazy' | 'pre'

  constructor(config?: DataType) {
    this.defaultActiveId = config?.defaultActiveId ?? ''
    this._editSelectId_ = config?._editSelectId_
    this.items = config?.items ?? []
    this.renderMode = config?.renderMode
  }
}

export interface SlotsParams {
  id: string,
  key?: string
}

@Builder function emptySlot(params: SlotsParams) {}

@ComponentV2
export default struct MyBricksCondition {
  @Param data: Data = new Data()
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: AnyType = undefined
  @Param outputs?: AnyType = undefined
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;

  @Local inputId: string = ''

  aboutToAppear() {
    this.inputId = this.data.defaultActiveId

    // 设置输入处理
    this.inputs?.setValue?.((condition: string, relOutputs: AnyType) => {
      const item = this.data.items.find((t) => t.title === condition)
      if (!item) {
        return
      }
      this.inputId = item.id
      relOutputs?.["setValueDone"]?.(condition)
      this.outputs?.changeCondition?.(condition)
      this.outputs?.[item.outputId]?.(condition)
    })

    // 处理每个条件项的输入
    this.data.items.forEach((item) => {
      this.inputs?.[item.id]?.((condition: string, relOutputs: AnyType) => {
        if (item.id === this.activeId) {
          relOutputs?.["changeDone"]?.(condition)
          this.outputs?.[item.outputId]?.(condition)
          this.outputs?.changeCondition?.(condition)
          return
        }

        this.inputId = item.id
        this.outputs?.changeCondition?.(condition)
        this.outputs?.[item.outputId]?.(condition)
        relOutputs?.["changeDone"]?.(condition)
      })
    })
  }

  @Computed
  get activeId(): string {
    return this.inputId
  }

  @Computed
  get renderMode(): string {
    return this.data.renderMode ?? 'lazy'
  }

  build() {
    Column() {
      if (this.renderMode === 'lazy') {
        ForEach(this.data.items, (item: ItemType) => {
          if (this.activeId === item.id) {
            Column() {
              this.slots({
                id: item.id,
                key: item.id,
              })
            }
            .alignItems(HorizontalAlign.Start)
            .justifyContent(FlexAlign.Start)
          }
        })
      } else if (this.renderMode === 'pre') {
        ForEach(this.data.items, (item: ItemType) => {
          Column() {
            this.slots({
              id: item.id,
              key: item.id,
            })
          }
          .alignItems(HorizontalAlign.Start)
          .justifyContent(FlexAlign.Start)
          .visibility(this.activeId === item.id ? Visibility.Visible : Visibility.None)
        })
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
    .justifyContent(FlexAlign.Start)
  }
}

