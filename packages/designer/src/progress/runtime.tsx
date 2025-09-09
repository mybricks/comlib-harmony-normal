import React, { useCallback, useEffect, useLayoutEffect, useState } from 'react'
import { View } from '@tarojs/components'
import css from './style.less'

export default function ({ env, data, inputs, outputs, title, style }) {
  const [percent, setPercent] = useState(env.edit ? 50 : data.initValue)

  useLayoutEffect(() => {
    inputs['setPercent']((val) => {
      setPercent(val)
    })
  }, [])

  return (
    <View className={`${css.progress} mybricks-progress-bg`}>
      <View className={`${css.bar} mybricks-progress-bar`} style={{ width: percent + '%' }}></View>
    </View>
  )
}
