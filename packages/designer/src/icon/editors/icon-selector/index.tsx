import React, { useCallback, useEffect, useMemo, useState } from "react";
import css from "./index.less";
import { basicIcons, filledIcons, outlinedIcons } from "./icons";
import { HarmonyIcons, SymbolGlyph } from './../../../components/symbol-glyph'

const { Drawer, Radio } = window.antd ?? {}

const Icon = (props: any) => {
  const { type, size, className } = props;
  return <></>

  // @ts-ignore
  // const RenderIcon = Icons[type];

  // if (!RenderIcon) return <></>;

  // return <RenderIcon className={className} size={size || 24} />;
};

export default function ({ value }) {
  const [visible, setVisible] = useState(false);
  const [iconSet, setIconSet] = useState("basic");

  const _setValue = useCallback(
    (icon) => {
      setVisible(false);
      value.set(icon);
    },
    [value]
  );

  const toggle = useCallback(() => {
    setVisible(!visible);
  }, [visible]);

  const renderIcons = useCallback((icons) => {
    return (
      <div className={css["icon-list"]}>
        {Object.keys(icons ?? {}).map((iconName) => {
          return (
            <div
              className={css["icon-item"]}
              onClick={() => {
                _setValue(iconName);
              }}
              key={iconName}
            >
              <SymbolGlyph name={iconName} fontSize={24} />
            </div>
          );
        })}
      </div>
    );
  }, [])

  useEffect(() => {
    setIconSet(HarmonyIcons[0]?.title)
  }, [])

  return (
    <div className={css["editor-icon"]}>
      <button className={css["editor-icon__button"]} onClick={toggle}>
        <div style={{display:"flex",justifyContent:"center",alignItems:"center",width:"100%",height:"100%"}}>
        <SymbolGlyph name={value.get()}  fontSize={15} />
        <div style={{marginLeft:5}}>{`${visible ? "关闭" : "打开"}`}图标选择器</div>
        </div>
      </button>

      <Drawer
        className={`${css.iconBody} fangzhou-theme`}
        bodyStyle={{
          padding: 0,
          borderLeft: "1px solid #bbb",
          backgroundColor: "#F7F7F7",
          overflow: "auto",
        }}
        placement="right"
        mask={false}
        closable={false}
        destroyOnClose={true}
        visible={visible}
        onClose={close}
        width={390}
        getContainer={() => document.querySelector('div[class^="lyStage-"]')}
        style={{ position: "absolute" }}
      >
        <div className={css.sticky}>
          <div className={css["drawerTitle"]}>
            {"选择图标"}
            {/* <Cross onClick={close} /> */}
          </div>
          <div className={css.styleChoose}>
            <div>
              <Radio.Group
                value={iconSet}
                onChange={(e) => setIconSet(e.target.value)}
              >
                {
                  HarmonyIcons.map(icons => {
                    return <Radio.Button value={icons.title}>{icons.title}</Radio.Button>
                  })
                }
              </Radio.Group>
            </div>
          </div>
        </div>
        <div>
          {renderIcons(HarmonyIcons.find(t => t.title === iconSet)?.icons)}
        </div>
      </Drawer>
    </div>
  );
}
