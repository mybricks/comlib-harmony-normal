import React, { useCallback, useEffect, useMemo, useState,useRef } from 'react'
import { View, Image } from '@tarojs/components'
import { isUndef } from './../utils/core'
import { uuid } from '../utils'
import css from './style.less'

const rowKey = '_id'

const mockData: DsItem[] = [
  { [rowKey]: 1, index: 1 },
  { [rowKey]: 2, index: 2 },
  { [rowKey]: 3, index: 3 },
] as DsItem[]

interface DsItem {
  item: any
  [rowKey]: string | number
  index: number
}

export default function ({ env, data, inputs, outputs, style, slots }) {
  const [dataSource, setDataSource] = useState<DsItem[]>(
    env.edit || env?.runtime?.debug?.prototype ? mockData : (data.dataSource ?? [])
  )

  useEffect(()=>{
    console.log("dataSource",dataSource)
  },[dataSource])

  useMemo(() => {
    inputs['setItems']((val, outputRels) => {
      if (Array.isArray(val)) {
        const ds = val.map((item, index) => ({
          item,
          [rowKey]: data.rowKey === '' ? uuid() : item[data.rowKey] || uuid(),
          index: index,
        }))
        setDataSource((c) => c.concat(ds))
        outputRels?.["setItemsDone"]?.('')
      }
    })
  }, [])

  const mountedRef = useRef(false);
  useEffect(() => {
    if (!mountedRef.current) {
      mountedRef.current = true
      return
    }

    if (env?.runtime) {
      if (Array.isArray(data.dataSource)) {
        const ds = data.dataSource.map((item, index) => ({
          item,
          [rowKey]: data.rowKey === "" ? uuid() : item[data.rowKey] || uuid(),
          index: index,
        }));
          setDataSource(ds);
      }
    }
  }, [data.dataSource, env?.runtime])

  if (env.runtime && !dataSource.length) {
    return null
  }

  return (
    <View className={css.marquee} style={{ columnGap: data.spacing }}>
      {(dataSource ?? []).map(({ [rowKey]: key, index: index, item: item }, _idx) => {
        return (
          <View className={css.marqueeItem} key={key}>
            {slots['item']?.render?.({
              inputValues: {
                itemData: item,
                index: index,
              },
              key,
              cache: {
                for: 0,
                index: _idx,
              },
              style: {
                minWidth: env?.edit && !slots['item']?.size ? 100 : 'unset',
              }
            })}
          </View>
        )
      })}
    </View>
  )
}
