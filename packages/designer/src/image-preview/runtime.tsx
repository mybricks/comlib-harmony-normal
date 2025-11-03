import React, { useCallback, useEffect, useMemo, useState } from "react";
import { View, Image } from "@tarojs/components";
import { Swiper, SwiperItem } from "./../components/swiper";
import EmptyCom from "../components/empty-com";
import SkeletonImage from "./../components/skeleton-image";
import { isUndef } from "./../utils/core";
import css from "./style.less";

export default function ({ env, data, inputs, outputs, style }) {
  // 当前选中的tab
  const [current, setCurrent] = useState(data.current || 0);
  const [loadedImages, setLoadedImages] = useState([
    current,
    current + 1,
    data.items?.length ? data.items?.length - 1 : 0,
  ]); // 默认加载第一个和最后一个图片

  useEffect(() => {
    setCurrent(data.current);
  }, [data.current]);

  useMemo(() => {
    inputs["setItems"]((val) => {
      data.items = val;
    });
    inputs?.["activeIndex"]?.((index) => {
      if (!isNaN(parseFloat(index))) {
        data.current = index;
      }
    });
  }, []);

  const onClick = useCallback((index) => {
    outputs["onClick"]?.(index);
  }, []);

  const extra = useMemo(() => {
    if (env.edit) {
      return {
        autoplay: false,
        duration: 0,
      };
    }
    return {
      autoplay: !env.edit && !!data.autoplay,
      interval: data.interval || 5000,
      duration: data.duration ?? 500,
    };
  }, [env.edit, data.autoplay, data.duration]);

  const onChange = useCallback((e) => {
    data.current = e.detail?.current;
    outputs["onChange"]?.(e.detail?.current);
  }, []);

  useEffect(() => {
    setLoadedImages((c) => {
      const newLoadedImages = new Set(c);
      if (current + 1 < data.items.length) {
        newLoadedImages.add(current + 1); // 预加载后面一张图片
        return Array.from(newLoadedImages);
      }
      return c;
    });
  }, [current, data.items.length]);

  if (env.runtime && !data.items.length) {
    return null;
  }

  if (env.edit && !data.items.length) {
    return <EmptyCom title="请配置图片" />;
  }

  return (
    <Swiper
      env={env}
      data={data}
      className={css.swiper}
      style={{ height: style.height }}
      current={current}
      onChange={onChange}
      indicator={false}
      circular={env.edit ? false : data.circular}
      {...extra}
    >
      {data.items.map((item, index) => {
        // 搭建态下加载全部
        const shouldLoad = loadedImages.includes(index);
        const active = current === index;

        const offsetLeft = data.itemOffsets?.[0] ?? 0;
        const offsetRight = data.itemOffsets?.[1] ?? 0;

        let width = "100%";
        let left = `${(current - index) * 100}%`;
        switch (true) {
          case current === index: {
            width = `calc(100% - ${offsetRight + offsetLeft}px)`;
            left = `calc(0% + ${offsetLeft}px)`;
            break;
          }
          case current + 1 === index: {
            left = `calc(100% - ${offsetRight}px)`;
            break;
          }
          case current - 1 === index: {
            left = `calc(-100% + ${offsetLeft}px)`;
            break;
          }
        }
        return (
          <SwiperItem
            key={index}
            className={`${css.swiperItem} ${active ? css.active : ""}`}
            style={{
              left,
              width,
            }}
            onClick={() => {
              onClick(index);
            }}
            index={index}
          >
            <SkeletonImage
              useHtml={env.edit}
              className={css.thumbnail}
              mode="aspectFit"
              src={shouldLoad ? item.thumbnail : ""}
              nativeProps={{
                loading: "lazy",
                decoding: "async",
              }}
              cdnCut="auto"
              cdnCutOption={{ width: style.width, height: style.height }}
            />
          </SwiperItem>
        );
      })}
    </Swiper>
  );
}
