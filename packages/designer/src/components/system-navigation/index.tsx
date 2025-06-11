import React, { useEffect, useMemo, useState } from 'react'
import { View, Image } from '@tarojs/components'
import cx from 'classnames'
import css from './index.less'
import { isDesigner } from '../../utils/env'
import * as Icons from './Icons'
export default function (props) {
  let { data, env, slots } = props

  const onBack = () => {
    if (env.runtime) {
      env.canvas.back()
    }
  }

  const statusBarStyle = useMemo(() => {
    return Object.assign({}, data.navigationBarStyle, data.statusBarStyle ?? {})
  }, [data.statusBarStyle, data.navigationBarStyle])

  const navigationBarStyle = useMemo(() => {
    return Object.assign({}, data.navigationBarStyle)
  }, [data.navigationBarStyle])

  return (
    <View className={css.header}>
      <StatusBar
        color={statusBarStyle.color}
        background={data.navigationStyle === 'none' ? 'transparent' : statusBarStyle.backgroundColor}
        fixed={data.navigationStyle === 'none'}
      />
      <View style={{ background: navigationBarStyle.backgroundColor }}>
        {data.navigationStyle === 'default' && (
          <DefaultNavigation data={data} onBack={onBack} />
        )}
        {data.navigationStyle === 'custom' &&
          slots['header']?.render({
            style: {
              ...(data.customNavigation?.layout || {}),
            },
          })}
        {data.navigationStyle === 'none' && null}
      </View>
    </View>
  )
}

function DefaultNavigation({ data, onBack }) {
  return (
    <View className={css.nav}>
      <View
        className={css.left}
        style={{ color: data.navigationBarStyle?.color, paddingLeft: 16 }}
        onClick={onBack}
      >
        {
          !!data.showBackIcon && <svg width="24" height="24">
            <rect width="24" height="24" opacity="0"></rect>
            <g>
              <path
                d="M9.22 18Q9.43 17.78 9.43 17.47Q9.43 17.16 9.22 16.94L4.18 11.88L9.19 6.79L9.24 6.74Q9.41 6.5 9.4 6.22Q9.38 5.93 9.19 5.74Q8.98 5.52 8.66 5.52Q8.35 5.52 8.14 5.74L2.86 11.11Q2.54 11.4 2.54 11.88Q2.54 12.26 2.76 12.55L2.86 12.65L8.14 18Q8.35 18.24 8.64 18.24Q8.93 18.24 9.22 18Z"
                fill="currentColor"
              ></path>
            </g>
          </svg>
        }
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
    <View
      className={`${css.statusBar} ${fixed ? css.fixed : ''}`}
      style={{ color, backgroundColor: background }}
    >
      <View className={css.left}>
        <View className={css.time}>10:32</View>
        <View className={css.net}>中国移动</View>
      </View>
      <View className={css.battery}>
        {Icons.Battery}
      </View>
    </View>
  )
}
