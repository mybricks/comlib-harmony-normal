import * as React from "react";

const DynamicEditors = ({ data, keyName, onSwitch }) => {
  return (
    <div style={{ position: "relative", marginTop: -15 }}>
      {data[keyName] ? (
        <div>
          <div>关闭动态数据源</div>
          <button
            onClick={() => {
              data[keyName] = false;
              onSwitch?.(data[keyName]);
            }}
          >
            关闭
          </button>
        </div>
      ) : (
        <div>
          <div>开启动态数据源</div>
          <button
            onClick={() => {
              data[keyName] = true;
              onSwitch?.(data[keyName]);
            }}
          >
            开启
          </button>
        </div>
      )}
    </div>
  );
};

export class DynamicArrayData {
  keyName: string;

  constructor({ keyName }) {
    this.keyName = keyName;
  }

  init = () => {};

  editors = ({ data }, { title = "", array, effects }) => {
    const keyName = this.keyName;

    const modeKeyName = `${keyName}_dynamic`;

    const onSwitch = (value) => {
      if (value) {
        effects?.onSwitchToDynamic?.(data[keyName])
      } else {
        effects?.onSwitchToStatic?.(data[keyName])
      }
    };

    return {
      title,
      items: [
        {
          title: "",
          type: "editorRender",
          options: {
            render: () => {
              return (
                <div style={{ marginTop: -10 }}></div>
              );
            },
          },
        },
        {
          type: "array",
          ifVisible({ data }) {
            return !!!data[modeKeyName];
          },
          options: array.options,
          value: {
            get({ data }) {
              return data[keyName];
            },
            set(context, value) {
              const { data } = context;
              let actions = computedActions({
                before: data[keyName],
                after: value,
              });

              actions.forEach(action => {
                switch (action?.name) {
                  case "remove":
                    effects.onRemove?.(context, action);
                    break;
                  case "add":
                    effects.onAdd?.(context, action);
                    break;
                  case "update":
                    effects.onUpdate?.(context, action);
                    break;
                }
              });

              data[keyName] = value;
            },
          },
        },
        // {
        //   title: "",
        //   type: "editorRender",
        //   options: {
        //     render: () => {
        //       return (
        //         <DynamicEditors
        //           data={data}
        //           keyName={modeKeyName}
        //           onSwitch={onSwitch}
        //         />
        //       );
        //     },
        //   },
        // },
      ],
    };
  };
}

function computedActions(params) {
  let before = params.before || [];
  let after = params.after || [];
  let actions: any = [];
  
  // 创建 id 到 item 的映射对象
  let beforeMap = {};
  let afterMap = {};
  
  // 构建 before 映射
  before.forEach(function(item) {
    beforeMap[item._id] = item;
  });
  
  // 构建 after 映射
  after.forEach(function(item) {
    afterMap[item._id] = item;
  });
  
  // 处理删除的项
  for (let id in beforeMap) {
    if (beforeMap.hasOwnProperty(id)) {
      if (!afterMap[id]) {
        actions.push({
          name: "remove",
          value: beforeMap[id]
        });
      }
    }
  }
  
  // 处理新增的项
  for (let id in afterMap) {
    if (afterMap.hasOwnProperty(id)) {
      if (!beforeMap[id]) {
        actions.push({
          name: "add",
          value: afterMap[id]
        });
      }
    }
  }
  
  // 处理更新的项
  for (let id in afterMap) {
    if (afterMap.hasOwnProperty(id)) {
      if (beforeMap[id] && JSON.stringify(beforeMap[id]) !== JSON.stringify(afterMap[id])) {
        actions.push({
          name: "update",
          value: afterMap[id]
        });
      }
    }
  }
  
  return actions;
}


function computedAction({ before = [], after = [] }) {
  let beforeIds = before.map((item) => item._id);
  let afterIds = after.map((item) => item._id);

  switch (true) {
    case before.length > after.length: {
      let diffId = beforeIds.filter((x) => !afterIds.includes(x))[0];
      let diffItem = before.filter((x) => diffId.includes(x._id))[0];
      return {
        name: "remove",
        value: diffItem,
      };
    }
    case before.length < after.length: {
      let diffId = afterIds.filter((x) => !beforeIds.includes(x))[0];
      let diffItem = after.filter((x) => diffId.includes(x._id))[0];
      return {
        name: "add",
        value: diffItem,
      };
    }

    case before.length === after.length: {
      let diffItem = null;

      for (let i = 0; i < before.length; i++) {
        if (JSON.stringify(before[i]) !== JSON.stringify(after[i])) {
          diffItem = after[i];
          break;
        }
      }

      return {
        name: "update",
        value: diffItem,
      };
    }
  }
}
