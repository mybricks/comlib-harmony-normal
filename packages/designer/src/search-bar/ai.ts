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
  // ignore: true,
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '搜索框组件，搜索框内部左侧支持展示/隐藏图标，内部右侧支持展示/隐藏搜索按钮',
    usage: `搜索框组件，搜索框内部左侧支持展示/隐藏图标，内部右侧支持展示/隐藏搜索按钮
styleAry声明
输入框
  - 默认样式:
    - borderRadius: 2px
    - paddingLeft: 12px
    - paddingRight: 3px
    - paddingTop: 3px
    - paddingBottom: 3px
    - backgroundColor: #f7f8fa
  - 可编辑样式: background、border（非必要不加边框，不然会有割裂感）相关
输入框文本
  - 默认样式:
    - color: #323233
    - textAlign: left
    - fontSize: 14px
  - 可编辑样式:
    - color、fontSize、textAlign
提示内容文本
  - 默认样式:
    - color: #c0c0c0
  - 可编辑样式:
    - color
搜索按钮
  - 默认样式:
    - color: #ffffff
    - background: #fa6400
    - width: 50px
    - borderRadius: 2px
  - 可编辑样式:
    - color、background、width、border、borderRadius相关
  
  <允许使用的图标>
  ${icons.join('\n')}
  </允许使用的图标>
  `

  },
  modifyTptJson: (component) => {
    component?.style?.styleAry?.forEach((style, index) => {
      if (style.selector == ".searchBar") {
        style.selector = ".mybricks-searchBar"
      }
      if (style.selector == ".text") {
        style.selector = ".mybricks-searchBar-input .taroify-native-input"
      }
      if (style.selector == ".placeholder") {
        style.selector = ".mybricks-searchBar-input .taroify-native-input::placeholder"
      }
      if (style.selector == ".button") {
        style.selector = ".mybricks-searchButton"
      }
    })
  }
}