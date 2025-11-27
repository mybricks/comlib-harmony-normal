const icons = [
  'airplane_fill',
  'alarm_fill_1',
  'arrow_clockwise',
  'arrow_counterclockwise',
  'arrow_counterclockwise_clock',
  'arrow_down_right_and_arrow_up_left',
  'arrow_left',
  'arrow_right',
  'arrow_right_up_and_square',
  'arrow_up_left_and_arrow_down_right',
  'arrow_up_to_line',
  'arrowshape_turn_up_right_fill',
  'backward_end_fill',
  'battery',
  'battery_75percent',
  'bell_fill',
  'bluetooth',
  'bluetooth_slash',
  'bookmark',
  'calendar',
  'camera',
  'camera_fill',
  'checkmark',
  'checkmark_circle',
  'checkmark_circle_fill',
  'checkmark_square',
  'checkmark_square_fill',
  'chevron_down',
  'chevron_left',
  'chevron_right',
  'chevron_up',
  'clock',
  'dial',
  'doc_plaintext',
  'doc_plaintext_and_pencil',
  'doc_text_badge_arrow_up',
  'doc_text_badge_magnifyingglass',
  'ellipsis_message',
  'envelope',
  'eye',
  'eye_slash',
  'fast_forward',
  'folder',
  'folder_badge_plus',
  'forward_end_fill',
  'gearshape',
  'hand_thumbsup_fill',
  'headphones_fill',
  'heart',
  'heart_fill',
  'heart_slash',
  'house',
  'house_fill',
  'line_viewfinder',
  'list_square_bill',
  'livephoto',
  'lock',
  'lock_open',
  'magnifyingglass',
  'message',
  'message_on_message',
  'mic',
  'music',
  'music_note_list',
  'paintpalette',
  'paperclip',
  'pause',
  'picture',
  'picture_2',
  'picture_damage',
  'play_circle_fill',
  'play_fill',
  'play_round_rectangle_fill',
  'play_video',
  'plus',
  'qrcode',
  'record_circle',
  'resolution_video',
  'save',
  'share',
  'template',
  'text_clipboard',
  'timer',
  'trash',
  'wifi',
  'worldclock',
  'xmark'
]

export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: `图标，内置丰富的图标类型，也可作为图标样式的按钮使用
何时使用：任何时候优先推荐此组件，当明确发现导航入口、图标时，使用此组件。
`,
    usage: `图标，内置丰富的图标类型，也可作为图标样式的按钮使用
何时使用：任何时候优先推荐此组件，当明确发现导航入口、图标时，使用此组件，而不是图片。
  data声明
  icon: string = "camera"
  fontColor: string = "#000000"
  fontSize: number = 24
  fontWeight: number = 400

  styleAry声明
  图标: .mybricks-icon 
  - 默认样式: 无
  - 可配置样式: padding、backgroundColor、border

  layout声明
  width: 可配置，默认24
  height: 可配置，默认为24

  通过layout的固定宽高可以实现类似按钮和图片的效果
  
  注意：如果配置背景，建议宽高和大小配置有区别，否则图标会占满背景。

  <允许使用的图标>
  ${icons.join('\n')}
  </允许使用的图标>`
  },
  modifyTptJson: (component) => {
    if (component?.data?.fontColor) {
      component.data.fontColor = [component.data.fontColor]
    }
    if (!component.data?.icon || !icons.includes(component?.data?.icon)) {
      if (!component?.data) {
        component.data = {
          
        }
      }
      component.data.icon = 'picture'
    }
  }
}