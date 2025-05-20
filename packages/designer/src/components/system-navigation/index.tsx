import React, { useEffect, useMemo, useState } from 'react'
import { View, Image } from '@tarojs/components'
import cx from 'classnames'
import css from './index.less'
import { isDesigner } from '../../utils/env'

export default function (props) {
  let { data, env, slots } = props

  const onBack = () => {
    if (env.runtime) {
      env.canvas.back()
    }
  }

  const statusBarStyle = useMemo(() => {
    return Object.assign({}, data.navigationBarStyle, (data.statusBarStyle ?? {}))
  }, [data.statusBarStyle, data.navigationBarStyle])

  const navigationBarStyle = useMemo(() => {
    return Object.assign({}, data.navigationBarStyle)
  }, [ data.navigationBarStyle])

  return (
    <View
      className={css.header}
    >
      <StatusBar
        color={statusBarStyle.color}
        background={statusBarStyle.backgroundColor}
        fixed={data.navigationStyle === 'none'}
      />
      <View style={{ background: navigationBarStyle.backgroundColor }}>
        {data.navigationStyle === 'default' && <DefaultNavigation data={data} />}
        {data.navigationStyle === 'custom' &&
          slots['header']?.render({
            style: {
              ...(data.customNavigation?.layout || {}),
            },
          })}
        {
          data.navigationStyle === 'none' && null
        }
      </View>
    </View>
  )
}

function DefaultNavigation({ data }) {
  return (
    <View className={css.nav}>
      <View className={css.left}>
      </View>

      {/* title */}
      <View
        className={css.title}
        style={{ color: data.navigationBarStyle?.color }}
      >
        {data.navigationBarTitleText}
      </View>

      <View className={css.right}></View>
    </View>
  )
}

function StatusBar({ color, background, fixed = false }) {
  return (
    <View className={`${css.statusBar} ${fixed ? css.fixed : ''}`} style={{ color, backgroundColor: background }}>
      <View className={css.left}>
        <View className={css.time}>10:32</View>
        <View className={css.net}>中国移动</View>
      </View>
      <View className={css.battery}>100%</View>
    </View>
  )
}
