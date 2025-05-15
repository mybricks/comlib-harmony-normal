import { router } from '@kit.ArkUI';

import {
  Mybricks_Harmony_Button,
  Mybricks_Harmony_Button_Data,
  Mybricks_Harmony_Button_DataType,
  Mybricks_Harmony_SystemPage,
  Mybricks_Harmony_SystemPage_Data,
} from '@ohos/mybricks-comlib-harmony-normal'


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State fontNum: number = 12;

  @Builder
  slots(params: ESObject) {
    if (params.id === 'content') {
      Mybricks_Harmony_Button({
        data: new Mybricks_Harmony_Button_Data({
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
      Mybricks_Harmony_Button({
        data: new Mybricks_Harmony_Button_Data({
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
      Mybricks_Harmony_SystemPage({
        slots: this.slots.bind(this),
        data: new Mybricks_Harmony_SystemPage_Data({
          background: '#eeeeee'
          // 'enablePullDownRefresh': '',
        })
      })
    }
    .height('100%')
    .width('100%')
  }
}