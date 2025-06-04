import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import picker from '@ohos.file.picker';
import fs from '@ohos.file.fs';
import common from '@ohos.app.ability.common';
import { BusinessError } from '@kit.BasicServicesKit';
import { AnyType } from './types'

export interface DataType {
  label?: string,
  name?: string,
  value?: Array<LocalFileList>,
  maxCount?: number,

}

@ObservedV2
export class Data implements DataType {
  @Trace label?: string
  @Trace name?: string | undefined
  @Trace value?: LocalFileList[] | []
  @Trace maxCount?: number | 1

  constructor(config: DataType) {
    this.label = config.label
    this.name = config.name
    this.value = config.value || []
    this.maxCount = config.maxCount
  }
}

interface Inputs {
  setValue: (fn: (val: AnyType, outputRels?: void) => void) => void
  getValue: (fn: (val: AnyType, outputRels?: void) => void) => void
  resetValue: (fn: (val: AnyType, outputRels?: void) => void) => void
  setLabel: (fn: (val: AnyType) => void) => void
  setPlaceholder: (fn: (val: AnyType) => void) => void
  setDisabled: (fn: (val: AnyType) => void) => void
  setMaxCount: (fn: (val: AnyType, outputRels?: void) => void) => void
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

interface LocalFileList {
  index: number,
  uri: string
}


@ComponentV2
export default struct MyBricksFormFileUploader {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @BuilderParam slots: (slotsParams: SlotsParamsItem) => void = emptySlot;

  @Local LocalFileList: Array<LocalFileList> = []

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

  async selectDocument() {
    try {
      const documentPicker = new picker.DocumentViewPicker();

      const options: picker.DocumentSelectOptions = {
        maxSelectNumber: this.data.maxCount, // 选择单个文件
        fileSuffixFilters: ['.doc', '.docx', '.pdf', '.txt'], // 限制文件类型
      };

      const result = await documentPicker.select(options);

      result.map((uri, index) => {
        this._slotInput(uri, index)
        this.LocalFileList.push(({ uri, index }))
      })

      //这里因为还没有实现slot output所以先输出本地文件路径，并回显到value上
      this.outputs?.onChange(this.LocalFileList)
      this.data.value = this.LocalFileList

    } catch (err) {
      console.error('Document picker error:', err);
    }
    return null;
  }

  deleteFile(index: number) {
    this.LocalFileList = this.LocalFileList.filter((_, i) => i !== index);
    this.data.value = this.LocalFileList
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
    Column() {
      if ((this.data?.value?.length ?? 0) < (this.data?.maxCount ?? 1)) {
        Column() {
          Text("+ 上传文件")
            .fontSize(14)
            .fontColor("#828282")
        }
        .width(120)
        .height(30)
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        .border({
          width: 1,
          color: "#efefef",
          radius: 6,
          style: BorderStyle.Solid
        })
        .onClick(() => {
          this.selectDocument()
        })
      }
      ForEach(this.data.value, (item: LocalFileList, index) => {

        Row() {
          Text(item.uri)
            .height(20)
            .fontSize(10)
            .fontColor("#828282")
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxLines(1)
            .width(200)
          Text('x')
            .fontSize(12)
            .width(20)
            .height(20)
            .fontColor(Color.Black)
            .onClick(() => {
              this.deleteFile(index);
            })
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(VerticalAlign.Top)
        .width("100%")
      })


    }
    .width("100%")
    .height("100%")
    .justifyContent(FlexAlign.Start)
    .alignItems(HorizontalAlign.Start)
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-square'])
    )
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }
}
