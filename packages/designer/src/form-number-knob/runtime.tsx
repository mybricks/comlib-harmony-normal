import React, { useState, useCallback, useEffect, useRef } from "react";
import { View } from "@tarojs/components";
import { isObject, isString, isNumber, isEmpty } from "./../utils/type";
import useFormItemValue from "../utils/hooks/use-form-item-value";
import cls from "classnames";
import css from "./style.less";

export default function (props) {
  const { env, data, inputs, outputs, slots, parentSlot } = props;
  const [value, setValue, getValue] = useFormItemValue(data.value, (val) => {
    //
    parentSlot?._inputs["onChange"]?.({
      id: props.id,
      name: props.name,
      value: val,
    });

    //
    outputs["onChange"](val);
  });

  const knobRef = useRef<HTMLDivElement>(null);
  const [angle, setAngle] = useState(0);
  const [size, setSize] = useState(375);
  const [startAngle, setStartAngle] = useState(0);

  // -------------------------
  // 计算角度 + 数值变化
  // -------------------------
  const updateRotation = (clientX: number, clientY: number) => {
    const rect = knobRef.current!.getBoundingClientRect();
    const x = clientX - (rect.left + size / 2);
    const y = clientY - (rect.top + size / 2);
    const current = (Math.atan2(y, x) * 180) / Math.PI + 90;

    let delta = current - startAngle;

    // 处理跨越 -180 / 180 的角度跳变
    if (delta > 180) delta -= 360;
    if (delta < -180) delta += 360;
    setAngle(angle + delta);
    console.log("angle", startAngle, angle);
    setStartAngle(current);

    const angleVal = (angle / 360) * data.lapValue + data.min;
    const val = Math.min(Math.max(angleVal, data.min), data.max);
    data.value = Math.round(val);
  };

  const onMouseMove = (e: React.MouseEvent) => {
    if (data.disabled || env.edit) {
      return;
    }
    if (e.buttons === 1) {
      updateRotation(e.clientX, e.clientY);
    }
  };

  useEffect(() => {
    const obs = new ResizeObserver(([entry]) => {
      setSize(entry.contentRect.width);
    });

    if (knobRef.current) {
      obs.observe(knobRef.current);
    }

    return () => obs.disconnect();
  }, []);

  useEffect(() => {
    const result = formatValue(data.value);
    setValue(result);
  }, [data.value]);

  useEffect(() => {
    parentSlot?._inputs["setProps"]?.({
      id: props.id,
      name: props.name,
      value: {
        visible: props.style.display !== "none",
      },
    });
  }, [props.style.display]);

  useEffect(() => {
    /* 设置值 */
    inputs["setValue"]((val, outputRels) => {
      const result = formatValue(val);
      data.value = result;
      outputRels["setValueComplete"]?.(result); // 表单容器调用 setValue 时，没有 outputRels
    });

    /* 获取值 */
    inputs["getValue"]((val, outputRels) => {
      outputRels["returnValue"](getValue());
    });

    /* 设置标题 */
    inputs["setLabel"]?.((val) => {
      if (!isString(val)) {
        return;
      }

      parentSlot?._inputs["setProps"]?.({
        id: props.id,
        name: props.name,
        value: {
          label: val,
        },
      });
    });

    /* 设置禁用 */
    inputs["setDisabled"]?.((val, outputRels) => {
      data.disabled = !!val;
      outputRels["setDisabledComplete"]?.(data.disabled);
    });
  }, [value]);

  function formatValue(val) {
    let result = val;

    switch (true) {
      case isEmpty(val): {
        result = 0;
        break;
      }
      case isString(val) || isNumber(val):
        result = isNaN(+val) ? 0 : +val;
        break;
      default:
        // 其他类型的值，直接返回
        return;
    }
    return result;
  }

  return (
    <View
      ref={knobRef}
      onMouseMove={onMouseMove}
      className={cls(css.wrapper, "mybricks-form-number-knob")}
      style={{
        height: size,
      }}
    >
      <View className={cls(css.center, "mybricks-form-number-knob-center")}>
        {data.openSlot
          ? slots["slot_center"]?.render({
              style: {
                width: "100%",
                height: "100%",
              },
            })
          : value}
      </View>

      <View
        className={cls(css.pointer, "mybricks-form-number-knob-pointer")}
        style={{
          top: `${data.pointerY}px`,
          transformOrigin: `center ${size / 2 - data.pointerY}px`,
          transform: `translateX(-50%) rotate(${angle}deg)`,
        }}
      />
    </View>
  );
}
