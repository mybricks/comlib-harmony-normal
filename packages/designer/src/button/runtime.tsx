import React, {
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from "react";
import css from "./style.less";
import cx from "classnames";
import { Button, Text, Image, View } from "@tarojs/components";
import { SymbolGlyph } from "./../components/symbol-glyph";

export default function ({ env, data, logger, slots, inputs, outputs, title }) {
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

  const iconDom = useMemo(() => {
    const spaceStyle = {
      marginLeft: data.iconPosition === "right" ? data.iconMargin : 0,
      marginRight:
        data.iconPosition === "left" || !data.iconPosition
          ? data.iconMargin
          : 0,
    };
    if (!data.showIcon) {
      return null;
    }
    if (data.useImageIcon) {
      return (
        <Image
          style={{
            ...spaceStyle,
            width: `${data.imageSize?.[0] ?? 14}px`,
            height: `${data.imageSize?.[1] ?? 14}px`,
          }}
          mode="scaleToFill"
          src={data.imageIcon}
        />
      );
    } else {
      return (
        <View
          style={{
            ...spaceStyle,
          }}
        >
          <SymbolGlyph
            name={data.icon}
            fontColor={data.iconColor}
            fontSize={data.iconSize}
          />
        </View>
      );
    }
  }, [
    data.showIcon,
    data.useImageIcon,
    data.imageIcon,
    data.icon,
    data.iconSize,
    data.iconMargin,
    data.iconColor,
    data.iconPosition,
    data.imageSize,
  ]);

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
      onClick={(e) => {
        if (env.runtime && !data.disabled) {
          if (outputs["onClick"].getConnections().length) {
            e.stopPropagation();
          }
          outputs["onClick"](data.text);
        }
      }}
    >
      {(!data.iconPosition || data.iconPosition === "left") && iconDom}
      <Text>{data.text}</Text>
      {data.iconPosition === "right" && iconDom}
    </Button>
  );
}
