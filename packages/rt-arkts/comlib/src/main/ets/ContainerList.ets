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



class CustomDataSource implements IDataSource {
  private data: DataSourceItem[] = [];
  private listeners: DataChangeListener[] = [];

  constructor(initialData: DataSourceItem[]) {
    this.data = initialData;
  }

  totalCount(): number {
    return this.data.length;
  }

  getData(index: number): DataSourceItem {
    return this.data[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (!this.listeners.includes(listener)) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const index = this.listeners.indexOf(listener);
    if (index >= 0) {
      this.listeners.splice(index, 1);
    }
  }

  // 插入数据方法
  insertItems(startIndex: number, items: DataSourceItem[]): void {
    items.forEach((item, i) => {
      const insertPos = startIndex + i;
      this.data.splice(insertPos, 0, item);
      // 为每个项单独触发事件
      this.listeners.forEach(listener => listener.onDataAdd(insertPos));
    });
  }

  appendItems(items: DataSourceItem[]): void {
    const startIndex = this.data.length;
    this.data.push(...items);
    this.listeners.forEach(listener => listener.onDataAdd(startIndex));
  }

  replaceAll(items: DataSourceItem[]): void {
    while (this.data.length > 0) {
      // 从后往前删除避免索引变化干扰
      this.data.pop();
      this.listeners.forEach(listener =>
      listener.onDataDelete(this.data.length) // 触发删除事件
      );
    }

    this.data.push(...items);
    this.listeners.forEach(listener =>
    listener.onDataAdd(0) // 从0位置开始触发添加事件
    );
  }

  // 删除数据方法
  deleteItems(startIndex: number, count: number): void {
    this.data.splice(startIndex, count);
    this.listeners.forEach(listener => listener.onDataDelete(startIndex));
  }
}

interface Inputs {
  addDataSource: (fn: (ds: Array<DataSourceItem>,outputRels?: void) => void) => void
  refreshDataSource: (fn: (ds: Array<DataSourceItem>,outputRels?: void) => void) => void
  prependDataSource: (fn: (ds: Array<DataSourceItem>,outputRels?: void) => void) => void
  scrollToEnd:(fn: (val: AnyType,outputRels?: void) => void) => void
}

interface Outputs {
  onReachStart: () => void
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
  private dataSource: CustomDataSource = new CustomDataSource([]);
  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParamsItem) => void = emptySlot;

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined


  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;


  private scroller: ListScroller = new ListScroller();
  private enableTriggerReachStart: boolean = true;



  aboutToAppear(): void {
    // 设置数据源添加监听
    this.inputs?.addDataSource((ds,outputRels:AnyType) => {
      this.dataSource.appendItems(ds); // 调用标准化方法
      outputRels?.["addDataSourceDone"]?.(ds);


    })

    // 设置数据源顶部追加监听
    this.inputs?.prependDataSource((ds, outputRels: AnyType) => {
      this.dataSource.insertItems(0, ds); // 通过数据源类方法
      this.enableTriggerReachStart = true
      outputRels?.["prependDataSourceDone"]?.(ds);
    })

    // 设置数据源刷新监听
    this.inputs?.refreshDataSource((ds,outputRels:AnyType) => {
      this.dataSource.replaceAll(ds); // 调用全量替换方法
      outputRels?.["refreshDataSourceDone"]?.(ds);
    })

    //列表滚动到底部
    this.inputs?.scrollToEnd((val:ScrollEdgeOptions)=>{
      this.scroller.scrollEdge(Edge.Bottom,val)
    })


  }


  @Computed
  get shouldScroll (): boolean | undefined {
    const styles = this.styles?.['root'];
    if(styles?.height == '100%'){
      return true
    }
    if(typeof styles?.height == 'number'){
      return true
    }
    if(styles?.height == 'fit-content'){
      return false
    }
    return undefined
  }

  @Computed
  get listHeight (): number | undefined {
    const styles = this.styles?.['root']
    if(typeof styles?.height == 'number'){
      return styles?.height
    }
    return undefined

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
          LazyForEach(this.dataSource, (item: DataSourceItem, index) => {
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
        if(this.shouldScroll){
          // 纵向列表，需要滚动，此时使用List组件
          List({
            space: this.data.spacing,
            initialIndex: 0,
            scroller: this.scroller
          }) {
            LazyForEach(this.dataSource, (item: DataSourceItem, index) => {
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
              }
            },(item:AnyType) => item.id)
          }
          .cachedCount(100)
          .maintainVisibleContentPosition(true)
          // .onReachStart(()=>{
          //   if(this.enableTriggerReachStart){
          //     this.outputs?.onReachStart()
          //     this.enableTriggerReachStart = false
          //   }
          // })
          .onScrollIndex((start: number) => {
            if (start < 2 && this.enableTriggerReachStart) {
              this.outputs?.onReachStart()
              this.enableTriggerReachStart = false
            }
          })
          .height(this.listHeight)
          .scrollBar(BarState.Auto)
          .align(Alignment.Start)
          .listDirection(Axis.Vertical)
        }else{
          //不需要滚动，内容使用flex平铺展示
          LazyForEach(this.dataSource, (item: DataSourceItem, index) => {
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
            }.margin({
              bottom:this.data.spacing
            })
          })
        }

      }
    }
    .alignItems(HorizontalAlign.Start)
    .align(Alignment.Start)
    .height('fit-content')
    .width('100%')
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(this.modifier)
  }
}