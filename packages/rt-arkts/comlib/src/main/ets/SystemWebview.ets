import { CSSProperties } from './utils/GetDesignStyle'
import { webview } from '@kit.ArkWeb';
import { AnyType } from './types';

export type DataType = AnyType

@ObservedV2
export class Data implements DataType {
  @Trace url?: string

  constructor(config: DataType) {
    this.url = config.url
  }
}

interface Inputs {
  setUrl: (fn: (url: string) => void) => void
}

interface Outputs {
  onLoad?: (value?: AnyType) => void
  onError?: (value?: AnyType) => void
  onMessage?: (value?: AnyType) => void
}

@ComponentV2
export default struct MyBricksWebview {
  @Param data: Data = new Data({});
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param styles: Record<string, CSSProperties> = {}

  controller: webview.WebviewController = new webview.WebviewController();

  aboutToAppear(): void {

  }


  build() {
    Web({ src: this.data.url, controller: this.controller })
      .fileAccess(true)
  }
}
