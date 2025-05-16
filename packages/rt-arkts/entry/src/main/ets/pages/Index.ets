import { router } from '@kit.ArkUI';

import {
  mybricks_harmony_button,
  mybricks_harmony_button_Data,
  mybricks_harmony_systemPage,
  mybricks_harmony_systemPage_Data,
} from '@ohos/mybricks-comlib-harmony-normal'


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State fontNum: number = 12;

  @Builder
  slots(params: ESObject) {
    if (params.id === 'content') {
      mybricks_harmony_button({
        data: new mybricks_harmony_button_Data({
          text: this.message
        }),
        styles: {
          '.mybricks-button': {
            'color': 'rgb(255, 169, 64)',
            'backgroundColor': 'red',
            // 'fontSize': '20',
            'border': '5px solid rgb(19, 194, 194)'
          }
        }
      })
      mybricks_harmony_button({
        data: new mybricks_harmony_button_Data({
          text: '我是按钮'
        }),
        styles: {
          'button': {
            // 'backgroundColor': 'red',
            // 'fontSize': '20'
          }
        }
      })
    }
  }

  build() {
    Column() {
      mybricks_harmony_systemPage({
        slots: this.slots.bind(this),
        data: new mybricks_harmony_systemPage_Data({
          background: '#eeeeee'
          // 'enablePullDownRefresh': '',
        })
      })
    }
    .height('100%')
    .width('100%')
  }
}