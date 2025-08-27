import {
  MyBricks,
  context,
  Slot,
  Styles,
  createData,
  Controller,
  createStyles,
  createSlotsIO,
  createJSHandle,
  createModifier,
  CommonModifier,
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
  mybricks_harmony__aliyunOssUpload as basicMyBricksHarmony_aliyunOssUpload,
  mybricks_harmony_systemPage as BasicMyBricksHarmonySystemPage,
  mybricks_harmony_systemPage_Data,
  mybricks_harmony_systemWebview as BasicMyBricksHarmonySystemWebview,
  mybricks_harmony_systemWebview_Data,
  mybricks_harmony_popup as BasicMyBricksHarmonyPopup,
  mybricks_harmony_popup_Data,
  mybricks_harmony_containerRow as BasicMyBricksHarmonyContainerRow,
  mybricks_harmony_containerRow_Data,
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
  mybricks_harmony_searchBar as BasicMyBricksHarmonySearchBar,
  mybricks_harmony_searchBar_Data,
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

export const myBricksHarmony_aliyunOssUpload =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_aliyunOssUpload, { props, env: context.env });
  }

@Builder
export function MyBricksHarmonySystemPage(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySystemPage({
    uid: params.uid,
    data: createData(params, mybricks_harmony_systemPage_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonySystemWebview(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySystemWebview({
    uid: params.uid,
    data: createData(params, mybricks_harmony_systemWebview_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyPopup(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyPopup({
    uid: params.uid,
    data: createData(params, mybricks_harmony_popup_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyContainerRow(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerRow({
    uid: params.uid,
    data: createData(params, mybricks_harmony_containerRow_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyImage(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyImage({
    uid: params.uid,
    data: createData(params, mybricks_harmony_image_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyVideo(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyVideo({
    uid: params.uid,
    data: createData(params, mybricks_harmony_video_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyButton(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyButton({
    uid: params.uid,
    data: createData(params, mybricks_harmony_button_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyText(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyText({
    uid: params.uid,
    data: createData(params, mybricks_harmony_text_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyIcon(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyIcon({
    uid: params.uid,
    data: createData(params, mybricks_harmony_icon_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyRichText(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyRichText({
    uid: params.uid,
    data: createData(params, mybricks_harmony_richText_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonySwiper(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySwiper({
    uid: params.uid,
    data: createData(params, mybricks_harmony_swiper_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyContainerBasic(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerBasic({
    uid: params.uid,
    data: createData(params, mybricks_harmony_containerBasic_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyTabs(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyTabs({
    uid: params.uid,
    data: createData(params, mybricks_harmony_tabs_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyContainerList(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerList({
    uid: params.uid,
    data: createData(params, mybricks_harmony_containerList_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyContainerWaterfall(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerWaterfall({
    uid: params.uid,
    data: createData(params, mybricks_harmony_containerWaterfall_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyContainerCondition(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerCondition({
    uid: params.uid,
    data: createData(params, mybricks_harmony_containerCondition_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonySidebar(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySidebar({
    uid: params.uid,
    data: createData(params, mybricks_harmony_sidebar_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormContainer(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormContainer({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formContainer_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormInput(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormInput({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formInput_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormStepper(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormStepper({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formStepper_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormTextarea(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormTextarea({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formTextarea_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormPassword(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormPassword({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formPassword_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormSwitch(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormSwitch({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formSwitch_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormDatetime(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormDatetime({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formDatetime_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormRate(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormRate({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formRate_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormSelect(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormSelect({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formSelect_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormRadio(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormRadio({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formRadio_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormCheckbox(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormCheckbox({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formCheckbox_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonySmsInput(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySmsInput({
    uid: params.uid,
    data: createData(params, mybricks_harmony_smsInput_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonySearchBar(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySearchBar({
    uid: params.uid,
    data: createData(params, mybricks_harmony_searchBar_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormFileUploader(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormFileUploader({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formFileUploader_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormImageUploader(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormImageUploader({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formImageUploader_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormItemContainer(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormItemContainer({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formItemContainer_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyCell(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyCell({
    uid: params.uid,
    data: createData(params, mybricks_harmony_cell_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: params.slotsIO,
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyQrcode(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyQrcode({
    uid: params.uid,
    data: createData(params, mybricks_harmony_qrcode_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyCascader(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyCascader({
    uid: params.uid,
    data: createData(params, mybricks_harmony_cascader_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyPetalMap(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyPetalMap({
    uid: params.uid,
    data: createData(params, mybricks_harmony_petalMap_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonySupport(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySupport({
    uid: params.uid,
    data: createData(params, mybricks_harmony_support_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyLine(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyLine({
    uid: params.uid,
    data: createData(params, mybricks_harmony_line_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyTimer(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyTimer({
    uid: params.uid,
    data: createData(params, mybricks_harmony_timer_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),


    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}
