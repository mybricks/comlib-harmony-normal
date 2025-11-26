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
import { parseBorder, parseMargin, parseSize } from './utils/StyleMatching';

export interface DataType {
  label?: string,
  name?: string,
  value?: Array<string>,
  maxCount?: number,
}

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

@ObservedV2
export class Data implements DataType {
  @Trace label?: string
  @Trace name?: string | undefined
  @Trace value?: Array<string>
  @Trace maxCount: number = 1

  constructor(config: DataType) {
    this.label = config.label
    this.name = config.name
    this.value = config.value
    this.maxCount = config.maxCount || 1
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
  index?: number,
  itemData?: DataSourceItem,
  fileData: AnyType;
}


export interface SlotsParamsItem {
  id: string,
  inputValues: ItemParamsInputValues,
  outputs:AnyType
}



interface ImgList {
  uploadedUrl: string
}


@ComponentV2
export default struct MyBricksFormImageUploader {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;

  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParamsItem) => void = emptySlot;

  @Param _env?: _Env = undefined
  @Param env?: Env = undefined

  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  aboutToAppear(): void {

    this.inputs?.setValue((val:AnyType, outputRels: AnyType)=>{
      let newValue: string[] = [];
      if (typeof val === 'string' && val.trim() !== '') {
        newValue = [val];
      }else{
        newValue = val
      }
      this.data.value = newValue;
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
      PhotoSelectOptions.maxSelectNumber = this.data.maxCount;
      let photoPicker = new photoAccessHelper.PhotoViewPicker();

      photoPicker.select(PhotoSelectOptions).then((PhotoSelectResult: photoAccessHelper.PhotoSelectResult) => {
        //遍历上传的图片本地路径
        PhotoSelectResult.photoUris.map((uri, index) => {
          this.slotsIO["customUpload"].inputs["fileData"]({filePath:uri,index:index})
        })
        
      }).catch((err: BusinessError) => {
        console.error(`PhotoViewPicker.select failed with err: ${err.code}, ${err.message}`);
      });



    } catch (error) {
      let err: BusinessError = error as BusinessError;
      console.error(`PhotoViewPicker failed with err: ${err.code}, ${err.message}`);
    }
  }

  deleteImage(index: number) {
    this.data.value= this.data.value?.filter((_, i) => i !== index);

  }


  build() {
    Flex({ wrap: FlexWrap.Wrap }) {
      ForEach(this.data.value, (item:string, index) => {
        Column() {
          Stack({ alignContent: Alignment.TopEnd }) {
            Image(item)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Cover)
            Column() {
              Text('x')
                .fontSize(12)
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
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks-square'])
            .borderRadius(3)
        )
        .border(parseBorder(this.styles['.mybricks-square'].border as string, '#EFEFEF', 1))
        .width(parseSize(this.styles['.mybricks-square']?.width) || 72)
        .height(parseSize(this.styles['.mybricks-square']?.height) || 72)
        .margin(parseMargin(this.styles['.mybricks-square'], { right: 10, bottom: 10, top: 0, left: 0 }))
        .clip(true)
      },(item: string) => item)
      if ((this.data?.value?.length ?? 0) < (this.data?.maxCount ?? 1)) {
        Column() {
          Text("+")
            .attributeModifier(
              new ApplyFontStyleModifier(this.styles['.mybricks-icon'])
                .fontSize(24)
                .fontColor("#ccc")
            )

        }
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Center)
        // .border({
        //   width: 1,
        //   color: "#efefef",
        //   radius: 6,
        //   style: BorderStyle.Solid
        // })
        .attributeModifier(
          new ApplyStyleModifier(this.styles['.mybricks-square'])
            .borderRadius(3)
        )
        .border(parseBorder(this.styles['.mybricks-square'].border as string, '#EFEFEF', 1))
        .width(parseSize(this.styles['.mybricks-square']?.width) || 72)
        .height(parseSize(this.styles['.mybricks-square']?.height) || 72)
        .margin(parseMargin(this.styles['.mybricks-square'], { right: 10, bottom: 10, top: 0, left: 0 }))
        .onClick(() => {
          this.imageSelect()
        })
      }

      this.slots({
        id: "customUpload",
        inputValues:{
          fileData:this.slotsIO.customUpload.inputs.fileData
        },
        outputs: {
          setFileInfo: this.slotsIO.customUpload.outputs.setFileInfo((value:string) => {
            if (!this.data.value) {
              this.data.value = [];
            }
            this.data.value?.push(value)
            this.outputs?.onChange(this.data.value)
            this.parentSlot?._inputs?.["onChange"]?.({
              id: this.uid,
              value:this.data.value,
            });
          })
        }
      })
    }
    .width("100%")
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'] || {})
    )
    .attributeModifier(this.modifier)
  }
}