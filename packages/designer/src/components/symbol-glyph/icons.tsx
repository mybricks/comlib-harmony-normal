import * as React from 'react'

export const HarmonyIcons = [
  {
    title: '系统UI',
    icons: {
      airplane_fill: '󰄓',
      arrow_clockwise: '󰃇',
      arrow_counterclockwise: '󰃈',
      arrow_counterclockwise_clock: '󰏕',
      arrow_down_right_and_arrow_up_left: '󰃉',
      arrow_right_up_and_square: '󰃋',
      arrow_up_left_and_arrow_down_right: '󰃍',
      arrowshape_turn_up_right_fill: '󰣂',
      battery: '󰄚',
      battery_75percent: '󰙙',
      bell_fill: '󰇑',
      bluetooth: '󰉔',
      bluetooth_slash: '󰉓',
      bookmark: '󰀊',
      checkmark: '󰀓',
      checkmark_circle: '󰀏',
      checkmark_circle_fill: '󰀎',
      checkmark_square: '󰀒',
      checkmark_square_fill: '󰇚',
      eye: '󰄠',
      eye_slash: '󰄟',
      gearshape: '󰀠',
      heart: '󰀥',
      heart_fill: '󰀡',
      heart_slash: '󰀤',
      house: '󰀧',
      house_fill: '󰀦',
      mic: '󰀆',
      plus: '󰀵',
      save: '󰀻',
      share: '󰀽',
      trash: '󰀁',
      wifi: '󰀀',
      line_viewfinder: '󰀨',
      xmark: '󰁖'
    },
  },
  {
    title: '时间',
    icons: {
      alarm_fill_1: '󰗯',
      calendar: '󰏚',
      clock: '󰏝',
      timer: '󰐆',
      worldclock: '󰐊'
    }
  },
  {
    title: '箭头',
    icons: {
      arrow_clockwise: '󰃇',
      arrow_down_right_and_arrow_up_left: '󰃉',
      arrow_left: '󰃊',
      arrow_right: '󰈱',
      chevron_down: '󰃛',
      chevron_left: '󰃚',
      chevron_right: '󰃙',
      chevron_up: '󰃘',
      arrow_up_left_and_arrow_down_right: '󰃍',
      arrow_up_to_line: '󰃏'
    }
  },
  {
    title: '通信',
    icons: {
      ellipsis_message: '󰂅',
      envelope: '󰂈',
      message: '󰂏',
      dial: '󰂁',
      message_on_message: '󰂎'
    }
  }
]


export default HarmonyIcons.reduce((acc, cur) => {
  const icons = cur.icons;
  Object.keys(icons).forEach(iconName => {
    acc[iconName] = icons[iconName]
  })
  return acc
}, {})
