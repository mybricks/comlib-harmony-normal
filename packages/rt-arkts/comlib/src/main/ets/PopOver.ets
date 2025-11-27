import {
  ApplyRootStyleModifier,
  ApplyStyleModifier,
  ApplyFontStyleModifier,
  CSSProperties
} from './utils/GetDesignStyle'
import { AnyType } from './types'

import { parseLinearGradient } from './utils/StyleMatching'
import { PopoverDialog } from '@kit.ArkUI';

export interface DataType {
  layout?: CSSProperties
  closeOnClick?: boolean
}

@ObservedV2
export class Data implements DataType {
  @Trace layout?: CSSProperties
  @Trace closeOnClick?: boolean

  constructor(config: DataType) {
    this.layout = config?.layout ?? {}
    this.closeOnClick = config?.closeOnClick ?? false
  }
}


interface Inputs {}

interface Outputs {
  onClick: (value?: AnyType) => void
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

export interface SlotsParams {
  id: string,
  style?: CSSProperties
}

@Builder
function emptySlot(params: SlotsParams) {
}

class DialogComponentController {
  private component: MyDialog = null as AnyType

  constructor() {
  }

  bindComponentController = (component: MyDialog) => {
    this.component = component
  }
  show = () => {
    this.component.isShow = true
  }
  hide = () => {
    this.component.isShow = false
  }
}

@Component
struct MyDialog {
  controller?: DialogComponentController
  @State isShow: boolean = false

  @Builder
  children() {
  }

  @BuilderParam renderChild: () => void = this.children;

  @Builder
  content() {
  }

  @BuilderParam renderContent: () => void = this.content;

  @Builder
  dialogBuilder() {
    this.renderContent()
  }

  aboutToAppear(): void {
    this.controller?.bindComponentController(this)
  }

  build() {
    PopoverDialog({
      visible: this.isShow,
      popover: {
        builder: () => {
          this.dialogBuilder();
        },
        radius: 0,
        shadow: {
          radius: 0,
          offsetX: 0,
          offsetY: 0,
          color: Color.Transparent
        },
        backgroundBlurStyle: BlurStyle.NONE,
        targetSpace: 0,
        arrowHeight: 0,
        arrowWidth: 0,
        enableArrow: false,
        showInSubWindow: false,
        popupColor: Color.Transparent
      },
      targetBuilder: () => {
        this.renderChild()
      },
    })
  }
}

@ComponentV2
export default struct MyBricksPopOver {
  @Param data: Data = new Data({});
  @Param styles: Record<string, CSSProperties> = {}
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param uid?: string = undefined;
  @Param parentSlot?: AnyType = undefined;
  @Param slotsIO?: AnyType = undefined;
  @BuilderParam slots: (slotsParams: SlotsParams) => void = emptySlot;
  @Param _env?: _Env = undefined
  @Param env?: Env = undefined
  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;
  @Local isShow: boolean = false
  popover: DialogComponentController = new DialogComponentController()

  aboutToAppear(): void {

  }

  @Builder
  PopoverContentBuilder() {
    Column() {
      this.slots({
        id: 'carrier',
      })
    }
    .parallelGesture(
      TapGesture({ count: 1 }).onAction((event: GestureEvent) => {
        if (this.data.closeOnClick) {
          this.popover.hide()
        }
      })
    )
    .height('fit-content')
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-carrier'])
    )
  }

  @Builder
  TargetBuilder() {
    Column() {
      this.slots({
        id: 'content',
        style: this.data.layout
      })
    }
    .parallelGesture(
      TapGesture({ count: 1 }).onAction((event: GestureEvent) => {
        this.popover.show()
      })
    )
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-popover'])
    )
    .linearGradient(parseLinearGradient(String(this.styles['.mybricks-popover']?.backgroundImage)))
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
  }

  build() {
    Column() {
      MyDialog({
        controller: this.popover,
        renderContent: this.PopoverContentBuilder.bind(this),
        renderChild: this.TargetBuilder.bind(this)
      })
    }
    .attributeModifier(this.modifier)
  }
}


