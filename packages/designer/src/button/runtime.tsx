import React, {
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from "react";
import css from "./style.less";
import cx from "classnames";
import { Button, Text } from "@tarojs/components";

export default function ({
  env,
  data,
  logger,
  slots,
  inputs,
  outputs,
  title,
}) {
  useMemo(() => {
    inputs["buttonText"]((val: string) => {
      data.text = val;
    });
  }, []);

  const disabled = useMemo(() => {
    if (data.disabled) {
      return {
        disabled: true,
      };
    } else {
      return {};
    }
  }, [data.disabled]);

  // input禁用按钮
  useEffect(() => {
    inputs["setDisabled"]?.((val, relOutputs) => {
      data.disabled = !!val;
      relOutputs["setDisabledSuccess"]?.(val);
    });
  }, []);

  // input启用按钮
  useEffect(() => {
    inputs["setEnabled"]?.((val, relOutputs) => {
      data.disabled = false;
      relOutputs["setEnabledSuccess"]?.(val);
    });
  }, []);

  return (
    <Button
      className={cx(
        css.button,
        data.disabled ? "mybricks-button-disable" : "mybricks-button"
      )}
      {...disabled}
    >
      <Text className={css.text}>{data.text}</Text>
    </Button>
  );
}
