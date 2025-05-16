import React, { useEffect, useMemo, useState } from "react";
import { View, Image } from "@tarojs/components";
import cx from "classnames";
import * as Taro from "@tarojs/taro";
import css from "./style.less";
import { isDesigner } from "../../../utils/env";

const defaultMenuButtonBoundingClientRect = {
  width: 87,
  height: 32,
  top: 48,
  right: 368,
  bottom: 80,
  left: 281,
};

export default function (props) {
  let { env, data, slots } = props;

  const relativeRect = useMemo(() => {
    if (isDesigner(env)) {
      return defaultMenuButtonBoundingClientRect;
    } else {
      let boundingClientRect = Taro.getMenuButtonBoundingClientRect();
      let ratio = Taro.getSystemInfoSync().windowWidth / 375;

      return {
        width: boundingClientRect.width / ratio,
        height: boundingClientRect.height / ratio,
        top: boundingClientRect.top / ratio,
        right: boundingClientRect.right / ratio,
        bottom: boundingClientRect.bottom / ratio,
        left: boundingClientRect.left / ratio,
      };
    }
  }, []);

  const safeareaHeight = isDesigner(env)
    ? 44
    : relativeRect.top - (40 - relativeRect.height) / 2;

  // 自定义导航栏
  return (
    <View
      className={css.customNavigation}
      style={{ ...data.customNavigation.style }}
    >
      <View
        className={css.safearea}
        style={{
          height: safeareaHeight,
        }}
      ></View>

      <View
        className={css.main}
        style={{
          marginLeft: 375 - relativeRect.right,
          marginRight: 375 - relativeRect.right,
          height: 40, // 高度固定 40 px
        }}
      >

        <View className={cx("mybricks-mainSlot", css.title)}>
          {slots["mainSlot"]?.render({
            style: {
              ...(data.customNavigation?.mainSlotStyle || {}),
            },
          })}
        </View>
      </View>
    </View>
  );
}
