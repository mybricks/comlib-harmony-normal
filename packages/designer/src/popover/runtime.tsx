import React, { useEffect,useState, useMemo, useRef } from 'react';
import { View } from "@tarojs/components";
import css from './index.less';
import cx from "classnames";

export default function ({ env, data, slots, inputs, id, style }) {
  const [showCarrier, setShowCarrier] = useState(false);

  return (
    <View className={css.outer}>
      <View className={cx(css.popover, "mybricks-popover")} onClick={(e) => {
        setShowCarrier(!showCarrier);
      }
      }>
        {slots["content"].render({
          style: {
            ...data.layout,
          },
        })}
      </View>

      {showCarrier && <View className={cx(css.carrier, "mybricks-carrier")}>
        {slots["carrier"].render({
          style: {
            with:"100%",
            height:"100%"
          },
        })}
      </View>}


    </View>

  );
}
