import {
  MyBricks,
  context,
  createData,
  createStyles,
  createSlotsIO,
  createJSHandle,
  createModifier,
  CommonModifier,
  createInputsHandle,
  createEventsHandle,
  MyBricksComponentBuilderParams
} from '@mybricks/render-utils';

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
  mybricks_harmony__getPreferences as basicMyBricksHarmony_getPreferences,
  mybricks_harmony__setPreferences as basicMyBricksHarmony_setPreferences,
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
} from './src/main/ets/Index'

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

export const myBricksHarmony_getPreferences =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_getPreferences, { props, env: context.env });
  }

export const myBricksHarmony_setPreferences =
  (props: MyBricks.JSParams): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
    return createJSHandle(basicMyBricksHarmony_setPreferences, { props, env: context.env });
  }

@Builder
function MyBricksHarmonySystemPageBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySystemPage({
    uid: params.uid,
    data: createData(params, mybricks_harmony_systemPage_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonySystemPage(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonySystemPageBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonySystemPageBuilder(params)
  }
}

@Builder
function MyBricksHarmonySystemWebviewBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonySystemWebview(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonySystemWebviewBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonySystemWebviewBuilder(params)
  }
}

@Builder
function MyBricksHarmonyPopupBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyPopup({
    uid: params.uid,
    data: createData(params, mybricks_harmony_popup_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyPopup(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyPopupBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyPopupBuilder(params)
  }
}

@Builder
function MyBricksHarmonyContainerRowBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerRow({
    uid: params.uid,
    data: createData(params, mybricks_harmony_containerRow_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyContainerRow(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyContainerRowBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyContainerRowBuilder(params)
  }
}

@Builder
function MyBricksHarmonyImageBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyImage(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyImageBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyImageBuilder(params)
  }
}

@Builder
function MyBricksHarmonyVideoBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyVideo(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyVideoBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyVideoBuilder(params)
  }
}

@Builder
function MyBricksHarmonyButtonBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyButton({
    uid: params.uid,
    data: createData(params, mybricks_harmony_button_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyButton(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyButtonBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyButtonBuilder(params)
  }
}

@Builder
function MyBricksHarmonyTextBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyText(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyTextBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyTextBuilder(params)
  }
}

@Builder
function MyBricksHarmonyIconBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyIcon(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyIconBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyIconBuilder(params)
  }
}

@Builder
function MyBricksHarmonyRichTextBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyRichText(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyRichTextBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyRichTextBuilder(params)
  }
}

@Builder
function MyBricksHarmonySwiperBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySwiper({
    uid: params.uid,
    data: createData(params, mybricks_harmony_swiper_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonySwiper(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonySwiperBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonySwiperBuilder(params)
  }
}

@Builder
function MyBricksHarmonyContainerBasicBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerBasic({
    uid: params.uid,
    data: createData(params, mybricks_harmony_containerBasic_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyContainerBasic(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyContainerBasicBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyContainerBasicBuilder(params)
  }
}

@Builder
function MyBricksHarmonyTabsBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyTabs({
    uid: params.uid,
    data: createData(params, mybricks_harmony_tabs_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyTabs(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyTabsBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyTabsBuilder(params)
  }
}

@Builder
function MyBricksHarmonyContainerListBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerList({
    uid: params.uid,
    data: createData(params, mybricks_harmony_containerList_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyContainerList(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyContainerListBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyContainerListBuilder(params)
  }
}

@Builder
function MyBricksHarmonyContainerWaterfallBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerWaterfall({
    uid: params.uid,
    data: createData(params, mybricks_harmony_containerWaterfall_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyContainerWaterfall(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyContainerWaterfallBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyContainerWaterfallBuilder(params)
  }
}

@Builder
function MyBricksHarmonyContainerConditionBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyContainerCondition({
    uid: params.uid,
    data: createData(params, mybricks_harmony_containerCondition_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyContainerCondition(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyContainerConditionBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyContainerConditionBuilder(params)
  }
}

@Builder
function MyBricksHarmonySidebarBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonySidebar({
    uid: params.uid,
    data: createData(params, mybricks_harmony_sidebar_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonySidebar(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonySidebarBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonySidebarBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormContainerBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormContainer({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formContainer_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormContainer(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormContainerBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormContainerBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormInputBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyFormInput(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormInputBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormInputBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormStepperBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyFormStepper(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormStepperBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormStepperBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormTextareaBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyFormTextarea(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormTextareaBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormTextareaBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormPasswordBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyFormPassword(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormPasswordBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormPasswordBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormSwitchBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyFormSwitch(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormSwitchBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormSwitchBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormDatetimeBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormDatetime({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formDatetime_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormDatetime(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormDatetimeBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormDatetimeBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormRateBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyFormRate(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormRateBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormRateBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormSelectBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormSelect({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formSelect_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormSelect(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormSelectBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormSelectBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormRadioBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyFormRadio(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormRadioBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormRadioBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormCheckboxBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyFormCheckbox(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormCheckboxBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormCheckboxBuilder(params)
  }
}

@Builder
function MyBricksHarmonySmsInputBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonySmsInput(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonySmsInputBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonySmsInputBuilder(params)
  }
}

@Builder
function MyBricksHarmonySearchBarBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonySearchBar(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonySearchBarBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonySearchBarBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormFileUploaderBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormFileUploader({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formFileUploader_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormFileUploader(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormFileUploaderBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormFileUploaderBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormImageUploaderBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormImageUploader({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formImageUploader_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormImageUploader(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormImageUploaderBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormImageUploaderBuilder(params)
  }
}

@Builder
function MyBricksHarmonyFormItemContainerBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyFormItemContainer({
    uid: params.uid,
    data: createData(params, mybricks_harmony_formItemContainer_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyFormItemContainer(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyFormItemContainerBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyFormItemContainerBuilder(params)
  }
}

@Builder
function MyBricksHarmonyCellBuilder(params: MyBricksComponentBuilderParams) {
  BasicMyBricksHarmonyCell({
    uid: params.uid,
    data: createData(params, mybricks_harmony_cell_Data),
    inputs: createInputsHandle(params),
    outputs: createEventsHandle(params),
    styles: createStyles(params),
    slots: params.slots,
    slotsIO: createSlotsIO(params),
    parentSlot: params.parentSlot,
    env: context.env,
    _env: context._env,
    modifier: createModifier(params, CommonModifier)
  })
}

@Builder
export function MyBricksHarmonyCell(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyCellBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyCellBuilder(params)
  }
}

@Builder
function MyBricksHarmonyQrcodeBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyQrcode(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyQrcodeBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyQrcodeBuilder(params)
  }
}

@Builder
function MyBricksHarmonyCascaderBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyCascader(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyCascaderBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyCascaderBuilder(params)
  }
}

@Builder
function MyBricksHarmonyPetalMapBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyPetalMap(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyPetalMapBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyPetalMapBuilder(params)
  }
}

@Builder
function MyBricksHarmonySupportBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonySupport(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonySupportBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonySupportBuilder(params)
  }
}

@Builder
function MyBricksHarmonyLineBuilder(params: MyBricksComponentBuilderParams) {
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
export function MyBricksHarmonyLine(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyLineBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyLineBuilder(params)
  }
}

@Builder
function MyBricksHarmonyTimerBuilder(params: MyBricksComponentBuilderParams) {
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

@Builder
export function MyBricksHarmonyTimer(params: MyBricksComponentBuilderParams) {
  if (params.parentSlot?.itemWrap) {
    params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).wrap.builder(wrapBuilder(MyBricksHarmonyTimerBuilder), params, params.parentSlot.itemWrap({
      id: params.uid,
      inputs: params.controller?._inputEvents
    }).params)
  } else {
    MyBricksHarmonyTimerBuilder(params)
  }
}
    
