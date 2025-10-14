import { useEffect, useRef, useState, useCallback } from "react";
import { View } from "@tarojs/components";
import css from "./index.less";

export default function MySlider(IProps: {
  value: number;
  max: number;
  blockColor: string;
  trackColor: string;
  selectedColor: string;
  blockSize: number;
  onChange: (value: number) => void;
}) {
  const {
    value = 0,
    max = 100,
    blockColor = "#FA6400",
    trackColor = "#E5E5E5",
    selectedColor = "#FA6400",
    blockSize = 12,
    onChange,
  } = IProps;
  const sliderRef = useRef<HTMLDivElement>(null);
  const [current, setCurrent] = useState(0);

  const updateValue = (clientX: number) => {
    const rect = sliderRef.current?.getBoundingClientRect();
    if (!rect) return;
    let value = clientX - rect.left;
    if (value < 0) value = 0;
    if (value > rect.width) value = rect.width;
    setCurrent(value);
  };

  const handleChange = useCallback(() => {
    const rect = sliderRef.current?.getBoundingClientRect();
    if (!rect) return;
    const value = (current / rect.width) * max;
    onChange?.(value);
  }, [current, max]);

  useEffect(() => {
    const rect = sliderRef.current?.getBoundingClientRect();
    if (!rect) return;
    const _current = (value / max) * rect.width;
    setCurrent(_current);
  }, [value, max]);

  useEffect(() => {
    const el = sliderRef.current;
    if (!el) return;

    const onPointerDown = (e: PointerEvent) => {
      e.preventDefault();
      el.setPointerCapture(e.pointerId);
      updateValue(e.clientX);
    };
    const onPointerMove = (e: PointerEvent) => {
      if (e.pressure === 0) return; // 没按下就不处理
      e.preventDefault();
      updateValue(e.clientX);
    };
    const onPointerUp = (e: PointerEvent) => {
      e.preventDefault();
      el.releasePointerCapture(e.pointerId);
      handleChange();
    };

    el.addEventListener("pointerdown", onPointerDown);
    el.addEventListener("pointermove", onPointerMove);
    el.addEventListener("pointerup", onPointerUp);

    return () => {
      el.removeEventListener("pointerdown", onPointerDown);
      el.removeEventListener("pointermove", onPointerMove);
      el.removeEventListener("pointerup", onPointerUp);
    };
  }, [handleChange]);

  return (
    <View className={css.wrapper}>
      <View
        ref={sliderRef}
        className={css.slider}
        style={{
          backgroundColor: trackColor,
        }}
      >
        <View
          className={css.selected}
          style={{ width: `${current}px`, backgroundColor: selectedColor }}
        ></View>
        <View
          className={css.handle}
          style={{
            left: `${current}px`,
            backgroundColor: blockColor,
            width: `${blockSize}px`,
            height: `${blockSize}px`,
          }}
        />
      </View>
    </View>
  );
}
