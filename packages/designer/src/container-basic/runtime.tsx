import React, { useCallback, useMemo } from "react";
import { View } from "@tarojs/components";
import css from "./style.less";
import cx from "classnames";
import Taro from "@tarojs/taro";

export default function ({ env, data, slots, inputs, outputs }) {
  const onClick = useCallback((e) => {
    if (!env.runtime) {
      return;
    }

    // 当配置了单击事件，阻止事件冒泡
    if (outputs["onClick"].getConnections().length) {
      e.stopPropagation();
    }

    outputs["onClick"]?.();
  }, []);

  // const style_sub = useMemo(() => {
  //   if (data.overflowVisible) {
  //     return {
  //       overflow: "visible",
  //     }
  //   } else {
  //     return {
  //       overflow: "hidden"
  //     }
  //   }
  // }, [data.overflowVisible])

  return (
      <View className={cx(css.container, "mybricks-container")} onClick={onClick}>
        {slots["content"].render({
          style: {
            ...data.layout,
          },
        })}
      </View>

  );
}
