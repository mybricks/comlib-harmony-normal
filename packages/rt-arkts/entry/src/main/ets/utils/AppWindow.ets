import { window } from '@kit.ArkUI';

@ObservedV2
class AppWindow {
  statusBarHeight: number = 0
  bottomBarHeight: number = 0
}

export const appWindow = new AppWindow()

export function initAppWindow () {
  // 沉浸模式相关
  window.getLastWindow(getContext()).then(win => {
    // 开启所有页面的沉浸式模式（开启全屏模式）
    win.setWindowLayoutFullScreen(true)

    // 获取状态栏和导航条的安全高度
    let areas = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM); // 以状态栏为避让
    appWindow.statusBarHeight = px2vp(areas.topRect.height);

    areas = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR); // 以导航条避让
    appWindow.bottomBarHeight = px2vp(areas.bottomRect.height);
  })
}

interface RgbRes {
  r: number,
  g: number,
  b: number
}
// 将十六进制颜色转换为 RGB
const hexToRgb = (hex: string): RgbRes => {
  // 移除 # 号
  hex = hex.replace('#', '');

  // 处理简写形式，如 #fff
  if (hex.length === 3) {
    hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
  }

  const r = parseInt(hex.substring(0, 2), 16);
  const g = parseInt(hex.substring(2, 4), 16);
  const b = parseInt(hex.substring(4, 6), 16);

  return {
    r,
    g,
    b
  };
};

// 计算颜色的亮度
const calculateBrightness = (color: string) => {
  // 如果是十六进制颜色
  if (color.startsWith('#')) {
    const rgb = hexToRgb(color);
    return (0.299 * rgb.r + 0.587 * rgb.g + 0.114 * rgb.b) / 255;
  }

  // 如果是 rgb/rgba 格式
  if (color.startsWith('rgb')) {
    const matches = color.match(/(\d+)/g);
    if (matches) {
      const r = Number(matches[0]);
      const g = Number(matches[1]);
      const b = Number(matches[2]);
      return (0.299 * r + 0.587 * g + 0.114 * b) / 255;
    }
  }

  return 1; // 默认返回白色
};

@ComponentV2
export struct AppCommonHeader {
  @Param barHeight: number = 40
  @Param titleColor: string = '#ffffff'
  @Param barBackgroundColor: string = '#464646'
  @Param title: string = '页面标题'

  aboutToAppear(): void {
    window.getLastWindow(getContext()).then(win => {
      win.setWindowSystemBarProperties({
        // 设置状态栏文本颜色为白色
        statusBarContentColor: calculateBrightness(this.barBackgroundColor) > 0.5 ? '#000000' : '#ffffff'
      })
    })
  }

  @Param onBack?: Function | null = null

  build() {
    Stack() {
      RelativeContainer() {
        Text(this.title)
          .fontSize(16)
          .width('50%')
          .height('100%')
          .fontColor(this.titleColor)
          .fontWeight(FontWeight.Medium)
          .ellipsisMode(EllipsisMode.END)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .textAlign(TextAlign.Center)
          .alignRules({
            middle: { anchor: "__container__", align: HorizontalAlign.Center },
          })
        if (!!this.onBack) {
          Column(){
            SymbolGlyph($r('sys.symbol.chevron_left'))
              .fontSize(32)
              .renderingStrategy(SymbolRenderingStrategy.SINGLE)
              .fontColor([this.titleColor, Color.White])
          }
          .height('100%')
          .width(36)
          .padding({
            left: 16
          })
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .alignRules({
            left: { anchor: "__container__", align: HorizontalAlign.Start },
          })
          .onClick(() => {
            this.onBack?.()
          })
        }
      }
      .width('100%')
      .height(this.barHeight)
    }
    .width('100%')
    .padding({ top: appWindow.statusBarHeight })
    .backgroundColor(this.barBackgroundColor)
  }
}

@ComponentV2
export struct AppCustomHeader {
  @Param barHeight: number = 40
  @Param titleColor: string = '#ffffff'
  @Param barBackgroundColor: string = '#ffffff'

  aboutToAppear(): void {
    window.getLastWindow(getContext()).then(win => {
      win.setWindowSystemBarProperties({
        // 设置状态栏文本颜色为白色
        statusBarContentColor: calculateBrightness(this.barBackgroundColor) > 0.5 ? '#000000' : '#ffffff'
      })
    })
  }

  build() {
    Column(){}
    .width('100%')
    .height(appWindow.statusBarHeight)
  }
}

