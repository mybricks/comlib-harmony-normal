import { router } from '@kit.ArkUI';

import {
  Mybricks_Button,
  Mybricks_Button_Data,
  Mybricks_System_Page,
  Mybricks_System_Page_Data,
  Mybricks_System_Page_SlotsParams_content
} from '@ohos/mybricks-comlib-harmony-normal'


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State fontNum: number = 12;

  @Builder
  slots(params: Mybricks_System_Page_SlotsParams_content) {
    if (params.id === 'content') {
      Mybricks_Button({
        data: new Mybricks_Button_Data({
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
      Mybricks_Button({
        data: new Mybricks_Button_Data({
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
      Mybricks_System_Page({
        slots: this.slots.bind(this)
      })
    }
    .height('100%')
    .width('100%')
  }
}