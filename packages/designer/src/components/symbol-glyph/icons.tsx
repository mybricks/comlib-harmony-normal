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
      hand_thumbsup_fill: '󰗗',
      heart: '󰀥',
      heart_fill: '󰀡',
      heart_slash: '󰀤',
      house: '󰀧',
      house_fill: '󰀦',
      lock: '󰀈',
      lock_open: '󰓄',
      magnifyingglass: '󰀩',
      qrcode: '󰄨',
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
    title: '媒体',
    icons: {
      camera: '󰑛',
      camera_fill: '󰐸',
      livephoto: '󰗷',
      paintpalette: '󰄥',
      picture: '󰀃',
      picture_2: '󰓥',
      picture_damage: '󰓩',
      play_video: '󰓮',
      resolution_video: '󰒣',
      template: '󰓿',
      doc_plaintext: '󰃁',
      doc_plaintext_and_pencil: '󰖯',
      doc_text_badge_arrow_up: '󰖱',
      doc_text_badge_magnifyingglass: '󰖳',
      folder: '󰃅',
      folder_badge_plus: '󰀄',
      list_square_bill: '󰖿',
      paperclip: '󰄏',
      text_clipboard: '󰆝',
      backward_end_fill: '󰂦',
      fast_forward: '󰙫',
      forward_end_fill: '󰂧',
      headphones_fill: '󰙲',
      music: '󰂭',
      music_note_list: '󰂬',
      play_fill: '󰂴',
      play_circle_fill: '󰂲',
      play_round_rectangle_fill: '󰠔',
      record_circle: '󰂷',
      pause: '󰂱',
    }
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
