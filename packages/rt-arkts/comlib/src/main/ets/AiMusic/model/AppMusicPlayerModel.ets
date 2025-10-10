// 播放模式枚举
export enum PlayMode {
  SEQUENCE = 'sequence', // 顺序播放
  SINGLE = 'single',     // 单曲循环
  RANDOM = 'random'      // 随机播放
}

// 播放列表项
export interface PlaylistItem {
  id: string
  title: string
  artist: string
  coverImgUrl: string
  duration: number
}

export interface PositionItem {
  current: number
  duration: number
}






