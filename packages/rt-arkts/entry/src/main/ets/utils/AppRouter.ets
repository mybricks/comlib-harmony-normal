type UnknownJson = Record<string, string | number | boolean | Object> | string | number | boolean

export interface TabBarConfig {
  text: string,
  id: string,
  selectedIconPath: string
  normalIconPath: string
  selectedTextStyle: Record<string, string | number>,
  selectedIconStyle: Record<string, string | number>,
  normalTextStyle: Record<string, string | number>,
  normalIconStyle: Record<string, string | number>,
  selectedBackgroundStyle: Record<string, string | number>,
  normalBackgroundStyle: Record<string, string | number>,
}

export type TabBarJson = Record<string, string | number | boolean | ESObject>

@ObservedV2
export class AppRouter {
  navPathStack: NavPathStack = new NavPathStack();
  routerStack: Array<string> = new Array();

  tabList: Array<TabBarConfig> = []

  @Trace activeTabIndex?: number = 0
  @Trace entryPageId?: string
  @Trace entryMode?: 'tab' | 'page' = 'tab'

  pageParams?: Map<string, UnknownJson | undefined> = new Map()

  public registTabbar (configList: Array<TabBarJson>) {
    this.tabList = configList as Array<TabBarConfig>
    return this
  }

  public registEntryPage(name: string) {
    const targetIndex = this.tabList.findIndex(t => t?.id === name)
    if (this.hasTabs() && targetIndex > -1) {
      this.entryMode = 'tab'
      this.activeTabIndex = targetIndex
    } else {
      this.entryMode = 'page'
      this.entryPageId = name
    }
  }

  public hasTabs() {
    return !!this.tabList.length
  }

  public isTabbarPage (name: string) {
    return this.tabList.some(item => item?.id === name)
  }

  public getParams(name: string) {
    if (this.isTabbarPage(name) && this.pageParams?.has(name)) {
      return this.pageParams?.get(name)
    }
    const paramsList = this.navPathStack.getParamByName(name) as UnknownJson[]
    return paramsList[paramsList.length - 1]
  }

  public push(name: string, params: UnknownJson | undefined = undefined,
    callback: Callback<PopInfo> | undefined = undefined) {
    if (this.isTabbarPage(name)) {
      this.clear(); // 一般来说回到tabbar再物理返回就是直接退出APP了，不会到启动页，也不会有历史页，所以清空
      this.activeTabIndex = this.tabList.findIndex(t => t.id === name);
      this.pageParams?.set(name, params)
      return
    }
    this.routerStack.push(name);
    this.navPathStack.pushPathByName(name, params, callback, true)
  }

  public replace(name: string, params: UnknownJson | undefined = undefined) {
    if (this.isTabbarPage(name)) {
      this.clear(); // 一般来说回到tabbar再物理返回就是直接退出APP了，不会到启动页，也不会有历史页，所以清空
      this.activeTabIndex = this.tabList.findIndex(t => t.id === name);
      this.pageParams?.set(name, params)
      return
    }
    this.routerStack.pop();
    this.routerStack.push(name);
    this.navPathStack.replacePathByName(name, params, true)
  }

  /** 返回上一页 */
  public pop(result?: Object) {
    if (result !== undefined) {
      this.navPathStack.pop(result, true)
    } else {
      this.navPathStack.pop(true)
    }
  }

  /** 返回到堆栈中最近的页面 */
  public popToName(name: string) {
    if (this.isTabbarPage(name)) {
      // TODO
      return
    }
    // 如果是要回到首页，直接清楚所有堆栈即可
    if (this.entryPageId === name) {
      this.clear();
      return
    }
    this.navPathStack.popToName(name)
    const targetIndex: number = Array.from(this.routerStack).lastIndexOf(name)
    if (targetIndex > -1) {
      this.routerStack = this.routerStack.slice(0, targetIndex + 1);
    }
  }

  public clear() {
    if (this.routerStack.length) {
      this.routerStack = new Array();
      this.navPathStack.clear();
    }
  }
}

export const appRouter = new AppRouter()