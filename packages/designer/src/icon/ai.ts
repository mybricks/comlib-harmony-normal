export default {
  ':root' ({ data }) {
    return {}
  },
  prompts: {
    summary: '一个普通的按钮',
    usage: `
  data声明
  icon: string = "camera"
  fontColor: string = "#000000"
  fontSize: number = 24
  fontWeight: number = 400

  styleAry声明
  无

  <允许使用的图标>
  airplane_fill
  alarm_fill_1
  arrow_clockwise
  arrow_counterclockwise
  arrow_counterclockwise_clock
  arrow_down_right_and_arrow_up_left
  arrow_left
  arrow_right
  arrow_right_up_and_square
  arrow_up_left_and_arrow_down_right
  arrow_up_to_line
  arrowshape_turn_up_right_fill
  backward_end_fill
  battery
  battery_75percent
  bell_fill
  bluetooth
  bluetooth_slash
  bookmark
  calendar
  camera
  camera_fill
  checkmark
  checkmark_circle
  checkmark_circle_fill
  checkmark_square
  checkmark_square_fill
  chevron_down
  chevron_left
  chevron_right
  chevron_up
  clock
  dial
  doc_plaintext
  doc_plaintext_and_pencil
  doc_text_badge_arrow_up
  doc_text_badge_magnifyingglass
  ellipsis_message
  envelope
  eye
  eye_slash
  fast_forward
  folder
  folder_badge_plus
  forward_end_fill
  gearshape
  hand_thumbsup_fill
  headphones_fill
  heart
  heart_fill
  heart_slash
  house
  house_fill
  line_viewfinder
  list_square_bill
  livephoto
  lock
  lock_open
  magnifyingglass
  message
  message_on_message
  mic
  music
  music_note_list
  paintpalette
  paperclip
  pause
  picture
  picture_2
  picture_damage
  play_circle_fill
  play_fill
  play_round_rectangle_fill
  play_video
  plus
  qrcode
  record_circle
  resolution_video
  save
  share
  template
  text_clipboard
  timer
  trash
  wifi
  worldclock
  xmark
  </允许使用的图标>`
  }
}