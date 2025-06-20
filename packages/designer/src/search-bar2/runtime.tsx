import React, {
  useCallback,
  useEffect,
  useState,
} from 'react'
import css from './style.less'
import cx from 'classnames'
import { View, Image } from '@tarojs/components'
import { Input } from 'brickd-mobile'
import { debounce } from './../utils/core'
import { Button } from '@tarojs/components'
import { SymbolGlyph } from './../components/symbol-glyph'

export default function ({ env, data, inputs, outputs }) {
  const [value, setValue] = useState('')
  const [autoFocus, setAutoFocus] = useState(false)

  useEffect(() => {
    inputs['setValue']((val) => {
      setValue(val)
    })

    inputs['getValue']?.((val, relOutputs) => {
      relOutputs['returnValue'](value)
    })

    inputs['focus']?.((val, relOutputs) => {
      setAutoFocus(true)
      relOutputs['focusDone'](val)
    })
  }, [value])

  const onClick = useCallback(() => {
    if (data.disabled) {
      outputs['onClick']?.(value)
    }
  }, [data.disabled])

  const onSearch = useCallback((e) => {
    outputs['onSearch']?.(e?.detail?.value)
  }, [])

  const onInput = useCallback((e) => {
    setValue(e.detail.value)
  }, [])

  const onChange = useCallback(
    debounce((e) => {
      outputs['onChange']?.(e.detail.value)
    }, 300),
    []
  )

  const onCancel = useCallback((e) => {
    outputs['onCancel']?.(true)
  }, [])

  const onClear = useCallback((e) => {
    setValue('')

    setTimeout(() => {
      outputs['onClear']?.('')
    }, 0)
  }, [])

  const onBlur = useCallback((e) => {
    //防止失去焦点后又自动聚焦
    setAutoFocus(false)
  }, [])

  const onButtonClick = useCallback(() => {
    outputs['onSearch']?.(value)
  }, [value])

  return (
    <View className={cx(css.searchBox, 'mybricks-searchBar')}>
      {/* 搜索框禁用时在上方加一层View，不然点击不生效 */}
      {data.disabled && (
        <View className={css.searchBoxDisabled} onClick={onClick}></View>
      )}
      {
        data.showSearchIcon && <SymbolGlyph className={cx(css.icon, 'mybricks-searchBar-input')} name={'magnifyingglass'} />
      }
      <Input
        className={cx(css.searchBar, 'mybricks-searchBar-input')}
        value={value}
        placeholder={data?.placeholderText}
        disabled={data.disabled}
        onClick={onClick}
        onChange={onChange}
        onCancel={onCancel}
        onBlur={onBlur}
      />
      {data.showSearchButton && (
        <Button
          className={cx(css.searchButton, 'mybricks-searchButton')}
          onClick={onButtonClick}
        >
          {data.searchButtonText}
        </Button>
      )}
    </View>
  )
}
