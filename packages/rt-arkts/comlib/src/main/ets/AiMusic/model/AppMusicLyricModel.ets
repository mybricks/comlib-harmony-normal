// 歌词行接口
export interface LyricLine {
  time: number  // 时间(秒)
  text: string  // 歌词文本
}

// 歌词字接口
export interface LyricWord {
  start_time: number  // 开始时间(毫秒)
  end_time: number    // 结束时间(毫秒)
  text: string      // 字的文本
  attribute: Record<string, object>
}

// 歌词句子接口
export interface LyricSentence {
  start_time: number    // 开始时间(毫秒)
  end_time: number      // 结束时间(毫秒)
  text: string        // 句子文本
  words: LyricWord[]  // 字级别时间戳
  attribute: Record<string, object>
}

// 歌词额外信息接口
export interface LyricExtra {
  language: string
  sta_use_batch_request: string
  asr_service: string
  caption_type: string
  is_singing: string
}

// 歌词属性接口
export interface LyricAttribute {
  extra: LyricExtra
}

// 歌词数据接口
export interface LyricData {
  attribute: LyricAttribute
  code: number
  duration: number
  id: string
  message: string
  utterances: LyricSentence[]
}