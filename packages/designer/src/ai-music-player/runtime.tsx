import React, { useCallback, useMemo } from "react";
import { View } from "@tarojs/components";
import css from "./style.less";
import cx from "classnames";

export default function ({ env, data, slots, inputs, outputs }) {
  const onEditClick = useCallback((e) => {
    if (!env.runtime) {
      return;
    }
    // 当配置了单击事件，阻止事件冒泡
    if (outputs["onEditClick"].getConnections().length) {
      e.stopPropagation();
    }
    outputs["onEditClick"]?.();
  }, []);

  const onPlayListClick = useCallback((e) => {
    if (!env.runtime) {
      return;
    }
    // 当配置了单击事件，阻止事件冒泡
    if (outputs["onPlayListClick"].getConnections().length) {
      e.stopPropagation();
    }
    outputs["onPlayListClick"]?.();
  }, []);

    useMemo(() => {
      inputs?.["setTitle"]?.((src) => {

      });
    }, []);

  return (
      <View className={cx(css.player)} onClick={onEditClick}>
        <div className={cx(css.content)}>
          <div className={cx(css.name)}>歌曲名称</div>
          <div className={cx(css.toolbar)}>
            {slots["toolbar"].render()}
          </div>
        </div>

        <div className={cx(css.playlist)} onClick={onPlayListClick}>播放列表</div>
      </View>
  );
}
