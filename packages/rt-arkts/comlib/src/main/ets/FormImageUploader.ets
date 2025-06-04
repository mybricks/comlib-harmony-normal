import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import fs from '@ohos.file.fs';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { AnyType } from './types'

export interface DataType {
  label?: string,
  name?: string,
  value?: Array<LocalImgList>,
  maxCount?: number,

}

@ObservedV2
export class Data implements DataType {
  @Trace label?: string
  @Trace name?: string | undefined
  @Trace value?: LocalImgList[] | undefined
  @Trace maxCount?: number | 1

  constructor(config: DataType) {
    this.label = config.label
    this.name = config.name
    this.value = config.value
    this.maxCount = config.maxCount
  }
}

interface Inputs {
  setValue: (fn: (val: string, outputRels?: void) => void) => void
  getValue: (fn: (val: string, outputRels?: void) => void) => void
  resetValue: (fn: (val: string, outputRels?: void) => void) => void
  setLabel: (fn: (val: string) => void) => void
  setPlaceholder: (fn: (val: string) => void) => void
  setDisabled: (fn: (val: string) => void) => void
  setMaxCount: (fn: (val: string, outputRels?: void) => void) => void
}

interface Outputs {
  onChange: (value: AnyType) => void
  setValueComplete: (value: string) => void
  returnValue: (value: string) => void
  resetValueComplete: (value: string) => void
  setDisabledComplete: (value: string) => void
  setMaxCountComplete: (value: string) => void
}

type DataSourceItem = Record<string, string | number | boolean | Object> | string | number | boolean

@Builder
function emptySlot(params: SlotsParamsItem) {
}

interface ItemParamsInputValues {
  index: number,
  itemData: DataSourceItem
}


export interface SlotsParamsItem {
  id: string,
  inputValues: ItemParamsInputValues
}

interface LocalImgList {
  index: number,
  uri: string
}


@ComponentV2
export default struct MyBricksFormImageUploader {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @BuilderParam slots: (slotsParams: SlotsParamsItem) => void = emptySlot;
  @Local LocalImgList: Array<LocalImgList> = []

  aboutToAppear(): void {

    this.inputs?.setValue((val:AnyType, outputRels: AnyType)=>{
      this.data.value = val
      outputRels?.["setValueComplete"]?.(val);
    })

    this.inputs?.getValue((val:AnyType, outputRels: AnyType)=>{
      outputRels?.["returnValue"]?.(this.data.value);
    })

    this.inputs?.resetValue((val:AnyType, outputRels: AnyType)=>{
      this.data.value = []
      outputRels?.["resetValueComplete"]?.(this.data.value);
    })

    this.inputs?.setLabel((val:AnyType)=>{
      this.data.label = val
    })

    this.inputs?.setMaxCount((val:AnyType)=>{
      this.data.maxCount = val
    })

  }

  async imageSelect() {
    try {
      let PhotoSelectOptions = new photoAccessHelper.PhotoSelectOptions();
      PhotoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE;
      PhotoSelectOptions.maxSelectNumber = 5;
      let photoPicker = new photoAccessHelper.PhotoViewPicker();
      photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
        //遍历上传的图片本地路径
        PhotoSelectResult.photoUris.map((uri, index) => {
          this._slotInput(uri, index)
          this.LocalImgList.push({ uri, index })
        })

        //这里因为还没有实现slot output所以先输出本地文件路径，并回显到value上
        this.outputs?.onChange(this.LocalImgList)
        this.data.value = this.LocalImgList

      }).catch((err: BusinessError) => {
        console.error(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
      });
    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
    }
  }

  deleteImage(index: number) {
    this.LocalImgList = this.LocalImgList.filter((_, i) => i !== index);
    this.data.value = this.LocalImgList
  }

  _slotInput(uri: string, index: number) {
    console.log(uri, index)
    this.slots({
      id: "customUpload",
      inputValues: {
        index,
        itemData: uri
      }
    })
  }

  build() {
    Flex({ wrap: FlexWrap.Wrap }) {
      ForEach(this.data.value, (item: LocalImgList, index) => {
        Column() {
          Stack({ alignContent: Alignment.TopEnd }) {
            Image(item.uri)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Cover)
            Column() {
              Text('x')
                .fontSize(9)
                .fontColor(Color.White)
                .offset({ x: 2, y: -2 })
            }
            .alignItems(HorizontalAlign.Center)
            .justifyContent(FlexAlign.Center)
            .width(18)
            .height(18)
            .borderRadius({
              topLeft: 0,
              topRight: 0,
              bottomLeft: 15,
              bottomRight: 0
            })
            .backgroundColor('rgba(0, 0, 0, 0.30)')
            .onClick(() => {
              this.deleteImage(index);
            })

          }
        }
        .width(80)
        .height(80)
        .margin({ right: 10, bottom: 10 })
      })
      if ((this.data?.value?.length ?? 0) < (this.data?.maxCount ?? 1)) {
        Column() {
          Text("+")
            .fontSize(20)
            .fontColor("#828282")

        }
        .width(80)
        .height(80)
        .margin({
          right: 10,
          bottom: 10
        })
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .border({
          width: 1,
          color: "#efefef",
          radius: 6,
          style: BorderStyle.Solid
        })
        .onClick(() => {
          this.imageSelect()
        })
      }

    }
    .width("100%")
    .height("100%")

    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-square'])
    )
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
