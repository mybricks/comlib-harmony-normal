export class WorksItemModel {
  id: number=0
  fileName: string = "" //作品文件名称
  fileSize: number = 0 // 文件大小
  fileType: string = "file" // 文件类型（文件 or 后期可能存在的文件夹等）
  title: string = "平凡之路" // 作品显示名称
  localFileUrl: string = "" // 本地文件路径
  cloudFileUrl: string = "" // 云端文件路径
  thumbnailImgUrl: string = "" // 缩略图
  coverImgUrl: string = "" // 封面图片
  createTime: number = 0 // 创建时间
  updateTime: number = 0 // 更新时间
  duration: number = 0.0 // 时长
  artist: string = "" // 作者
  gender: number = 1 // 性别(1男 0 女)
  lyricFileUrl: string = "" // 歌词文件
  isDeleted: number = 0  // 是否删除 0否 1是
  isFavorite: number = 0  //  是否收藏 0否 1是
  isPinned: number = 0 // 是否置顶 0否 1是
  priority: number = 0 // 优先级
  lyricCaptions: string = "" // 歌词字幕
  lyricStr: string = "" // 歌词文本
  taskId: string = "" // 音乐生成任务id
  taskStatus: string = "" // 音乐生成任务状态
  taskPrompt: string = "" // 音乐生成任务提示词
  generationProgress: number = 0 // 音乐生成进度 0-100
}