import React, { useState, useCallback, useEffect, useMemo } from "react";
import { isNumber, isObject, isString, isEmpty } from "../utils/type";
import { useFormItemValue } from "../utils/hooks";
import { Input, Image } from "brickd-mobile";
import { View } from "@tarojs/components";
import css from "./style.less";
import { isH5 } from "../utils/env";
import cx from "classnames";
import { clearable } from "./constant";

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
      setValue(result);
      outputRels["setValueComplete"]?.(result); // 表单容器调用 setValue 时，没有 outputRels
    });

    /* 获取值 */
    inputs["getValue"]((val, outputRels) => {
      outputRels["returnValue"](getValue());
    });

    /* 重置值 */
    inputs["resetValue"]((val, outputRels) => {
      setValue("");
      outputRels["resetValueComplete"]?.("");
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

    /* 设置提示内容 */
    inputs["setPlaceholder"]((val) => {
      data.placeholder = val;
    });

    /* 设置禁用 */
    inputs["setDisabled"]?.((val, outputRels) => {
      data.disabled = !!val;
      outputRels["setDisabledComplete"]?.(data.disabled);
    });
  }, []);

  const onChange = useCallback((e) => {
    let value = e.detail.value;
    switch (data.type) {
      // 【身份证号】只允许输入数字
      case "idcard":
        value = value.replace(/[^\d]/g, "");
        break;

      // 【手机号】只允许输入数字、+、-、空格
      case "phone":
        value = value.replace(/[^\d+-\s]/g, "");
        // 不允许多个 +
        if ((value.match(/\+/g) || []).length > 1) {
          // 保留第一个 +
          const first = value.indexOf("+");
          value = "+" + value.slice(first + 1).replace(/\+/g, "");
        }
        // + 号只能在最前面
        if (value.indexOf("+") > 0) {
          value = value.replace(/\+/g, ""); // 删除中间的 +
        }
        // 连字符 - 不能在最前或在空格或 + 之后
        value = value.replace(/(^-|(?<=\+)-|(?<=\s)-)/g, "");
        break;

      // 【数字(支持小数)】只允许输入正确的数字，包括整数、小数、负数
      case "number_decimal":
        value = value.replace(/[^\d.-]/g, "");
        if (value.startsWith("-")) {
          value = "-" + value.slice(1).replace(/\-/g, "");
        } else {
          value = value.replace(/\-/g, "");
        }
        const parts = value.split(".");
        if (parts.length > 1) {
          value = parts.shift() + "." + parts.join("");
        }
        break;
    }
    setValue(value);
    outputs?.["onChange"](value);
  }, []);

  const onBlur = useCallback((e) => {
    let value = e.detail.value;
    outputs?.["onBlur"](value);
  }, []);

  const onConfirm = useCallback((e) => {
    let value = e.detail.value;
    outputs?.["onConfirm"](value);
  }, []);

  const $showCount = useMemo(() => {
    if (data.showCount) {
      return (
        <View className={css.showCount}>
          {data.maxlength == -1
            ? value.length
            : `${value.length}/${data.maxlength}`}
        </View>
      );
    } else {
      return null;
    }
  }, [data.maxlength, data.showCount, value]);

  const $clearIcon = useMemo(() => {
    if (data.clearable && value.length > 0) {
      return (
        <View
          style={{ width: 18, height: 18 }}
          onClick={() => {
            setValue("");
          }}
        >
          <Image src={clearable}></Image>
        </View>
      );
    } else {
      return null;
    }
  }, [data.clearable, value.length]);

  function formatValue(val) {
    let result = val;

    switch (true) {
      case isEmpty(val): {
        result = "";
        break;
      }
      case isString(val) || isNumber(val): {
        result = `${val}`;
        break;
      }
      default:
        // 其他类型的值，直接返回
        return;
    }
    return result;
  }

  return (
    <View
      className={cx({
        [css.formItem]: true,
        "mybricks-formItem": true,
      })}
    >
      <Input
        className={cx({
          [css.input]: true,
          "mybricks-input": !isH5(),
          "mybricks-h5Input": isH5(),
        })}
        value={value}
        type={data.type}
        placeholder={data.placeholder}
        align={data.inputAlign}
        onChange={onChange}
        disabled={data.disabled}
        cursorSpacing={28}
        cursor={value.length}
        onBlur={onBlur}
        maxlength={data.maxlength}
        confirmType={"done"}
        onConfirm={onConfirm}
      />
      {$showCount}
      {$clearIcon}
    </View>
  );
}
