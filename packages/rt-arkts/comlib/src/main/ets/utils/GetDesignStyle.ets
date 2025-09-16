import { MyBricksModifier } from "@mybricks/render-utils"
export type CSSProperties = Record<string, string | number>

type ComponentAttribute = CommonAttribute

function isNil(value: string | number | null | undefined | ResourceColor | ResourceStr | BorderRadiuses | Length | LocalizedBorderRadiuses | SizeOptions | ImageSize): boolean {
  return value === null || value === undefined;
}

export class ApplyRootStyleModifier extends MyBricksModifier<ComponentAttribute> {
  updateNormalAttribute(instance: ComponentAttribute, style: CSSProperties): void {
    // width
    instance.width(style.width);
    // height
    instance.height(style.height);
    // zIndex
    instance.zIndex(style.zIndex as number);
    // marginTop
    // marginBottom
    // marginLeft
    // marginRight
    instance.margin({
      top: style.marginTop,
      right: style.marginRight,
      bottom: style.marginBottom,
      left: style.marginLeft
    })
    // paddingTop
    // paddingRight
    // paddingBottom
    // paddingLeft
    instance.padding({
      top: style.paddingTop,
      right: style.paddingRight,
      bottom: style.paddingBottom,
      left: style.paddingLeft
    })
    // flex
    if (typeof style.flex === "number") {
      instance.flexGrow(style.flex as number)
      instance.flexShrink(1)
      instance.flexBasis("0%")
    } else {
      instance.flexShrink(0)
    }
    // position
    if (["absolute", "fixed"].includes(style.position as string)) {
      instance.position({
        top: style.top as number,
        left: style.left as number,
        right: style.right as number,
        bottom: style.bottom as number,
      })
    }
  }
}

export class ApplyStyleModifier extends MyBricksModifier<ComponentAttribute> {
  private initBackgroundColor?: ResourceColor
  backgroundColor(color: ResourceColor) {
    this.initBackgroundColor = color
    return this
  }

  private initBackgroundImage?: ResourceStr
  backgroundImage(image: ResourceStr) {
    this.initBackgroundImage = image
    return this
  }

  private initBackgroundSize?: SizeOptions | ImageSize
  backgroundImageSize(size: SizeOptions | ImageSize) {
    this.initBackgroundSize = size
    return this
  }

  private initBorderRadius?: Length | BorderRadiuses | LocalizedBorderRadiuses
  borderRadius(radius: Length | BorderRadiuses | LocalizedBorderRadiuses) {
    this.initBorderRadius = radius
    return this
  }

  private initWidth?: Length
  width(width: Length) {
    this.initWidth = width
    return this
  }

  private initHeight?: Length
  height(height: Length) {
    this.initHeight = height
    return this
  }

  private initMargin?: Length
  margin(height: Length) {
    this.initHeight = height
    return this
  }

  private initPadding?: Padding
  padding(pad: Padding) {
    this.initPadding = pad
    return this
  }

  // private initPaddingTop?: Length
  // padding(len: Length) {
  //   this.initPaddingTop = len
  //   return this
  // }
  // private initPaddingLeft?: Length
  // padding(len: Length) {
  //   this.initPaddingLeft = len
  //   return this
  // }
  // private initPaddingRight?: Length
  // padding(len: Length) {
  //   this.initPaddingRight = len
  //   return this
  // }
  // private initPaddingTop?: Length
  // padding(len: Length) {
  //   this.initPaddingTop = len
  //   return this
  // }

  updateNormalAttribute(instance: ComponentAttribute, style: CSSProperties): void {
    const width = !isNil(style?.width) ? style?.width : this.initWidth;
    if (!isNil(width)) {
      instance.width(width)
    }
    const height = !isNil(style?.height) ? style?.height : this.initHeight;
    if (!isNil(height)) {
      instance.width(height)
    }

    const backgroundColor = style?.backgroundColor ?? this.initBackgroundColor;
    if (!isNil(backgroundColor)) {
      instance.backgroundColor(backgroundColor)
    }

    if (!isNil(style?.borderRadius)) {
      instance.borderRadius(parseFloat(String(style.borderRadius)))
    } else if (!isNil(this.initBorderRadius)) {
      instance.borderRadius(parseFloat(String(this.initBorderRadius)))
    }

    if (!isNil(style?.border) && typeof style?.border === 'string') {
      const settingBorder = parseBorder(style.border)
      instance.borderWidth(settingBorder.width)
      instance.borderStyle(settingBorder.style)
      instance.borderColor(settingBorder.color)
    } else {
      const borderTop = parseBorder(style?.borderTop as string)
      const borderLeft = parseBorder(style?.borderLeft as string)
      const borderRight = parseBorder(style?.borderRight as string)
      const borderBottom = parseBorder(style?.borderBottom as string)
      instance.borderWidth({
        top: borderTop.width,
        left: borderLeft.width,
        right: borderRight.width,
        bottom: borderBottom.width
      })
      instance.borderStyle({
        top: borderTop.style,
        left: borderLeft.style,
        right: borderRight.style,
        bottom: borderBottom.style
      })
      instance.borderColor({
        top: borderTop.color,
        left: borderLeft.color,
        right: borderRight.color,
        bottom: borderBottom.color
      })
    }

    let paddingTop = this.initPadding?.top ?? 0
    let paddingLeft = this.initPadding?.left ?? 0
    let paddingRight = this.initPadding?.right ?? 0
    let paddingBottom = this.initPadding?.bottom ?? 0

    const configPaddings = style?.padding ? String(style?.padding).split?.(' ') : [];
    if (configPaddings.length === 4) {
      paddingTop = parseFloat(configPaddings[0])
      paddingRight = parseFloat(configPaddings[1])
      paddingBottom = parseFloat(configPaddings[2])
      paddingLeft = parseFloat(configPaddings[3])
      instance.padding({
        left: paddingLeft,
        right: paddingRight,
        top: paddingTop,
        bottom: paddingBottom
      })
    } else if (configPaddings.length === 2) {
      const paddingTB = parseFloat(configPaddings[0])
      const paddingLR = parseFloat(configPaddings[1])
      instance.padding({
        left: paddingLR,
        right: paddingLR,
        top: paddingTB,
        bottom: paddingTB
      })
    } else if (configPaddings.length === 1) {
      const paddingValue = parseFloat(configPaddings[0])
      instance.padding({
        left: paddingValue,
        right: paddingValue,
        top: paddingValue,
        bottom: paddingValue
      })
    } else {
      instance.padding({
        left: style?.paddingLeft,
        right: style?.paddingRight,
        top: style?.paddingTop,
        bottom: style?.paddingBottom
      })
    }

    const backgroundSize = style?.backgroundSize ?? this.initBackgroundSize;
    if (!isNil(backgroundSize)) {
      switch (backgroundSize) {
        case 'contain': {
          instance.backgroundImageSize(ImageSize.Contain)
          break
        }
        case 'cover': {
          instance.backgroundImageSize(ImageSize.Cover)
          break
        }
        default: {
          instance.backgroundImageSize(ImageSize.Cover)
          break
        }
      }
    }

    const backgroundImage: string = style?.backgroundImage as string ?? this.initBackgroundImage as string;
    if (!isNil(backgroundImage)) {
      const regex = /url\((["']?)([^)"']+)\1\)/;
      const match = backgroundImage.match(regex);
      if (!isNil(match?.[2])) {
        instance.backgroundImage(match?.[2])
      }
    }

    if (!isNil(style?.filter)) {
      const result: FilterResult = getFilterMethodAndParams(style.filter as string);
      if (result.method === 'blur' && result.param) {
        instance.blur(parseFloat(result.param as string))
      }
    }
  }
}

export class ApplyFontStyleModifier extends  MyBricksModifier<TextAttribute | TextInputAttribute | TextAreaAttribute> {
  private initFontColor?: ResourceColor
  fontColor(color: ResourceColor) {
    this.initFontColor = color
    return this
  }

  private initFontSize?: number | string | Resource
  fontSize(size: number | string | Resource) {
    this.initFontSize = size
    return this
  }

  private initFontWeight?: number | FontWeight | string
  fontWeight(size: number | FontWeight | string) {
    this.initFontWeight = size
    return this
  }

  updateNormalAttribute(instance: TextAttribute | TextInputAttribute | TextAreaAttribute, style: CSSProperties): void {
    const color = style?.color ?? this.initFontColor
    if (color) {
      instance.fontColor(color)
    }
    const fontSize = style?.fontSize ? parseFloat(style?.fontSize as string) : this.initFontSize
    if (fontSize) {
      instance.fontSize(fontSize + 'fp')
    }

    const fontWeight = style?.fontWeight ?? this.initFontWeight
    if (fontWeight) {
      instance.fontWeight(fontWeight)
    }

    if (style?.lineHeight && typeof style?.lineHeight === 'string') {
      if (style.lineHeight.indexOf('px') > -1) {
        instance.lineHeight(parseFloat(String(style?.lineHeight)))
      } else {
        instance.lineHeight(parseFloat(String(style?.fontSize ?? 14)) * parseFloat(style?.lineHeight))
      }
    }
  }
}


interface BorderRsult {
  width?: number
  style?: BorderStyle
  color?: string | Color
}
function parseBorder(borderStr: string): BorderRsult {
  if (!borderStr) {
    return {}
  }
  const match = borderStr.match(/^(\d*\.?\d+\w+)\s+(solid|dashed|dotted)\s+(.+)$/);

  let style: BorderStyle = BorderStyle.Solid
  switch (match?.[2]) {
    case 'solid': {
      style = BorderStyle.Solid
      break
    }
    case 'dashed': {
      style = BorderStyle.Dashed
      break
    }
    case 'dotted': {
      style = BorderStyle.Dotted
      break
    }
    default: {
      style = BorderStyle.Solid
      break
    }
  }

  return {
    width: parseFloat(match?.[1] ?? '0'),
    style,
    color: match?.[3] ?? Color.Transparent
  };
}

interface FilterResult {
  method?: string,
  param?: string
}
function getFilterMethodAndParams (str: string): FilterResult {
  const reg  = /^([^(]+)\(([^)]+)\)$/;

  const match = str.match(reg);
  if (match) {
    const method = match[1];
    const param  = match[2];
    return {
      method,
      param
    }
  }
  return {
    method: undefined,
    param: undefined
  }
}