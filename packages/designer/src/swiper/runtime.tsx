import React, { useCallback, useEffect, useMemo, useState } from 'react'
import { View, Image } from '@tarojs/components'
import { Swiper, SwiperItem } from './../components/swiper'
import EmptyCom from '../components/empty-com'
import SkeletonImage from './../components/skeleton-image'
import { isUndef } from './../utils/core'
import css from './style.less'

export default function ({ env, data, inputs, outputs, style, slots }) {
  // 当前选中的tab
  const [current, setCurrent] = useState(0)
  const [loadedImages, setLoadedImages] = useState([
    current,
    current + 1,
    data.items?.length ? data.items?.length - 1 : 0,
  ]) // 默认加载第一个和最后一个图片

  //判断是否是真机运行态
  const isRelEnv = useMemo(() => {
    if (env.runtime.debug || env.edit) {
      return false
    } else {
      return true
    }
  }, [env.runtime.debug, env.edit])

  useEffect(() => {
    if (env.edit && !isUndef(data?.edit?.current)) {
      setCurrent(data?.edit?.current)
    }
  }, [env.edit, data?.edit?.current])

  useMemo(() => {
    inputs['setItems']((val) => {
      data.items = val
    })

    inputs?.['activeIndex']?.((index) => {
      if (!isNaN(parseFloat(index))) {
        setCurrent(current)
      }
    }) 
  }, [])

  const onClick = useCallback(({ item, index }) => {
    // if (item.customLink) {
    //   Taro.navigateTo({
    //     url: item.customLink,
    //     fail: () => {
    //       Taro.switchTab({
    //         url: item.customLink,
    //       });
    //     },
    //   });
    //   return;
    // }
    outputs['onClick']?.({ item, index })
  }, [])

  const showIndicator = useMemo(() => {
    return data.showIndicator ?? true
  }, [data.showIndicator])

  const extra = useMemo(() => {
    if (env.edit) {
      return {
        autoplay: false,
        duration: 0,
      }
    }
    return {
      autoplay: !env.edit && !!data.autoplay,
      interval: data.interval || 5000,
      duration: data.duration ?? 500,
    }
  }, [env.edit, data.autoplay, data.duration])

  const onChange = useCallback((e) => {
    let source = e.detail.source
    if (env?.edit) {
      return
    }
    if (source === 'autoplay' || source === 'touch') {
      setCurrent(e.detail?.current)
    }
  }, [])

  useEffect(() => {
    setLoadedImages((c) => {
      const newLoadedImages = new Set(c)
      if (current + 1 < data.items.length) {
        newLoadedImages.add(current + 1) // 预加载后面一张图片
        return Array.from(newLoadedImages)
      }
      return c
    })
  }, [current, data.items.length])

  const renderItems = useCallback(
    (item, cdnCutSize) => {
      if (data.contentType === 'custom') {
        return slots[`slot_${item._id}`]?.render()
      }
      return (
        <SkeletonImage
          useHtml={env.edit}
          className={css.thumbnail}
          mode="aspectFill"
          src={data.items[current]?.thumbnail}
          nativeProps={{
            loading: 'lazy',
            decoding: 'async',
          }}
          cdnCut="auto"
          cdnCutOption={cdnCutSize}
        />
      )
    },
    [data.contentType, slots]
  )

  if (env.runtime && !data.items.length) {
    return null
  }

  if (env.edit && !data.items.length) {
    return <EmptyCom title="请配置幻灯片" />
  }

  return (
    <Swiper
      env={env}
      data={data}
      className={css.swiper}
      style={{ height: style.height }}
      current={current}
      onChange={onChange}
      indicator={showIndicator}
      circular={env.edit ? false : data.circular}
      {...extra}
    >
      {!isRelEnv && (
        <SwiperItem className={css.swiperItem}>
          {data.contentType !== 'custom' ? (
            <SkeletonImage
              useHtml={env.edit}
              className={css.thumbnail}
              mode="aspectFill"
              src={data.items[current]?.thumbnail}
              nativeProps={{
                loading: 'lazy',
                decoding: 'async',
              }}
              cdnCut="auto"
              cdnCutOption={{ width: style.width, height: style.height }}
            />
          ) : (
            <View key={data.items[current]?._id} style={{ width: '100%', height: '100%' }}>
              {slots[`slot_${data.items[current]?._id}`]?.render()}
            </View>
          )}
        </SwiperItem>
      )}
      {isRelEnv &&
        data.items.map((item, index) => {
          // 搭建态下加载全部
          const shouldLoad = loadedImages.includes(index)
          return (
            <SwiperItem
              key={item._id}
              className={css.swiperItem}
              onClick={() => {
                onClick({ item, index })
              }}
            >
              {data.contentType !== 'custom' ? (
                <SkeletonImage
                  useHtml={env.edit}
                  className={css.thumbnail}
                  mode="aspectFill"
                  src={shouldLoad ? item.thumbnail : ''}
                  nativeProps={{
                    loading: 'lazy',
                    decoding: 'async',
                  }}
                  cdnCut="auto"
                  cdnCutOption={{ width: style.width, height: style.height }}
                />
              ) : (
                slots[`slot_${item._id}`]?.render()
              )}
            </SwiperItem>
          )
        })}
    </Swiper>
  )
}
