import React, { useState, useCallback, useEffect, useRef } from "react";
import { View } from "@tarojs/components";
import { isObject, isString, isNumber, isEmpty } from "./../utils/type";
import useFormItemValue from "../utils/hooks/use-form-item-value";
import cls from "classnames";
import css from "./style.less";

export default function (props) {
  const { env, data, inputs, outputs, slots, parentSlot } = props;
  const [value, setValue, getValue] = useFormItemValue(data.value, (val) => {
    parentSlot?._inputs["onChange"]?.({
      id: props.id,
      name: props.name,
      value: Math.ceil(val),
    });

    outputs["onChange"](Math.ceil(val));
  });

  const knobRef = useRef<HTMLDivElement>(null);
  const [size, setSize] = useState(375);
  const angle = useRef(0);
  const [realAngle, setRealAngle] = useState(0); // 为了视图重新渲染
  const startAngle = useRef(0);
  const actioning = useRef(false);

  const calcAngle = (clientX: number, clientY: number) => {
    const rect = knobRef.current!.getBoundingClientRect();
    const x = clientX - (rect.left + size / 2);
    const y = clientY - (rect.top + size / 2);
    return (Math.atan2(y, x) * 180) / Math.PI + 90;
  };

  const onMouseDown = (e: React.MouseEvent) => {
    if (data.disabled || env.edit) {
      return;
    }
    if (e.buttons === 1) {
      actioning.current = true;
      startAngle.current = calcAngle(e.clientX, e.clientY);
      outputs["onPress"](true);
    }
  };
  const onMouseMove = (e: React.MouseEvent) => {
    if (data.disabled || env.edit) {
      return;
    }
    if (e.buttons === 1) {
      const current = calcAngle(e.clientX, e.clientY);

      let delta = current - startAngle.current;
      // 处理跨越 -180 / 180 的角度跳变
      if (delta > 180) delta -= 360;
      if (delta < -180) delta += 360;

      angle.current += delta;
      setRealAngle(angle.current);
      startAngle.current = current;
      const deltaVal = (delta / 360) * data.lapValue;
      setValue(Math.min(Math.max(deltaVal + getValue(), data.min), data.max));

      if (Math.ceil(getValue()) !== data.value) {
        data.value = Math.ceil(getValue());
      }
    }
  };
  const onMouseUp = () => {
    if (data.disabled || env.edit) {
      return;
    }
    actioning.current = false;
    outputs["onPress"](false);
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
    if (!actioning.current) {
      const result = formatValue(data.value);
      setValue(result);
    }
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
      onMouseDown={onMouseDown}
      onMouseMove={onMouseMove}
      onMouseUp={onMouseUp}
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
          : Math.ceil(value)}
      </View>
      <View
        className={cls(css.pointer, "mybricks-form-number-knob-pointer")}
        style={{
          top: `${data.pointerY}px`,
          transformOrigin: `center ${size / 2 - data.pointerY}px`,
          transform: `translateX(-50%) rotate(${realAngle}deg)`,
        }}
      />
    </View>
  );
}
