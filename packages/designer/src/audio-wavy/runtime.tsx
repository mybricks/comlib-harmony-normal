import React, { useRef, useEffect, useState } from "react";
import { View } from "@tarojs/components";
import classNames from "classnames";
import css from "./style.less";

class Constants {
  static NORMAL_COLOR = "rgb(150 145 145)";
  static AUDIO_COLOR = "blue";
  static COLUMN_WIDTH = 2;
}

interface Data {
  // 间距
  gap: number;
  // 最小高度
  minHeight: number;
}

export default function ({ data, inputs }) {
  const containerRef = useRef<HTMLDivElement>();
  const context = useRef({
    // 输入长度
    audioLength: 0,
    // 振幅长度
    heightsLength: 0,
  });
  const [heights, setHeights] = useState<number[]>([]);

  useEffect(() => {
    inputs["push"]((height: number) => {
      setHeights((heights) => {
        context.current.audioLength += 1;
        const nextHeights = [...heights, height];
        nextHeights.shift();
        return nextHeights;
      });
    });

    const observerTarget = containerRef.current;
    const observer = new ResizeObserver((entries) => {
      const { width } = entries[0].contentRect;

      setHeights((heights) => {
        const count = width / (Constants.COLUMN_WIDTH + data.gap);
        const length = Math.round(count);

        if (!heights.length) {
          // 初始化
          context.current.heightsLength = length;
          return Array(length).fill(data.minHeight);
        }

        if (context.current.audioLength) {
          // 已经输入了，原始heights长度只允许增加
          if (length > heights.length) {
            // 把新的加在前面
            return [
              Array(length - heights.length).fill(data.minHeight),
              ...heights,
            ];
          } else {
            return heights;
          }
        }

        return Array(length).fill(data.minHeight);
      });
    });

    observer.observe(observerTarget!);

    return () => {
      observer.unobserve(observerTarget!);
    };
  }, []);

  return (
    // @ts-ignore
    <View
      // @ts-ignore
      ref={containerRef}
      className={classNames(css.container, "mybricks-audio-wavy")}
      style={{
        gap: data.gap,
      }}
    >
      {heights.map((height, index) => {
        return (
          // @ts-ignore
          <View
            key={index}
            className={classNames(css.column)}
            style={{
              height,
              width: Constants.COLUMN_WIDTH,
              borderRadius: Constants.COLUMN_WIDTH,
              backgroundColor:
                context.current.heightsLength - context.current.audioLength >
                index
                  ? Constants.NORMAL_COLOR
                  : Constants.AUDIO_COLOR,
            }}
          ></View>
        );
      })}
    </View>
  );
}
