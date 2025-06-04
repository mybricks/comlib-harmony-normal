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
  mybricks_harmony_video_Data,
  mybricks_harmony_swiper,
  mybricks_harmony_swiper_Data,
  mybricks_harmony_support,
  mybricks_harmony_support_Data,
  mybricks_harmony_searchBar,
  mybricks_harmony_searchBar_Data,
  mybricks_form_container,
  mybricks_form_container_Data,
  mybricks_form_container_DataType,
  mybricks_form_container_SlotsParams,
  mybricks_form_item,
  mybricks_harmony_cell,
  mybricks_harmony_cell_Data,
  mybricks_harmony_formSelect,
  mybricks_harmony_formSelect_Data,
  mybricks_harmony_formCheckbox,
  mybricks_harmony_formRate,
  mybricks_harmony_formRate_Data,
  mybricks_harmony_formCheckbox_Data,
  mybricks_harmony_line,
  mybricks_harmony_line_Data
} from '@ohos/mybricks-comlib-harmony-normal'


@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State fontNum: number = 12;

  @Builder
  textSlots() {
    Text('1232132232112213')
  }

  @Builder
  formContent(params: mybricks_form_container_SlotsParams) {
    if (params.id === 'content') {
      mybricks_form_item({
        label: '表单项'
      }) {
        mybricks_harmony_formInput()
      }

      // params.itemWrap({}).wrap.builder(params.itemWrap({}).params)
    }
  }

  @Builder
  slots(params: ESObject) {
    if (params.id === 'content') {

      mybricks_harmony_formRate({

      })

      mybricks_harmony_formSelect({
        data: new mybricks_harmony_formSelect_Data({
            label:"下拉选择",
            name:"下拉选择",
            placeholder:"点击选择",
            value:"",
          options:[{
            "label": "公开",
            "value": "公开"
          },{
            "label": "仅好友可见",
            "value": "仅好友可见"
          },{
            "label": "微信",
            "value": "微信"
          },{
            "label": "支付宝",
            "value": "支付宝"
          }]
        }),
        styles: {
          '.mybricks-select':{
            // 'height': '100px'
          }
        }
      })

      mybricks_harmony_formCheckbox({
        data: new mybricks_harmony_formCheckbox_Data({
          options: [
            {
              "label": "邮箱",
              "value": "邮箱",
              "icon": ""
            },
            {
              "label": "手机",
              "value": "手机",
              "icon": ""
            },
            {
              "label": "微信",
              "value": "微信",
              "icon": ""
            }
          ],
          direction:"horizontal"
        })
      })

      mybricks_harmony_line({
          data: new mybricks_harmony_line_Data({

          }),
        styles: {"root":{"width":"80%","height":"50"}
        }
      })
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

      mybricks_harmony_tabs({
        data: new mybricks_harmony_tabs_Data({
          "mode": "topbar",
          "new_index": 3,
          "tabs": [{ "_id": "tabId1", "tabName": "标签项1", "badge": "" },
            { "_id": "tabId2", "tabName": "标签项2", "badge": "" }],
          "edit": { "currentItemId": "", "currentTabId": "tabId1" },
          "initChangeTab": false,
          "sticky": false,
          "slotStyle": { "position": "smart" },
          "contentShowType": "switch"
        }),
        styles: { "root": { "width": '100%', "height": 200 } },
        slots: this.textSlots
      })

      // mybricks_harmony_sidebar({
      //
      // })

      // mybricks_harmony_video({
      //   data: new mybricks_harmony_video_Data({src:"https://www.runoob.com/try/demo_source/mov_bbb.mp4"}),
      //   styles: {"root":{"width":"100%","height":"700px"}}
      // })

      // mybricks_harmony_swiper({
      //   data: new mybricks_harmony_swiper_Data({
      //     items:[
      //       {
      //         thumbnail:"https://assets.mybricks.world/ZDtHHguIHnmGhnqni1E1xjAc1PI5EFtg-1748507591263.png"
      //       },
      //       {
      //         thumbnail:"https://assets.mybricks.world/n1YmzqmSO1vVhQz5CrIec6rFmZxnOBhe-1748507670676.png"
      //     }
      //     ],
      //     autoplay:true,
      //     duration:800,
      //     showIndicator:true,
      //     circular:true
      //   }),
      //   styles: {"root":{"width":"100%","height":"900px"}}
      // })

      // mybricks_harmony_support({
      //   data: new mybricks_harmony_support_Data({
      //     copyright:"xxx",
      //     logo:"data:image/png;base64,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"
      //   }),
      //   styles: {"root":{"width":"600px","height":"max-content"}}
      // })

      // mybricks_harmony_searchBar({
      //   data: new mybricks_harmony_searchBar_Data({
      //     searchButtonText:"搜索",
      //     clearable:false,
      //     placeholderText:"输入你要搜索的内容",
      //     autoFocus:false,
      //     showSearchButton:true,
      //     label:"提示"
      //   }),
      //   styles: {"root":{"width":"100%","height":"max-content"}}
      // })

      // mybricks_harmony_cell({
      //   data: new mybricks_harmony_cell_Data({
      //     title:"标题",
      //     brief:"简介",
      //     content:"文本内容"
      //   }),
      //   styles: {"root":{"width":"100%","height":"300px"}}
      // })

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