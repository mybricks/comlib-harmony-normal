export type CSSProperties = Record<string, string | number>

type ComponentAttribute = CommonAttribute

function isNil(value: string | number | null | undefined | ResourceColor | ResourceStr | BorderRadiuses | Length | LocalizedBorderRadiuses | SizeOptions | ImageSize): boolean {
  return value === null || value === undefined;
}

export class ApplyRootStyleModifier implements AttributeModifier<ComponentAttribute> {
  private css: CSSProperties

  constructor(configCss: CSSProperties) {
    this.css = configCss
  }

  applyNormalAttribute(instance: ComponentAttribute): void {
    if (!isNil(this.css?.width)) {
      instance.width(this.css?.width)
    }
    if (!isNil(this.css?.height)) {
      instance.height(this.css?.height)
    }
  }
}

export class ApplyStyleModifier implements AttributeModifier<ComponentAttribute> {
  private css: CSSProperties

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

  constructor(configCss: CSSProperties) {
    this.css = configCss ?? {}
  }

  applyNormalAttribute(instance: ComponentAttribute): void {
    const width = !isNil(this.css?.width) ? this.css?.width : this.initWidth;
    if (!isNil(width)) {
      instance.width(width)
    }
    const height = !isNil(this.css?.height) ? this.css?.height : this.initHeight;
    if (!isNil(height)) {
      instance.width(height)
    }

    const backgroundColor = this.css?.backgroundColor ?? this.initBackgroundColor;
    if (!isNil(backgroundColor)) {
      instance.backgroundColor(backgroundColor)
    }

    if (!isNil(this.css?.borderRadius)) {
      instance.borderRadius(this.css.borderRadius)
    } else if (!isNil(this.initBorderRadius)) {
      instance.borderRadius(this.initBorderRadius)
    }

    if (!isNil(this.css.border) && typeof this.css.border === 'string') {
      const settingBorder = parseBorder(this.css.border)
      instance.borderWidth(settingBorder.width)
      instance.borderStyle(settingBorder.style)
      instance.borderColor(settingBorder.color)
    }
    if ([this.css.borderTop, this.css.borderBottom, this.css.borderLeft, this.css.borderRight].every(item => !isNil(item) && typeof item === 'string')) {
      const borderTop = parseBorder(this.css.borderTop as string)
      const borderLeft = parseBorder(this.css.borderLeft as string)
      const borderRight = parseBorder(this.css.borderRight as string)
      const borderBottom = parseBorder(this.css.borderBottom as string)
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

    let paddingTop = 0
    let paddingLeft = 0
    let paddingRight = 0
    let paddingBottom = 0

    const configPaddings = this.css?.padding ? String(this.css?.padding).split?.(' ') : [];
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
    }

    const backgroundSize = this.css?.backgroundSize ?? this.initBackgroundSize;
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

    const backgroundImage: string = this.css?.backgroundImage as string ?? this.initBackgroundImage as string;
    if (!isNil(backgroundImage)) {
      const regex = /url\((["']?)([^)"']+)\1\)/;
      const match = backgroundImage.match(regex);
      if (!isNil(match?.[2])) {
        instance.backgroundImage(match?.[2])
      }
    }
  }
}

export class ApplyFontStyleModifier implements AttributeModifier<TextAttribute | TextInputAttribute> {
  private css: CSSProperties

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

  constructor(configCss: CSSProperties) {
    this.css = configCss ?? {}
  }

  applyNormalAttribute(instance: TextAttribute | TextInputAttribute): void {
    const color = this.css?.color ?? this.initFontColor
    if (color) {
      instance.fontColor(color)
    }
    const fontSize = this.css?.fontSize ? parseFloat(this.css?.fontSize as string) : this.initFontSize
    if (fontSize) {
      instance.fontSize(fontSize + 'fp')
    }

    const fontWeight = this.css?.fontWeight ?? this.initFontWeight
    if (fontWeight) {
      instance.fontWeight(fontWeight)
    }
  }
}


interface BorderRsult {
  width: number
  style: BorderStyle
  color: string | Color
}
function parseBorder(borderStr: string): BorderRsult {
  const match = borderStr.match(/^(\d+\w+)\s+(solid|dashed|dotted)\s+(.+)$/);

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