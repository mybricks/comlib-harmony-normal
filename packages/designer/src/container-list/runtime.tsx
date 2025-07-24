import React, {
  useCallback,
  useEffect,
  useMemo,
  useRef,
  useState,
} from "react";
import { View } from "@tarojs/components";
import css from "./style.less";
import { uuid, debounce, throttle } from "../utils";
import { List, Loading } from "brickd-mobile";
import { Direction } from "./constant";
import cx from "classnames";

const rowKey = "_itemKey";

const mockData: DsItem[] = [
  { [rowKey]: 1, index: 1 },
  { [rowKey]: 2, index: 2 },
  { [rowKey]: 3, index: 3 },
] as DsItem[];

interface DsItem {
  item: any;
  [rowKey]: string | number;
  index: number;
}

enum ListStatus {
  IDLE = "idle",
  LOADING = "loading",
  ERROR = "error",
  NOMORE = "noMore",
  EMPTY = "empty",
}

const ContainerList = ({ env, data, inputs, outputs, slots }) => {
  const [dataSource, setDataSource] = useState<DsItem[]>(
    env.edit || env?.runtime?.debug?.prototype ? mockData : []
  );
  const [status, setStatus] = useState<ListStatus>(ListStatus.IDLE);
  const statusRef = useRef<ListStatus>(false as any);

  //默认是否显示加载中
  useEffect(() => {
    if (data.defaultActive == "loading" && !env.edit) {
      setStatus(ListStatus.LOADING);
      statusRef.current = ListStatus.LOADING;
    }
  }, [data.defaultActive]);

  useMemo(() => {
    /** inputs loading 必须在设置数据源之前，否则时序上会导致有可能设置数据源比loading快的情况，会导致onScrollLoad无法触发 */
    inputs["loading"]?.((bool) => {
      setStatus(ListStatus.LOADING);
      statusRef.current = ListStatus.LOADING;
    });

    inputs["noMore"]?.((bool) => {
      setStatus(ListStatus.NOMORE);
      statusRef.current = ListStatus.NOMORE;
    });

    inputs["error"]?.((bool) => {
      setStatus(ListStatus.ERROR);
      statusRef.current = ListStatus.ERROR;
    });

    inputs["empty"]?.((bool) => {
      setStatus(ListStatus.EMPTY);
      statusRef.current = ListStatus.EMPTY;
    });

    inputs["addDataSource"]((val) => {
      if (Array.isArray(val)) {
        const ds = val.map((item, index) => ({
          item,
          [rowKey]: data.rowKey === "" ? uuid() : item[data.rowKey] || uuid(),
          index: index,
        }));
        setDataSource((c) => c.concat(ds));
        setTimeout(() => {
          setStatus(ListStatus.IDLE);
          statusRef.current = ListStatus.IDLE;
        }, 0);
      }
    });

    inputs["refreshDataSource"]((val) => {
      if (Array.isArray(val)) {
        const ds = val.map((item, index) => ({
          item,
          [rowKey]: data.rowKey === "" ? uuid() : item[data.rowKey] || uuid(),
          index: index,
        }));
        //覆盖数据前先清空，放置输入重复内容时，列表项不会触发
        setDataSource([]);
        setTimeout(() => {
          setDataSource(ds);
        }, 0);
        if (data.autoEmptyCondition && val.length === 0) {
          setStatus(ListStatus.EMPTY);
          statusRef.current = ListStatus.EMPTY;
        } else {
          setStatus(ListStatus.IDLE);
          statusRef.current = ListStatus.IDLE;
        }
      }
    });
  }, []);

  useEffect(() => {
    /* 获取值 */
    inputs["getDataSource"]?.((val, outputRels) => {
      outputRels["getDataSourceSuccess"](
        dataSource.map((item, index) => ({ ...item.item }))
      );
    });
  }, [dataSource]);

  const empty = useMemo(() => {
    return ListStatus.EMPTY === status;
  }, [status]);

  const hasMore = useMemo(() => {
    return ListStatus.NOMORE !== status;
  }, [status]);

  const loading = useMemo(() => {
    return ListStatus.LOADING === status;
  }, [status]);

  const error = useMemo(() => {
    return ListStatus.ERROR === status;
  }, [status]);

  const wrapperCls = useMemo(() => {
    if (data.direction === Direction.Row) {
      //显示加载中和错误的时候，居中对齐
      if (loading || error) {
        return `${css.list} ${css.row} ${css.scroll_x} ${css.justify_content_center} `;
      } else if (data.wrap) {
        return `${css.list} ${css.row} ${css.scroll_x} ${css.flex_wrap}`;
      } else {
        return `${css.list} ${css.row} ${css.scroll_x}`;
      }
    }

    return data.scrollRefresh
      ? `${css.list} ${css.scroll}`
      : `${css.list} ${css.normal}`;
  }, [data.scrollRefresh, data.direction, loading, error, data.wrap]);

  const $list = dataSource.map(
    ({ [rowKey]: key, index: index, item: item }, _idx) => {
      const isLastItem = _idx === dataSource.length - 1;
      return (
        <View
          className={cx({
            [css.item]: true,
            ["disabled-area"]: env.edit && _idx > 0,
            [css.item]: !env.edit || _idx === 0,
          })}
          key={key}
          //如果是最后一项，则不加margin
          style={{
            [data.direction === Direction.Row ? "marginRight" : "marginBottom"]:
              isLastItem ? `0px` : `${data.spacing}px`,
          }}
        >
          {/* 当前项数据和索引 */}
          {slots["item"].render({
            inputValues: {
              itemData: item,
              index: index,
            },
            key: key,
            style: {
              width:
                slots["item"].size || data.direction === Direction.Column
                  ? ""
                  : "72px",
              height: slots["item"].size ? "unset" : "60px",
            },
          })}
        </View>
      );
    }
  );

  return (
    <View className={css.listWrapper}>
      <View
        className={wrapperCls}
      >
        <>
          {!!data?.scrollRefresh ? (
            <>
              {!empty && $list}
              {status !== ListStatus.IDLE && (
                <List.Placeholder>
                  {loading && <Loading>{data.loadingTip ?? "..."}</Loading>}
                  {error && (data.errorTip ?? "加载失败，请重试")}
                  {!hasMore && (data.emptyTip ?? "没有更多了")}
                  {empty && data.showEmptySlot ? (
                    <View>
                      {" "}
                      {slots["emptySlot"].render({
                        style: {
                          minHeight: 130,
                          minWidth: 200,
                        },
                      })}
                    </View>
                  ) : (
                    empty && data.initialEmptyTip
                  )}
                </List.Placeholder>
              )}
            </>
          ) : (
            <>
              {status !== ListStatus.IDLE ? (
                <List.Placeholder>
                  {loading && <Loading>{data.loadingTip ?? "..."}</Loading>}
                  {error && (data.errorTip ?? "加载失败，请重试")}
                  {empty && data.showEmptySlot ? (
                    <View className={css.empty_slot}>
                      {" "}
                      {slots["emptySlot"].render({
                        style: {
                          minHeight: 130,
                          minWidth: 200,
                        },
                      })}
                    </View>
                  ) : (
                    empty && data.initialEmptyTip
                  )}
                </List.Placeholder>
              ) : (
                $list
              )}
            </>
          )}
        </>
      </View>
    </View>
  );
};

export default ContainerList;
