export class WorksItemLabelModel {
  id: number=0 // 数据库主键
  worksRelativeId: string='' // 关联的作品id
  labelName: string='' // 标签名称
  labelType: string='' // 标签类别
  labelId: string = "" // 标签ID
  priority: number = 0 // 标签排序
}