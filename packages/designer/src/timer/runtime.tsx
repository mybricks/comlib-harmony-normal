import React, {
  useCallback,
  useEffect,
  useRef,
  useMemo,
  useState,
} from "react";
import { View } from "@tarojs/components";
import css from "./style.less";
import cls from "classnames";

function formatTime(input) {
  // 如果 input 是数字，则将其视为时间戳并转换为 Date 对象
  const date = typeof input === 'number' ? new Date(input) : input;

  const hours = String(date.getHours()).padStart(2, '0');
  const minutes = String(date.getMinutes()).padStart(2, '0');
  const seconds = String(date.getSeconds()).padStart(2, '0');

  return `${hours}:${minutes}:${seconds}`;
}

function formatTimeDiff(timeDiff) {
  const hours = String(Math.floor(timeDiff / (1000 * 60 * 60))).padStart(2, '0');
  const minutes = String(Math.floor((timeDiff % (1000 * 60 * 60)) / (1000 * 60))).padStart(2, '0');
  const seconds = String(Math.floor((timeDiff % (1000 * 60)) / 1000)).padStart(2, '0');

  return `${hours}:${minutes}:${seconds}`;
}

function timeStringToTimestamp(timeString) {
  // 分割时间字符串 "01:00:05" 为 ["01", "00", "05"]
  const timeParts = timeString.split(":");

  // 解析小时、分钟和秒
  const hours = parseInt(timeParts[0], 10);
  const minutes = parseInt(timeParts[1], 10);
  const seconds = parseInt(timeParts[2], 10);

  // 计算总秒数
  const totalSeconds = (hours * 3600) + (minutes * 60) + seconds;

  return totalSeconds * 1000;
}

export default function ({ env, data, inputs, outputs, title, style }) {
  const [showTime, setShowTime] = useState("--:--:--");
  const [countDown, setCountDown] = useState(data.countdown);

  const timerIdRef = useRef(null);
  const initTimeRef = useRef(null);
  const elapsedTimeRef = useRef(0); // 记录已经过去的时间
  const finishedRef = useRef(true);

  //更新当前时间
  const updateCurrentTime = () => {
    const currentTime = new Date();
    setShowTime(formatTime(currentTime));
    outputs.currentTime?.(currentTime.getTime());
  };

  //计时器
  const updateTimer = () => {
    elapsedTimeRef.current += 1000; // 每秒增加1000毫秒
    setShowTime(formatTimeDiff(elapsedTimeRef.current));
    outputs.currentTime?.(elapsedTimeRef.current);
  }

  //倒计时
  const updateCountDown = useCallback(() => {
    const countDownStamp = timeStringToTimestamp(countDown);
    elapsedTimeRef.current += 1000; // 每秒增加1000毫秒
    const remainingTime = countDownStamp - elapsedTimeRef.current;

    if (remainingTime >= 0) {
      setShowTime(formatTimeDiff(remainingTime));
      outputs.currentTime?.(remainingTime);
    } else {
      clearInterval(timerIdRef.current);
      outputs.finishCountDown?.(countDownStamp);
    }
  }, [countDown])

  useMemo(() => {
    inputs["countDownTimeStamp"]?.((ds) => {
      setCountDown(ds);
    })

    inputs["start"]?.(() => {
      if (finishedRef.current) {
        elapsedTimeRef.current = 0;
        finishedRef.current = false;
      }

      if (data.clockType === "timer") {
        updateTimer();
        timerIdRef.current = setInterval(updateTimer, 1000);
      } else if (data.clockType === "countdown") {
        updateCountDown();
        timerIdRef.current = setInterval(updateCountDown, 1000);
      }
    })

    inputs["pause"]?.(() => {
      if (timerIdRef.current) {
        clearInterval(timerIdRef.current);
      }
    })

    inputs["finish"]?.(() => {
      if (timerIdRef.current) {
        clearInterval(timerIdRef.current);
        finishedRef.current = true;
        elapsedTimeRef.current = 0;
      }
    })

  }, [updateTimer, updateCountDown])

  useEffect(() => {
    if (!env.runtime) return;

    // 清除之前的定时器
    if (timerIdRef.current) {
      clearInterval(timerIdRef.current);
    }

    let newTimerId;
    switch (data.clockType) {
      case "realtime":
        updateCurrentTime();
        newTimerId = setInterval(updateCurrentTime, 1000);
        break;

      case "timer":
        if (data.startImmediately !== false) {
          initTimeRef.current = new Date();
          updateTimer();
          newTimerId = setInterval(updateTimer, 1000);
        }
        break;

      case "countdown":
        if (data.startImmediately !== false) {
          initTimeRef.current = new Date();
          updateCountDown();
          newTimerId = setInterval(updateCountDown, 1000);
        }
        break;
    }
    timerIdRef.current = newTimerId; 

    // 清理函数，在组件卸载时清除定时器
    return () => {
      clearInterval(newTimerId);
    };
  }, [data.clockType, env.runtime, data.startImmediately, countDown]);

  return (
    <View
      className={cls(css.timer, "mybricks_timer")}
    >
      <View className={cls(css.timeUnit, "mybricks_timer_unit", "mybricks_timer_unit_background")}>
        {showTime.substring(0, 2)}
      </View>

      <View className={cls(css.separator, "mybricks_timer_separator","mybricks_timer_separator_background")}>:</View>

      <View className={cls(css.timeUnit, "mybricks_timer_unit", "mybricks_timer_unit_background")}>
        {showTime.substring(3, 5)}
      </View>

      <View className={cls(css.separator, "mybricks_timer_separator","mybricks_timer_separator_background")}>:</View>

      <View className={cls(css.timeUnit, "mybricks_timer_unit", "mybricks_timer_unit_background")}>
        {showTime.substring(6, 8)}
      </View>
    </View>
  );
}
