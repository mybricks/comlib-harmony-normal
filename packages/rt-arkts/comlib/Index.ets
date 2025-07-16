import {
  MyBricks,
  context,
  Slot,
  Styles,
  Controller,
  createStyles,
  createSlotsIO,
  createJSHandle,
  createInputsHandle,
  createEventsHandle,
  MyBricksColumnModifier,
  ColumnVisibilityController,
  MyBricksComponentBuilderParams,
} from "@mybricks/render-utils";

import {
  mybricks_harmony__connector as basicMyBricksHarmony_connector,
  mybricks_harmony__showToast as basicMyBricksHarmony_showToast,
  mybricks_harmony__backTo as basicMyBricksHarmony_backTo,
  mybricks_harmony__aesEncode as basicMyBricksHarmony_aesEncode,
  mybricks_harmony__format as basicMyBricksHarmony_format,
  mybricks_harmony__timerDelay as basicMyBricksHarmony_timerDelay,
  mybricks_harmony__callPhone as basicMyBricksHarmony_callPhone,
  mybricks_harmony__vibrate as basicMyBricksHarmony_vibrate,
  mybricks_harmony__scanQrcode as basicMyBricksHarmony_scanQrcode,
  mybricks_harmony__chooseMedia as basicMyBricksHarmony_chooseMedia,
  mybricks_harmony__chooseFile as basicMyBricksHarmony_chooseFile,
  mybricks_harmony__getLocation as basicMyBricksHarmony_getLocation,
  mybricks_harmony__textToSpeech as basicMyBricksHarmony_textToSpeech,
  mybricks_harmony__openPetalMap as basicMyBricksHarmony_openPetalMap,
  mybricks_harmony_systemPage as BasicMyBricksHarmonySystemPage,
  mybricks_harmony_systemPage_Data,
  mybricks_harmony_systemWebview as BasicMyBricksHarmonySystemWebview,
  mybricks_harmony_systemWebview_Data,
  mybricks_harmony_popup as BasicMyBricksHarmonyPopup,
  mybricks_harmony_popup_Data,
  mybricks_harmony_containerRow as BasicMyBricksHarmonyContainerRow,
  mybricks_harmony_containerRow_Data,
  mybricks_harmony_searchBar as BasicMyBricksHarmonySearchBar,
  mybricks_harmony_searchBar_Data,
  mybricks_harmony_image as BasicMyBricksHarmonyImage,
  mybricks_harmony_image_Data,
  mybricks_harmony_video as BasicMyBricksHarmonyVideo,
  mybricks_harmony_video_Data,
  mybricks_harmony_button as BasicMyBricksHarmonyButton,
  mybricks_harmony_button_Data,
  mybricks_harmony_text as BasicMyBricksHarmonyText,
  mybricks_harmony_text_Data,
  mybricks_harmony_icon as BasicMyBricksHarmonyIcon,
  mybricks_harmony_icon_Data,
  mybricks_harmony_richText as BasicMyBricksHarmonyRichText,
  mybricks_harmony_richText_Data,
  mybricks_harmony_swiper as BasicMyBricksHarmonySwiper,
  mybricks_harmony_swiper_Data,
  mybricks_harmony_containerBasic as BasicMyBricksHarmonyContainerBasic,
  mybricks_harmony_containerBasic_Data,
  mybricks_harmony_tabs as BasicMyBricksHarmonyTabs,
  mybricks_harmony_tabs_Data,
  mybricks_harmony_containerList as BasicMyBricksHarmonyContainerList,
  mybricks_harmony_containerList_Data,
  mybricks_harmony_containerWaterfall as BasicMyBricksHarmonyContainerWaterfall,
  mybricks_harmony_containerWaterfall_Data,
  mybricks_harmony_containerCondition as BasicMyBricksHarmonyContainerCondition,
  mybricks_harmony_containerCondition_Data,
  mybricks_harmony_sidebar as BasicMyBricksHarmonySidebar,
  mybricks_harmony_sidebar_Data,
  mybricks_harmony_formContainer as BasicMyBricksHarmonyFormContainer,
  mybricks_harmony_formContainer_Data,
  mybricks_harmony_formInput as BasicMyBricksHarmonyFormInput,
  mybricks_harmony_formInput_Data,
  mybricks_harmony_formStepper as BasicMyBricksHarmonyFormStepper,
  mybricks_harmony_formStepper_Data,
  mybricks_harmony_formTextarea as BasicMyBricksHarmonyFormTextarea,
  mybricks_harmony_formTextarea_Data,
  mybricks_harmony_formPassword as BasicMyBricksHarmonyFormPassword,
  mybricks_harmony_formPassword_Data,
  mybricks_harmony_formSwitch as BasicMyBricksHarmonyFormSwitch,
  mybricks_harmony_formSwitch_Data,
  mybricks_harmony_formDatetime as BasicMyBricksHarmonyFormDatetime,
  mybricks_harmony_formDatetime_Data,
  mybricks_harmony_formRate as BasicMyBricksHarmonyFormRate,
  mybricks_harmony_formRate_Data,
  mybricks_harmony_formSelect as BasicMyBricksHarmonyFormSelect,
  mybricks_harmony_formSelect_Data,
  mybricks_harmony_formRadio as BasicMyBricksHarmonyFormRadio,
  mybricks_harmony_formRadio_Data,
  mybricks_harmony_formCheckbox as BasicMyBricksHarmonyFormCheckbox,
  mybricks_harmony_formCheckbox_Data,
  mybricks_harmony_smsInput as BasicMyBricksHarmonySmsInput,
  mybricks_harmony_smsInput_Data,
  mybricks_harmony_searchBar2 as BasicMyBricksHarmonySearchBar2,
  mybricks_harmony_searchBar2_Data,
  mybricks_harmony_formFileUploader as BasicMyBricksHarmonyFormFileUploader,
  mybricks_harmony_formFileUploader_Data,
  mybricks_harmony_formImageUploader as BasicMyBricksHarmonyFormImageUploader,
  mybricks_harmony_formImageUploader_Data,
  mybricks_harmony_formItemContainer as BasicMyBricksHarmonyFormItemContainer,
  mybricks_harmony_formItemContainer_Data,
  mybricks_harmony_cell as BasicMyBricksHarmonyCell,
  mybricks_harmony_cell_Data,
  mybricks_harmony_qrcode as BasicMyBricksHarmonyQrcode,
  mybricks_harmony_qrcode_Data,
  mybricks_harmony_cascader as BasicMyBricksHarmonyCascader,
  mybricks_harmony_cascader_Data,
  mybricks_harmony_petalMap as BasicMyBricksHarmonyPetalMap,
  mybricks_harmony_petalMap_Data,
  mybricks_harmony_support as BasicMyBricksHarmonySupport,
  mybricks_harmony_support_Data,
  mybricks_harmony_line as BasicMyBricksHarmonyLine,
  mybricks_harmony_line_Data,
  mybricks_harmony_timer as BasicMyBricksHarmonyTimer,
  mybricks_harmony_timer_Data,
} from "./src/main/ets/Index"

export const myBricksHarmony_connector =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_connector, { props, env: context.env });
  }

export const myBricksHarmony_showToast =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_showToast, { props, env: context.env });
  }

export const myBricksHarmony_backTo =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_backTo, { props, env: context.env });
  }

export const myBricksHarmony_aesEncode =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_aesEncode, { props, env: context.env });
  }

export const myBricksHarmony_format =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_format, { props, env: context.env });
  }

export const myBricksHarmony_timerDelay =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_timerDelay, { props, env: context.env });
  }

export const myBricksHarmony_callPhone =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_callPhone, { props, env: context.env });
  }

export const myBricksHarmony_vibrate =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_vibrate, { props, env: context.env });
  }

export const myBricksHarmony_scanQrcode =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_scanQrcode, { props, env: context.env });
  }

export const myBricksHarmony_chooseMedia =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_chooseMedia, { props, env: context.env });
  }

export const myBricksHarmony_chooseFile =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_chooseFile, { props, env: context.env });
  }

export const myBricksHarmony_getLocation =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_getLocation, { props, env: context.env });
  }

export const myBricksHarmony_textToSpeech =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_textToSpeech, { props, env: context.env });
  }

export const myBricksHarmony_openPetalMap =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_openPetalMap, { props, env: context.env });
  }

@Builder
function MyBricksHarmonySystemPageBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySystemPage({
    uid: params.uid,
    data: new mybricks_harmony_systemPage_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonySystemPage {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonySystemPageBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonySystemPageBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonySystemWebviewBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySystemWebview({
    uid: params.uid,
    data: new mybricks_harmony_systemWebview_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonySystemWebview {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonySystemWebviewBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonySystemWebviewBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyPopupBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyPopup({
    uid: params.uid,
    data: new mybricks_harmony_popup_Data(params.data as MyBricks.Any),

    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyPopup {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyPopupBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyPopupBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyContainerRowBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerRow({
    uid: params.uid,
    data: new mybricks_harmony_containerRow_Data(params.data as MyBricks.Any),


    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyContainerRow {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyContainerRowBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyContainerRowBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonySearchBarBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySearchBar({
    uid: params.uid,
    data: new mybricks_harmony_searchBar_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonySearchBar {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonySearchBarBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonySearchBarBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyImageBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyImage({
    uid: params.uid,
    data: new mybricks_harmony_image_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyImage {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyImageBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyImageBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyVideoBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyVideo({
    uid: params.uid,
    data: new mybricks_harmony_video_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyVideo {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyVideoBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyVideoBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyButtonBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyButton({
    uid: params.uid,
    data: new mybricks_harmony_button_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyButton {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyButtonBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyButtonBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyTextBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyText({
    uid: params.uid,
    data: new mybricks_harmony_text_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyText {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyTextBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyTextBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyIconBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyIcon({
    uid: params.uid,
    data: new mybricks_harmony_icon_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyIcon {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyIconBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyIconBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyRichTextBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyRichText({
    uid: params.uid,
    data: new mybricks_harmony_richText_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),

    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyRichText {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyRichTextBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyRichTextBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonySwiperBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySwiper({
    uid: params.uid,
    data: new mybricks_harmony_swiper_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonySwiper {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonySwiperBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonySwiperBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyContainerBasicBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerBasic({
    uid: params.uid,
    data: new mybricks_harmony_containerBasic_Data(params.data as MyBricks.Any),

    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyContainerBasic {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyContainerBasicBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyContainerBasicBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyTabsBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyTabs({
    uid: params.uid,
    data: new mybricks_harmony_tabs_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyTabs {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyTabsBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyTabsBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyContainerListBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerList({
    uid: params.uid,
    data: new mybricks_harmony_containerList_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyContainerList {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyContainerListBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyContainerListBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyContainerWaterfallBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerWaterfall({
    uid: params.uid,
    data: new mybricks_harmony_containerWaterfall_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyContainerWaterfall {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyContainerWaterfallBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyContainerWaterfallBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyContainerConditionBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerCondition({
    uid: params.uid,
    data: new mybricks_harmony_containerCondition_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyContainerCondition {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyContainerConditionBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyContainerConditionBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonySidebarBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySidebar({
    uid: params.uid,
    data: new mybricks_harmony_sidebar_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonySidebar {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonySidebarBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonySidebarBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormContainerBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormContainer({
    uid: params.uid,
    data: new mybricks_harmony_formContainer_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormContainer {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormContainerBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormContainerBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormInputBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormInput({
    uid: params.uid,
    data: new mybricks_harmony_formInput_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormInput {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormInputBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormInputBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormStepperBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormStepper({
    uid: params.uid,
    data: new mybricks_harmony_formStepper_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormStepper {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormStepperBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormStepperBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormTextareaBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormTextarea({
    uid: params.uid,
    data: new mybricks_harmony_formTextarea_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormTextarea {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormTextareaBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormTextareaBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormPasswordBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormPassword({
    uid: params.uid,
    data: new mybricks_harmony_formPassword_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormPassword {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormPasswordBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormPasswordBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormSwitchBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormSwitch({
    uid: params.uid,
    data: new mybricks_harmony_formSwitch_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormSwitch {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormSwitchBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormSwitchBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormDatetimeBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormDatetime({
    uid: params.uid,
    data: new mybricks_harmony_formDatetime_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormDatetime {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormDatetimeBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormDatetimeBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormRateBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormRate({
    uid: params.uid,
    data: new mybricks_harmony_formRate_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormRate {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormRateBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormRateBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormSelectBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormSelect({
    uid: params.uid,
    data: new mybricks_harmony_formSelect_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormSelect {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormSelectBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormSelectBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormRadioBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormRadio({
    uid: params.uid,
    data: new mybricks_harmony_formRadio_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormRadio {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormRadioBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormRadioBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormCheckboxBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormCheckbox({
    uid: params.uid,
    data: new mybricks_harmony_formCheckbox_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormCheckbox {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormCheckboxBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormCheckboxBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonySmsInputBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySmsInput({
    uid: params.uid,
    data: new mybricks_harmony_smsInput_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonySmsInput {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonySmsInputBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonySmsInputBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonySearchBar2Builder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySearchBar2({
    uid: params.uid,
    data: new mybricks_harmony_searchBar2_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonySearchBar2 {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonySearchBar2Builder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonySearchBar2Builder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormFileUploaderBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormFileUploader({
    uid: params.uid,
    data: new mybricks_harmony_formFileUploader_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormFileUploader {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormFileUploaderBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormFileUploaderBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormImageUploaderBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormImageUploader({
    uid: params.uid,
    data: new mybricks_harmony_formImageUploader_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormImageUploader {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormImageUploaderBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormImageUploaderBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyFormItemContainerBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormItemContainer({
    uid: params.uid,
    data: new mybricks_harmony_formItemContainer_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyFormItemContainer {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyFormItemContainerBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyFormItemContainerBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyCellBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyCell({
    uid: params.uid,
    data: new mybricks_harmony_cell_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyCell {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @BuilderParam slots: (params: MyBricks.SlotParams) => void = Slot;
  @Local slotsIO: MyBricks.Any = createSlotsIO();
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyCellBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyCellBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyQrcodeBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyQrcode({
    uid: params.uid,
    data: new mybricks_harmony_qrcode_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyQrcode {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyQrcodeBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyQrcodeBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyCascaderBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyCascader({
    uid: params.uid,
    data: new mybricks_harmony_cascader_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyCascader {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyCascaderBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyCascaderBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyPetalMapBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyPetalMap({
    uid: params.uid,
    data: new mybricks_harmony_petalMap_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyPetalMap {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyPetalMapBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyPetalMapBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonySupportBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySupport({
    uid: params.uid,
    data: new mybricks_harmony_support_Data(params.data as MyBricks.Any),


    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonySupport {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonySupportBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonySupportBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyLineBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyLine({
    uid: params.uid,
    data: new mybricks_harmony_line_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyLine {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyLineBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyLineBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}

@Builder
function MyBricksHarmonyTimerBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyTimer({
    uid: params.uid,
    data: new mybricks_harmony_timer_Data(params.data as MyBricks.Any),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot
  })
}

@ComponentV2
export struct MyBricksHarmonyTimer {
  @Param @Require uid: string;
  @Param @Require title: string;
  @Param controller: MyBricks.Controller = Controller();
  @Param @Require data: MyBricks.Data
  @Param events: MyBricks.Events = {}
  @Param styles: Styles = {};
  @Local columnVisibilityController: ColumnVisibilityController = new ColumnVisibilityController()
  @Param parentSlot?: MyBricks.SlotParams = undefined
  myBricksColumnModifier = new MyBricksColumnModifier(this.styles.root)

  build() {
    Column() {
      if (this.parentSlot?.itemWrap) {
        this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).wrap.builder(wrapBuilder(MyBricksHarmonyTimerBuilder), this, this.parentSlot.itemWrap({
          id: this.uid,
          inputs: this.controller._inputEvents
        }).params)
      } else {
        MyBricksHarmonyTimerBuilder(this)
      }
    }
    .attributeModifier(this.myBricksColumnModifier)
    .visibility(this.columnVisibilityController.visibility)
  }
}
