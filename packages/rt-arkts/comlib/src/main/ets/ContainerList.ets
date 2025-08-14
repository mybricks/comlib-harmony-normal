import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'

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

export interface DataType {
  direction?: 'row' | 'column',
  spacing?: number
  rowKey?: string
  scrollBar?: boolean
  wrap?: boolean
}

type DataSourceItem = Record<string, string | number | boolean | Object> | string | number | boolean

@ObservedV2
export class Data implements DataType {
  @Trace rowKey?: string
  @Trace spacing?: number = 0
  @Trace direction?: 'row' | 'column' = 'column'
  @Trace scrollBar?: boolean = false
  @Trace wrap?: boolean = false

  constructor(config: DataType) {
    this.rowKey = config.rowKey ?? 'id'
    this.spacing = config.spacing ?? 0
    this.direction = config?.direction ?? 'column'
    this.scrollBar = config?.scrollBar ?? false
    this.wrap = config?.wrap ?? false
  }
}

interface Inputs {
  addDataSource: (fn: (ds: Array<DataSourceItem>) => void) => void
  refreshDataSource: (fn: (ds: Array<DataSourceItem>) => void) => void
}

interface Outputs {}

interface ItemParamsInputValues {
  index: number,
  itemData: DataSourceItem
}

export interface SlotsParamsItem {
  id: string,
  inputValues: ItemParamsInputValues
}

@Builder
function emptySlot(params: SlotsParamsItem) {
}

@ComponentV2
export default struct MyBricksContainerList {
  @Param data: Data = new Data({
    rowKey: 'id',
    spacing: 0,
    direction: 'column'
  });
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Local dataSource: Array<DataSourceItem> = []
  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParamsItem) => void = emptySlot;

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  // 状态变量
  @Local private estimatedItemHeight: number = 50  // 预估每项高度
  @Local private isInitializing: boolean = true    // 初始化标记
  @Local private totalHeight: number = 0           // 总高度
  @Local private itemHeights: Map<number, number> = new Map()  // 存储每个项的高度
  @Local private maxRetries: number = 10           // 最大重试次数
  @Local private currentRetry: number = 0          // 当前重试次数

  aboutToAppear(): void {
    // 设置数据源添加监听
    this.inputs?.addDataSource((ds) => {
      this.dataSource = this.dataSource.concat(ds)
      this.initializeHeight()
    })

    // 设置数据源刷新监听
    this.inputs?.refreshDataSource((ds) => {
      this.dataSource = ds
      this.initializeHeight()
    })

    // 初始化高度
    this.initializeHeight()
  }

  // 初始化高度计算
  private initializeHeight() {
    if (this.data.direction === 'column') {
      // 重置状态
      this.isInitializing = true
      this.currentRetry = 0
      this.itemHeights.clear()

      // 设置预估总高度
      this.totalHeight = this.estimatedItemHeight * this.dataSource.length +
        (this.dataSource.length - 1) * (this.data.spacing || 0)

      // 延迟一帧后开始检查实际高度
      this.scheduleHeightCheck()
    }
  }

  // 安排高度检查
  private scheduleHeightCheck() {
    setTimeout(() => {
      if (this.currentRetry < this.maxRetries) {
        this.updateTotalHeight()
        this.currentRetry++
      } else {
        this.isInitializing = false
      }
    }, 16)
  }

  // 更新总高度
  private updateTotalHeight() {
    let total = 0
    let hasAllHeights = true

    // 计算所有项的高度
    for (let i = 0; i < this.dataSource.length; i++) {
      const height = this.itemHeights.get(i)
      if (height === undefined) {
        hasAllHeights = false
        total += this.estimatedItemHeight
      } else {
        total += height
      }
    }

    // 添加间距
    if (this.dataSource.length > 1) {
      total += (this.dataSource.length - 1) * (this.data.spacing || 0)
    }

    // 更新总高度
    this.totalHeight = total

    // 如果还没有获取到所有高度且在初始化阶段，继续检查
    if (!hasAllHeights && this.isInitializing) {
      this.scheduleHeightCheck()
    } else {
      this.isInitializing = false
    }
  }

  build() {
    Column() {
      if (this.data.direction === 'row') {
        // 横向且需要换行的情况使用Flex
        Flex({
          direction: FlexDirection.Row,
          wrap: this.data.wrap ? FlexWrap.Wrap : FlexWrap.NoWrap,
          justifyContent: FlexAlign.Start,
          alignItems: ItemAlign.Start
        }) {
          ForEach(this.dataSource, (item: DataSourceItem, index) => {
            Column() {
              this.slots({
                id: 'item',
                inputValues: {
                  itemData: item,
                  index
                }
              })
            }
            .margin({
              right: this.data.spacing,
            })
          })
        }
        .width('100%')
        .height('fit-content')
      } else {
        // 使用List组件
        List({
          space: this.data.spacing,
          initialIndex: 0,
        }) {
          ForEach(this.dataSource, (item: DataSourceItem, index) => {
            ListItem() {
              Column() {
                this.slots({
                  id: 'item',
                  inputValues: {
                    itemData: item,
                    index
                  }
                })
              }
              .height(this.isInitializing ? this.estimatedItemHeight : undefined)
            }
            .onAreaChange((oldArea: Area, newArea: Area) => {
              if (this.data.direction === 'column') {
                const oldHeight = this.itemHeights.get(index) || 0
                if (oldHeight !== newArea.height) {
                  this.itemHeights.set(index, newArea.height as number)
                  this.updateTotalHeight()
                }
              }
            })
          })
        }
        .scrollBar(this.data.scrollBar ? BarState.Auto : BarState.Off)
        .listDirection(Axis.Vertical)
        .height(this.data.direction === 'column' ?
          (this.totalHeight || 'fit-content') : 'fit-content')
        .onScrollStart(() => {
          // 确保滚动时已经退出初始化状态
          if (this.isInitializing) {
            this.isInitializing = false
          }
        })
      }
    }
    .alignItems(HorizontalAlign.Start)
    .align(Alignment.Start)
    .height('fit-content')
    .width('100%')
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }

  // 组件销毁时的清理
  aboutToDisappear() {
    this.itemHeights.clear()
    this.isInitializing = true
    this.currentRetry = 0
  }
}