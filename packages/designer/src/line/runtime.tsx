import React, { useMemo } from "react";
import css from "./runtime.less";
import cx from "classnames";

export default function ({ data }) {
  return <div className={cx([css.line, "mybricks-line"])}></div>;
}
