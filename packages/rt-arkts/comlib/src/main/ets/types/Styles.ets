type FontWeightEnum = FontWeight;

export declare namespace Styles {
  type Width = Length
  type Height = Length
  type Color = ResourceColor
  type FontSize = string | number
  type FontWeight = number | FontWeightEnum | string
  type BackgroundColor = ResourceColor
  type BorderRadius = Length | BorderRadiuses | LocalizedBorderRadiuses
  type Border = string
  type BorderTop = string
  type BorderLeft = string
  type BorderRight = string
  type BorderBottom = string
  type Padding = string | number
  type BackgroundSize = string
  type BackgroundImage = string
}

interface StylesRoot {
  width: Styles.Width
  height: Styles.Height
}

export interface BasicStylesType {
  /** 组件根节点样式 */
  root: StylesRoot
}
