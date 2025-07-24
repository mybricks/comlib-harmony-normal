import React, {
  useCallback,
  useEffect,
  useMemo,
  useState,
  useRef,
} from "react";
import { View, Text } from "@tarojs/components";
import cx from "classnames";
import css from "./style.less";

export default function ({ id, env, data, style, inputs, outputs }) {
  const [ready, setReady] = useState(false);
  const textRef = useRef<HTMLDivElement>(null);
  const [displayState, setDisplayState] = useState(data.displayState);


  const displaySkeleton = useMemo(() => {
    if (displayState === "skeleton" && !ready && env.runtime) {
      return true;
    }
    return false;
  }, [displayState, env.runtime, ready]);

  useMemo(() => {
    inputs["value"]((val) => {
      data.text = val;
      setReady(true);
    });

    inputs["getValue"]?.((val, outputRels) => {
      if (!ready && displayState === "hidden" && displayState === "skeleton") {
        outputRels["onGetValue"]("");
      } else {
        outputRels["onGetValue"](data.text);
      }
    });
  }, [ready]);

  const textCx = useMemo(() => {
    return cx({
      [css.text]: true,
      ["mybricks-text"]: true,
      [id]: true,
    });
  }, [id, data.ellipsis]);

  const ellipsisCx = useMemo(() => {
    return cx({
      [css["ellipsis-line"]]: !!data.ellipsis,
    });
  }, [data.ellipsis]);

  const SkeletonCx = useMemo(() => {
    return cx({
      [css.skeleton]: displaySkeleton,
    });
  }, [displaySkeleton]);

  const textStyle = useMemo(() => {
    //隐藏文本但是保留占位，撑开骨骼图
    let common: any = {};
    if (displayState === "skeleton" && !ready && env.runtime) {
      common = {
        visibility: "hidden",
      };
    }
    if (displayState === "skeleton" && ready && env.runtime) {
      common = {
        visibility: "visible",
      };
    }
    if (data.ellipsis) {
      return { ...common, WebkitLineClamp: data.maxLines };
    } else {
      return { ...common };
    }
  }, [data.ellipsis, data.maxLines, ready, displayState]);

  const verticalStyle = useMemo(() => {
    if (data?.direction == "horizonal") {
      return {

      }
    } else if (data?.direction == "vertical") {
      return {
        writingMode: 'vertical-rl',
        WebkitWritingMode: 'vertical-rl',
        textOrientation: 'upright',
        WebkitTextOrientation: 'upright',
      }
    } else {
      return {

      }
    }
  }, [data?.direction])

  const onClick = useCallback((e) => {
    if (!env.runtime) {
      return;
    }
    // 当配置了单击事件，阻止事件冒泡
    if (outputs["onClick"].getConnections().length) {
      e.stopPropagation();
    }

    outputs["onClick"](data.text);
  }, []);

  const text = useMemo(() => {
    let text = data.text ?? "";

    if (typeof text === "object") {
      return JSON.stringify(text);
    }

    return text;
  }, [data.text]);

  //
  const display = useMemo(() => {
    if (displayState === "hidden" && !ready && env.runtime) {
      return false;
    }
    return true;
  }, [displayState, env.runtime, ready]);

  return (
    <View>
      {display ? (
        <View
          className={textCx}
          onClick={onClick}
        >
          <View className={SkeletonCx}>
            <View ref={textRef} className={ellipsisCx} style={{...textStyle,...verticalStyle}}>
              {text}
            </View>
          </View>
        </View>
      ) : null}
    </View>
  );
}
