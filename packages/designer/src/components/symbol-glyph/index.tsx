import SystemIcons from './icons'
import { View } from "@tarojs/components";
import css from './index.less'

export * from './icons'

export const SymbolGlyph = ({
  fontSize = 16,
  fontColor = [],
  fontWeight = 400,
  name,
  className = ''
}) => {
  return (
    <View class={`${css.hmIcon} ${className}`} style={{ fontSize, color: fontColor?.[0], fontWeight }}>
      {SystemIcons[name]}
    </View>
  )
}