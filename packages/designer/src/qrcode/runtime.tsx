import React, { useCallback, useEffect, useMemo, useState } from "react";
import { View, Image } from "@tarojs/components";
import { QRCode } from "taro-code";
import { isString } from "./../utils/core";
import css from "./style.less";
import cx from "classnames";

export default function ({ env, data, inputs, outputs, title, style }) {
  useMemo(() => {
    inputs["setValue"]?.((val) => {
      if (isString(val)) {
        data.text = val;
      }
    });
  }, []);

  return (
    <View className={cx(css.code, "mybricks-code")}>
      {data.mode === "qrcode" && (
        <QRCode
          style={{ display: "block", width: "100%", height: "100%" }}
          mode={"widthFix"}
          text={data.text}
        ></QRCode>
      )}
    </View>
  );
}
