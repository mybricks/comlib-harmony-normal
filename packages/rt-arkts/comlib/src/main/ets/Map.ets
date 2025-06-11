import { MapComponent, mapCommon, map } from '@kit.MapKit';
import { AsyncCallback } from '@kit.BasicServicesKit';
import { ApplyRootStyleModifier, ApplyStyleModifier, ApplyFontStyleModifier, CSSProperties } from './utils/GetDesignStyle'
import { AnyType } from './types'

export interface DataType {
  showScale?: boolean
  /** 支持拖动 */
  enableScroll?: boolean
  /** 支持缩放 */
  enableZoom?: boolean
}

@ObservedV2
export class Data implements DataType {
  @Trace showScale?: boolean = false
  @Trace enableScroll?: boolean = true
  @Trace enableZoom?: boolean = true

  constructor(config: DataType) {
    this.showScale = config?.showScale ?? false
    this.enableScroll = config?.enableScroll ?? true
    this.enableZoom = config?.enableZoom ?? true
  }
}

interface Inputs {

}

interface Outputs {

}

@ComponentV2
export default struct MyBricksMap {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  private mapOptions?: mapCommon.MapOptions;
  private callback?: AsyncCallback<map.MapComponentController>;
  private mapController?: map.MapComponentController;
  private mapEventManager?: map.MapEventManager;

  aboutToAppear(): void {
    // 地图初始化参数，设置地图中心点坐标及层级
    this.mapOptions = {
      position: {
        target: {
          latitude: 39.9,
          longitude: 116.4
        },
        zoom: 2
      },
      scaleControlsEnabled: this.data.showScale,
      scrollGesturesEnabled: this.data.enableScroll,
      zoomGesturesEnabled: this.data.enableZoom,
      zoomControlsEnabled: this.data.enableZoom
    };

    // 地图初始化的回调
    this.callback = async (err, mapController) => {
      if (!err) {
        // 获取地图的控制器类，用来操作地图
        this.mapController = mapController;
        this.mapEventManager = this.mapController.getEventManager();
        let callback = () => {
          console.info(`on-mapLoad`);
        }
        this.mapEventManager.on("mapLoad", callback);
      } else {
        console.error(`地图初始化失败code is：${err.code},message is ${err.message}`);
      }
    };
  }

  build() {
    Column() {
      // 调用MapComponent组件初始化地图
      MapComponent({ mapOptions: this.mapOptions, mapCallback: this.callback }).width('100%').height('100%');
    }.attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
