import React, { useState, useCallback, useMemo, useEffect } from "react";
import cx from "classnames";
import { isObject, isString, isNumber, isEmpty } from "./../utils/core/type";
import { Rate } from "brickd-mobile";
import { useFormItemValue } from "../utils/hooks";

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
    if (result !== false) {
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
    inputs["setValue"]((val, outputRels) => {
      const result = formatValue(val);
      if (result !== false) {
        setValue(result);
        outputRels["setValueComplete"]?.(result); // 表单容器调用 setValue 时，没有 outputRels
      }
    });

    inputs["getValue"]((val, outputRels) => {
      outputRels["returnValue"](getValue());
    });

    inputs["setDisabled"]((val) => {
      data.disabled = !!val;
    });
  }, []);

  const onChange = useCallback((value) => {
    setValue(value);
    parentSlot?._inputs["onChange"]?.({
      id: props.id,
      name: props.name,
      value,
    });
    outputs["onChange"](value);
  }, []);

  function formatValue(val) {
    let result = val;

    switch (true) {
      case isEmpty(val): {
        result = "";
        break;
      }
      case isString(val) || isNumber(val):
        result = val;
        break;
      case isObject(val):
        val = val[data.name];
        break;
      default:
        val = false;
        break;
    }

    return result;
  }

  return (
    <Rate
      value={value}
      onChange={onChange}
      count={data.count}
      allowHalf={data.allowHalf}
      disabled={data.disabled}
    />
  );
}
