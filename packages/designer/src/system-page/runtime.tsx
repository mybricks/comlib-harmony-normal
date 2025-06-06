import React, {
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from "react";
import { View } from "@tarojs/components";
import css from "./style.edit.less";
import cx from "classnames";
import { defaultSelectedIconPath, defaultNormalIconPath } from "./const";
import SystemTabbar from './../components/system-tabbar'
import SystemNavigation from "./../components/system-navigation";

const getDefaultTabItem = (id) => {
  return {
    scene: {
      id,
    },
    text: "标签项",
    selectedIconPath: defaultSelectedIconPath,
    selectedIconStyle: {
      width: "22px",
      height: "22px",
    },
    selectedTextStyle: {
      fontSize: 12,
      color: "#FD6A00",
    },
    normalIconPath: defaultNormalIconPath,
    normalIconStyle: {
      width: "22px",
      height: "22px",
    },
    normalTextStyle: {
      fontSize: 12,
      color: "#909093",
    },
  };
};

export default function ({ env, data, inputs, outputs, slots }) {
  data.id = env.canvas.id;

  useEffect(() => {
    window.__entryPagePath__?.on(data.id, (val) => {
      data.isEntryPagePath = val === data.id;
    });

    let defaultEntryPagePath = window.__entryPagePath__?.get() ?? "";
    data.isEntryPagePath = defaultEntryPagePath === data.id;

    return () => {
      window.__entryPagePath__?.off(data.id);
    };
  }, []);

  /**
   * 页面初始化
   */
  useEffect(() => {
    // 监听数据
    window.__tabbar__?.on(data.id, (val) => {
      data.tabBar = JSON.parse(JSON.stringify(val));
    });

    let defaultTabBar = window.__tabbar__?.get() ?? [];

    // 复制
    // data.useTabBar 为 true
    // data.tabBar.length 等于 defaultTabBar.length
    // 当前页面 不在 defaultTabBar 中
    if (
      data.useTabBar &&
      data.tabBar.length === defaultTabBar.length &&
      !isContain(data.id, defaultTabBar)
    ) {
      setTimeout(() => {
        let tabBar = JSON.parse(JSON.stringify(defaultTabBar));
        tabBar.push(getDefaultTabItem(data.id));

        window.__tabbar__?.set(JSON.parse(JSON.stringify(tabBar)));
      }, 0);
    }

    // 回滚：
    // data.useTabBar 为 true
    // data.tabBar.length 比 defaultTabBar.length 大
    // 当前页面 不在 defaultTabBar 中
    if (
      data.useTabbar &&
      data.tabBar.length > defaultTabBar.length &&
      !isContain(data.id, defaultTabBar)
    ) {
      window.__tabbar__?.set(JSON.parse(JSON.stringify(data.tabBar)));
    } else {
      data.tabBar = defaultTabBar;
    }

    return () => {
      window.__tabbar__?.off(data.id);
    };
  }, []);

  //
  let isContain = useCallback((sceneId, sceneList) => {
    return sceneList.find((item) => {
      return item.scene.id == sceneId;
    });
  }, []);

  const useTabBar = useMemo(() => {
    if (!data.useTabBar) {
      return 0;
    }
    if (data.tabBar.length < 2) {
      return -1;
    }
    if (data.tabBar.length > 5) {
      return -2;
    }
    let isContain = data.tabBar.find((item) => {
      return item.scene.id == env.canvas.id;
    });
    if (!isContain) {
      return 0;
    }
    return true;
  }, [data.useTabBar, data.tabBar, env.canvas.id]);

  const tabBar = useMemo(() => {
    switch (useTabBar) {
      case 0:
        return null;
      case -1:
        return (
          <View className={css.tabBarErrorTip}>
            （标签页数量少于2个，标签栏不显示）
          </View>
        );
      case -2:
        return (
          <View className={css.tabBarErrorTip}>
            （标签页数量大于5，标签栏不显示）
          </View>
        );
      default:
        return <SystemTabbar data={data} env={env} />;
    }
  }, [data, env, useTabBar]);

  const pageBackgroundStyle = useMemo(() => {
    let result = {};

    if (data.backgroundImage) {
      result["backgroundImage"] = `${data.backgroundImage}`;
    }

    if (data.backgroundSize) {
      result["backgroundSize"] = data.backgroundSize;
    }

    if (data.backgroundRepeat) {
      result["backgroundRepeat"] = data.backgroundRepeat;
    }

    if (data.backgroundPosition) {
      result["backgroundPosition"] = data.backgroundPosition;
    }

    if (data.background) {
      result["backgroundColor"] = data.background;
    }

    return result;
  }, [
    data.backgroundImage,
    data.backgroundSize,
    data.backgroundRepeat,
    data.backgroundPosition,
    data.background,
  ]);

  let contentStyle = {}
  if (data.navigationStyle === "default") {
    contentStyle = {...pageBackgroundStyle}
  }

  if (env.runtime) {
    contentStyle.height = 667
    contentStyle.flex = 'auto'
  }

  return (
    <View
      key={env.canvas.id}
      className={css.page}
      //自定义导航和隐藏导航，在这里配置背景
      style={{
        height: "100%",
        ...(data.navigationStyle !== "default" ? pageBackgroundStyle : {}),
      }}
    >
      {/* Header start */}
      <View className={"mybricks-navigation"}>
        <SystemNavigation data={data} env={env} slots={slots} />
      </View>
      {/* Header end */}

      {/* content start*/}

      <View
        className={cx(css.content, { [css.edit]: env?.edit })}
        //导航栏为默认的时候，在这里配置背景
        style={contentStyle}
      >
        {slots["content"]?.render?.()}
      </View>
      {/* content end*/}

      {/* Footer start */}
      {tabBar}
      {/* Footer end */}
    </View>
  );
}
