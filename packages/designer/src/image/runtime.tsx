import React, {
  useCallback,
  useEffect,
  useRef,
  useMemo,
  useState,
} from "react";
import css from "./style.less";
import cx from "classnames";
import { View, Image } from "@tarojs/components";
import SkeletonImage from "./../components/skeleton-image";
import { useRedirectedImageUrl } from "./../utils/hooks/use-image-url";
import * as Taro from "@tarojs/taro";

const imageUrl =
  "data:image/png;base64,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";

export default function ({ env, data, inputs, outputs, title, style }) {
  const ele = useRef(null);
  const [h5PolyfillClass, setH5PolyfillClass] = useState(
    css["h5-polyfill-aspectfill-width"]
  );

  useEffect(() => {
    if (data.mode !== "aspectFill") {
      return;
    }
    if (!ele.current && !ele.current.getBoundingClientRect) {
      return;
    }
    const { width, height } = ele.current.getBoundingClientRect?.() ?? {};
    setH5PolyfillClass(
      width > height
        ? css["h5-polyfill-aspectfill-width"]
        : css["h5-polyfill-aspectfill-height"]
    );
  }, [style.width, style.height, data.mode]);

  useMemo(() => {
    inputs["setSrc"]((src) => {
      data.src = src;
    });
  }, []);

  useRedirectedImageUrl(env?.edit ? data.src : undefined, (redirectedUrl) => {
    data.src = redirectedUrl;
  });

  const onLoad = useCallback((e) => {
    if (!env.runtime) {
      return;
    }
    outputs["onLoad"](data.src);
  }, []);

  const onClick = useCallback(
    (e) => {
      if (!env.runtime) {
        return;
      }

      if (data.clickType === "previewImage") {
        Taro.previewImage({
          urls: [data.src],
          current: data.src,
        });
        e.stopPropagation();
        return;
      }
      // 当配置了单击事件，阻止事件冒泡
      if (outputs["onClick"].getConnections().length) {
        e.stopPropagation();
      }
      outputs["onClick"](data.src);
    },
    [data.clickType, data.src, data.stopPropagation]
  );

  const onError = useCallback(() => {
    if (!env.runtime) {
      return;
    }
    outputs["onError"](data.src);
  }, []);

  const onPress = useCallback((press) => {
    if (!env.runtime) {
      return;
    }
    outputs["onPress"](press);
  }, []);

  function isValidUrl(url) {
  const urlRegex = /^https?:\/\/.+\..+/;
  return urlRegex.test(url);
}

  const src = useMemo(() => {
    let src = data.svgPolyfill || data.src;
    //debug的时候，如果没有图片内容，展示空MyBricks空图片占位
    if (env.runtime.debug && data.src == "") {
      return imageUrl;
    } else if (env.edit && data.src == "") {
      //搭建的时候，如果没有图片内容，展示空MyBricks空图片占位
      return imageUrl;
    } else {
      if (isValidUrl(src)) {
        return src;
      }else{
        return imageUrl;
      }
    }
  }, [data.svgPolyfill, data.src, imageUrl, env.runtime.debug, env.edit]);

  const svgProps = useMemo(() => {
    if (data.svgPolyfill) {
      return {
        svg: true,
        mode: "aspectFit",
      };
    } else {
      return {};
    }
  }, [data.svgPolyfill]);

  return (
    <View className={css.com} ref={ele}>
      <SkeletonImage
        useHtml={env.edit}
        skeleton={env.edit ? false : !!data?.loadSmooth}
        className={cx(css.image, h5PolyfillClass, "mybricks-image")}
        src={src}
        mode={data.mode}
        onClick={onClick}
        onLoad={onLoad}
        onError={onError}
        onPress={onPress}
        showMenuByLongpress={data.showMenuByLongpress ?? false}
        cdnCut="auto"
        cdnCutOption={{ width: style.width, height: style.height }}
        {...svgProps}
      />
    </View>
  );
}
