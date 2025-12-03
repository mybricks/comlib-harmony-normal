import { CSSProperties, ApplyRootStyleModifier, ApplyStyleModifier } from './utils/GetDesignStyle';

class Constants {
  static NORMAL_COLOR = "#969191";
  static AUDIO_COLOR = "blue";
  static COLUMN_WIDTH = 2;
}

export interface DataType {
  // 间距
  gap: number;
  // 最小高度
  minHeight: number;
}

@ObservedV2
export class Data implements DataType {
  @Trace gap: number;
  @Trace minHeight: number;

  constructor(config: DataType) {
    this.gap = config.gap;
    this.minHeight = config.minHeight;
  }
}

interface PrivateContext {
  // 输入长度
  audioLength: number;
  // 振幅长度
  heightsLength: number;
}

interface Inputs {
  push: (fn: (height: number) => void) => void;
  reset: (fn: () => void) => void
}

interface Outputs {}

interface Env {}

interface _Env {}

@ComponentV2
export default struct MyBricksAudioWavy {
  @Param uid?: string = undefined;
  @Param data: Data = new Data({
    gap: 5,
    minHeight: 10,
  });
  @Param inputs?: Inputs = undefined;
  @Param outputs?: Outputs = undefined;
  @Param styles: Record<string, CSSProperties> = {};
  @Param parentSlot?: ESObject = undefined;
  @Param env?: Env = undefined;
  @Param _env?: _Env = undefined;
  @Param modifier?: AttributeModifier<CommonAttribute> = undefined;

  @Local heights: number[] = [];
  @Local defaultHeightsLength: number = 0;

  private context: PrivateContext = {
    audioLength: 0,
    heightsLength: 0,
  }

  aboutToAppear() {
    this.inputs?.push((height) => {
      this.context.audioLength = this.context.audioLength + 1;
      this.heights.shift();
      this.heights.push(height);
    })

    this.inputs?.reset(() => {
      this.context.audioLength = 0;
      this.context.heightsLength = this.defaultHeightsLength;
      this.heights = Array(this.defaultHeightsLength).fill(this.data.minHeight);
    })
  }

  build() {

    Stack() {
      Row({ space: this.data.gap }) {
        ForEach(this.heights, (height: number, index) => {
          Column()
            .width(Constants.COLUMN_WIDTH)
            .height(height)
            .backgroundColor(this.context.heightsLength - this.context.audioLength > index ? Constants.NORMAL_COLOR : Constants.AUDIO_COLOR)
            .borderRadius(Constants.COLUMN_WIDTH)
        }, () => Math.random() + Date.now() + '')
      }
    }
    .onAreaChange((oldValue: Area, newValue: Area) => {
      const count = (newValue.width as number) / (Constants.COLUMN_WIDTH + this.data.gap);
      const length = Math.round(count)
      this.defaultHeightsLength = length
      if (!this.heights.length) {
        // 初始化
        this.context.heightsLength = length;
        this.heights = Array(length).fill(this.data.minHeight);
      } else if (this.context.audioLength) {
        if (length > this.heights.length) {
          this.heights = Array(length - this.heights.length).fill(this.data.minHeight).concat(this.heights);
        }
      } else {
        this.heights = Array(length).fill(this.data.minHeight);
      }
    })
    .attributeModifier(
      new ApplyRootStyleModifier(this.styles['root'])
    )
    .attributeModifier(
      new ApplyStyleModifier(this.styles['.mybricks-audio-wavy'])
    )
    .attributeModifier(this.modifier)
  }
}
