import React, {
  useCallback,
  useEffect,
  useLayoutEffect,
  useState,
} from "react";
import { View, Text, Slider } from "@tarojs/components";
import MySlider from "../components/slider";

import css from "./style.less";

const step = 50;
const defaultTotal = 60000;
let interval;
export default function ({ env, data, inputs, outputs, title, style }) {
  const [total, setTotal] = useState(() => {
    if (env.edit) return defaultTotal;
    const _total = data.total ?? defaultTotal / 1000;
    return _total * 1000;
  });
  const [current, setCurrent] = useState(0);

  const formatTime = (milliseconds: number, showMillisecond?: boolean) => {
    if (!isFinite(milliseconds) || milliseconds < 0) {
      return "00:00:00";
    }
    const hour = Math.floor(milliseconds / (60 * 60 * 1000));
    const min = Math.floor((milliseconds % (60 * 60 * 1000)) / (60 * 1000));
    const sec = Math.floor((milliseconds % (60 * 1000)) / 1000);
    const ms = Math.floor(milliseconds % 1000)
      .toString()
      .padStart(3, "0");
    const defaultStr = [hour, min, sec]
      .map((i) => i.toString().padStart(2, "0"))
      .join(":");
    if (!showMillisecond) return defaultStr;
    return `${defaultStr}.${ms}`;
  };

  const handlePlay = useCallback(() => {
    if (interval) {
      clearInterval(interval);
      interval = null;
    }
    interval = setInterval(() => {
      setCurrent((prev: number) => {
        if (prev + step >= total) {
          clearInterval(interval);
          interval = null;
          outputs["onEnd"]?.();
          return total;
        }
        return prev + step;
      });
    }, step);
  }, [total]);

  const handlePause = useCallback(() => {
    clearInterval(interval);
    interval = null;
  }, []);

  const handleReset = useCallback(() => {
    setCurrent(0);
  }, []);

  const onChange = useCallback((value) => {
    setCurrent(value);
    outputs["onChange"]?.(value);
  }, []);

  useLayoutEffect(() => {
    inputs["setCurrent"]((val) => {
      setCurrent((val ?? 0) * 1000);
    });
  }, []);

  useLayoutEffect(() => {
    inputs["setTotal"]((val) => {
      setTotal((val ?? defaultTotal) * 1000);
    });
  }, []);

  useLayoutEffect(() => {
    inputs["play"](() => {
      handlePlay();
    });
  }, [handlePlay]);

  useLayoutEffect(() => {
    inputs["pause"](() => {
      handlePause();
    });
  }, []);

  useLayoutEffect(() => {
    inputs["reset"](() => {
      handleReset();
    });
  }, []);

  useEffect(() => {
    if (process.env.TARO_ENV !== "h5") return;

    const sliders = document.querySelectorAll(".weui-slider__handler");
    sliders.forEach((slider) => {
      let isDown = false;
      const onMouseDown = (e) => {
        isDown = true;
        e.preventDefault();
      };
      const onMouseMove = (e) => {
        if (!isDown) return;
        // 手动触发 touchmove 事件模拟
        const touchLike = {
          touches: [{ clientX: e.clientX, clientY: e.clientY }],
        };
        slider.dispatchEvent(
          new CustomEvent("touchmove", { detail: touchLike })
        );
      };
      const onMouseUp = () => (isDown = false);

      slider.addEventListener("mousedown", onMouseDown);
      window.addEventListener("mousemove", onMouseMove);
      window.addEventListener("mouseup", onMouseUp);
    });
  }, []);

  return (
    <View>
      {/* <Slider
        className="my-slider"
        step={1}
        value={current}
        max={total}
        blockColor={data.blockColor}
        backgroundColor={data.trackColor}
        activeColor={data.selectedColor}
        blockSize={data.blockSize}
        onChange={onChange}
      /> */}
      <MySlider
        value={current}
        max={total}
        blockColor={data.blockColor}
        trackColor={data.trackColor}
        selectedColor={data.selectedColor}
        blockSize={data.blockSize}
        onChange={onChange}
      />
      <View className={`${css.textGroup}`}>
        <Text className={`${css.text} mybricks-play-progress-text`}>
          {formatTime(current)}
        </Text>
        <Text className={`${css.text} mybricks-play-progress-text`}>
          {formatTime(total)}
        </Text>
      </View>
    </View>
  );
}
