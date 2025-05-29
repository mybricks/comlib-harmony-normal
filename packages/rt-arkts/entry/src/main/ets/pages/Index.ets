import { router } from '@kit.ArkUI';

import {
  mybricks_harmony_button,
  mybricks_harmony_button_Data,
  mybricks_harmony_systemPage,
  mybricks_harmony_systemPage_Data,
  mybricks_harmony_formInput,
  mybricks_harmony_formInput_Data,
  mybricks_harmony_qrcode,
  mybricks_harmony_qrcode_Data,
  mybricks_harmony_formSwitch,
  mybricks_harmony_formSwitch_Data,
  mybricks_harmony_tabs,
  mybricks_harmony_tabs_Data,
  mybricks_harmony_sidebar,
  mybricks_harmony_sidebar_Data,
  mybricks_harmony_video,
  mybricks_harmony_video_Data
} from '@ohos/mybricks-comlib-harmony-normal'


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State fontNum: number = 12;

  @Builder
  slots(params: ESObject) {
    if (params.id === 'content') {
      // mybricks_harmony_button({
      //   data: new mybricks_harmony_button_Data({
      //     text: this.message
      //   }),
      //   styles: {
      //     '.mybricks-button': {
      //       'color': 'rgb(255, 169, 64)',
      //       'backgroundColor': 'red',
      //       // 'fontSize': '20',
      //       'border': '5px solid rgb(19, 194, 194)'
      //     }
      //   }
      // })
      // mybricks_harmony_button({
      //   data: new mybricks_harmony_button_Data({
      //     text: '我是按钮'
      //   }),
      //   styles: {
      //     'button': {
      //       // 'backgroundColor': 'red',
      //       // 'fontSize': '20'
      //     }
      //   }
      // })
      // mybricks_harmony_formInput({
      //   data: new mybricks_harmony_formInput_Data({"hideLabel":false,"label":"单行输入","name":"单行输入","value":"","placeholder":"请输入内容","type":"idcard","disabled":false,"required":false,"hidden":false,"maxlength":-1,"inputAlign":"left"}),
      //   styles: {".mybricks-input,.mybricks-h5Input .taroify-native-input":{"backgroundColor":"rgba(64,169,255,1)","padding":"12px","borderRadius":"40px"},"root":{"width":"100%","height":40}}
      // })

      // mybricks_harmony_qrcode({
      //   data: new mybricks_harmony_qrcode_Data({"text":"hello MyBricks","mode":"qrcode"}),
      //   styles: {"root":{"width":100,"height":100}}
      // })

      // mybricks_harmony_formSwitch({
      //   data: new mybricks_harmony_formSwitch_Data({"label":"开关","hideLabel":false,"name":"开关","value":false,"type":"switch"}),
      //   styles: {"root":{"width":"100%","height":"fit-content"}}
      // })

      // mybricks_harmony_tabs({
      //   data: new mybricks_harmony_tabs_Data({"mode":"topbar","new_index":3,"tabs":[{"_id":"tabId1","tabName":"标签项1","badge":""},{"_id":"tabId2","tabName":"标签项2","badge":""}],"edit":{"currentItemId":"","currentTabId":"tabId1"},"initChangeTab":false,"sticky":false,"slotStyle":{"position":"smart"},"contentShowType":"switch"}),
      //   styles: {"root":{"width":'100%',"height":200}},
      // })

      // mybricks_harmony_sidebar({
      //
      // })

      mybricks_harmony_video({
        data: new mybricks_harmony_video_Data({src:"https://www.runoob.com/try/demo_source/mov_bbb.mp4"}),
        styles: {"root":{"width":"100%","height":"900px"}}
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