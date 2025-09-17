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

type DataSourceItem = Record<string, string | number | boolean | Object> | string | number | boolean

export interface DataType {
  direction?: 'row' | 'column',
  spacing?: number
  rowKey?: string
  autoplay?: boolean
  duration?: number
}

@ObservedV2
export class Data implements DataType {
  @Trace rowKey?: string
  @Trace spacing?: number = 0
  @Trace direction?: 'row' | 'column' = 'column'
  @Trace autoplay?: boolean
  @Trace duration?: number

  constructor(config: DataType) {
    this.rowKey = config.rowKey ?? 'id'
    this.spacing = config.spacing ?? 0
    this.direction = config?.direction ?? 'column'

    this.autoplay = config?.autoplay ?? false;
    this.duration = config?.duration ?? 12000;
  }
}

interface Inputs {
  setItems: (fn: (array: AnyType, outputRels?: void) => void) => void
}

interface Outputs {
}

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
export default struct MyBricksMarquee {
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
  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParamsItem) => void = emptySlot;
  @Param _env?: _Env = undefined
  @Param env?: Env = undefined
  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;
  @Local dataSource: DataSourceItem[] = []
  @Local renderData: DataSourceItem[] = []
  @Local totalWidth: number = 0
  @Local scrollWidth: number = 0
  private scroller: Scroller = new Scroller();

  aboutToAppear(): void {
    this.inputs?.setItems((ds: DataSourceItem[], outputRels: AnyType) => {
      this.dataSource = ds;
      setTimeout(() => {
        outputRels?.["setItemsDone"]?.('');
      }, 20)
    })
  }

  aboutToDisappear(): void {
    clearInterval(this.intervalNum);
  }

  @Monitor('dataSource')
  onDataChange(monitor: IMonitor) {
    this.renderData = [...this.dataSource, ...this.dataSource];
  }

  private intervalNum: number = 0;
  private isPlaying: boolean = false;
  private readonly DEFAULT_DURATION: number = 3000;

  startAutoRoll() {
    if (this.isPlaying) return;

    this.isPlaying = true;

    const duration = this.data.duration || this.DEFAULT_DURATION;

    // 计算每一帧需要移动的距离
    const totalDistance = this.totalWidth / 2; // 需要滚动的总距离
    const frameRate = 90; // 假设60fps
    const totalFrames = (duration / 1000) * frameRate; // 总帧数
    const distancePerFrame = totalDistance / totalFrames; // 每帧移动距离

    this.intervalNum = setInterval(() => {
      // 获取当前滚动位置
      const currOffset = this.scroller.currentOffset().xOffset;
      let newOffset = currOffset + distancePerFrame;

      // 如果滚动到了第二份数据的位置，重置到第一份数据的对应位置
      if (newOffset > this.totalWidth / 2) {
        newOffset = 0;
      }

      // 执行滚动
      this.scroller.scrollTo({
        xOffset: newOffset,
        yOffset: 0,
        animation: false
      });
    }, 1000 / frameRate); // 约16.7ms，对应60fps
  }

  stopAutoPlay() {
    if (this.intervalNum) {
      clearInterval(this.intervalNum);
      this.intervalNum = 0;
    }
    this.isPlaying = false;
  }

  build() {
    Column() {
      Scroll(this.scroller) {
        Row({ space: this.data.spacing }) {
          ForEach(this.renderData, (item: DataSourceItem, index) => {
            Column() {
              this.slots({
                id: 'item',
                inputValues: {
                  itemData: item,
                  index
                }
              })
            }
          })
        }
        .onSizeChange((old, newValue) => {
          if (typeof newValue.width === 'number' && typeof old.width === 'number') {
            if (Math.abs(newValue.width as number - old.width as number) > 5) {
              this.totalWidth = newValue.width as number
              if (this.data.autoplay) {
                this.stopAutoPlay();
                this.startAutoRoll()
              }
            }
          }
        })
      }
      .scrollable(ScrollDirection.Horizontal)
      .scrollBar(BarState.Off)
      .onTouch((touchEvt) => {
        if (this.data.autoplay) {
          if (touchEvt.type === TouchType.Down) {
            this.stopAutoPlay();
          } else if (touchEvt.type === TouchType.Cancel || touchEvt.type === TouchType.Up) {
            this.startAutoRoll()
          }
        }
      })
      .onSizeChange((old, newValue) => {
        if (typeof newValue.width === 'number' && typeof old.width === 'number') {
          if (Math.abs(newValue.width as number - old.width as number) > 5) {
            this.scrollWidth = newValue.width as number
          }
        }
      })
      .onScrollFrameBegin((offset: number) => {
        let currOffset = this.scroller.currentOffset().xOffset;
        let newOffset = currOffset + offset;
        //左滑
        if (newOffset < 0) {
          newOffset = this.totalWidth / 2 + newOffset;
          return { offsetRemain: newOffset - currOffset }
        //右滑
        } else if (newOffset > this.totalWidth / 2) {
          newOffset = newOffset - this.totalWidth / 2;
          return { offsetRemain: newOffset - currOffset }
        }
        return { offsetRemain: offset }
      })
    }
    .height('fit-content')
    .width('100%')
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(this.modifier)
  }
}
