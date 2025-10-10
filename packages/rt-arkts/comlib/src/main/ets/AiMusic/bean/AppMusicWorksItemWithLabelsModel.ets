import { WorksItemModel } from "./AppMusicWorksItemModel";
import { faceDetector } from "@kit.CoreVisionKit";
import { WorksItemLabelModel } from "./AppMusicWorksItemLabelModel";

export class WorksItemWithLabelsModel {
  file: WorksItemModel
  labels: WorksItemLabelModel[] = []
  isSelected: boolean = false
  isEditMode: boolean = false

  constructor(file: WorksItemModel) {
    this.file = file
  }
}