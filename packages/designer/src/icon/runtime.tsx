import React, { useCallback, useEffect, useMemo, useState } from 'react'
import css from './style.less'
import { View } from '@tarojs/components'
import { SymbolGlyph } from './../components/symbol-glyph'

export default function ({ env, data, logger, slots, inputs, outputs, title }) {
  return (
    <View className={css.icon} onClick={() => outputs?.onClick?.()}>
      <SymbolGlyph
        name={data.icon}
        fontColor={data.fontColor}
        fontSize={data.fontSize}
        fontWeight={data.fontWeight}
      />
    </View>
  )
}
