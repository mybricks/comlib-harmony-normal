const fs = require("fs");
const path = require("path");
const dirPath = path.join(__dirname, "../../packages/designer")
const json = require(path.join(dirPath, "harmony.mybricks.json"));
const { comAry } = json;
const usedComponentsMap = {};
const verbose = true;

const getComType = (type) => {
  if (!type) {
    return "ui"
  }

  return type.match(/^js/) ? "js" : "ui"
}

const TraversalComAry = (comAry) => {
  comAry.forEach((com) => {
    if (typeof com === "string") {
      const json = require(path.resolve(dirPath, com));
      if (json.namespace === "mybricks.harmony._muilt-inputJs") {
        return
      }
      usedComponentsMap[json.namespace] = {
        type: getComType(json.rtType),
        hasSlots: !!json.slots,
        hasInputs: !!json.inputs,
        hasOutputs: !!json.outputs
      }
    } else {
      TraversalComAry(com.comAry);
    }
  })
}

TraversalComAry(comAry);

let importComponentCode = "";
let declaredComponentCode = "";

Object.entries(usedComponentsMap).forEach(([namespace, config]) => {
  const namespaceSplit = namespace.split(".")

  const importName = namespaceSplit.join("_");
  const asImportName = (config.type === "ui" ? "Basic" : "basic") + namespaceSplit.map((text) => {
    if (text.toUpperCase() === "MYBRICKS") {
      return "MyBricks";
    }

    return text[0].toUpperCase() + text.slice(1);
  }).join("")

  importComponentCode += `${importName} as ${asImportName},`

  if (config.type === "ui") {
    const importData = importName + "_Data";
    importComponentCode += `${importData},`
    const componentName = asImportName.replace("Basic", "");
    const { hasSlots, hasInputs, hasOutputs } = config;
    declaredComponentCode += `@Builder
    function ${componentName}Builder (params: MyBricksComponentBuilderParams) {
      ${asImportName}({
        uid: params.uid,
        data: createData(params, ${importData}),
        inputs: createInputsHandle(params),
        outputs: createEventsHandle(params),
        styles: createStyles(params),
        ${hasSlots ? "slots: params.slots," : ""}
        ${hasSlots ? "slotsIO: createSlotsIO(params)," : ""}
        parentSlot: params.parentSlot,
        env: createEnv(params),
        _env: _createEnv(params),
        modifier: createModifier(params, CommonModifier)
      })
    }

    @Builder
    export function ${componentName} (params: MyBricksComponentBuilderParams) {
      if (params.parentSlot?.itemWrap) {
        params.parentSlot.itemWrap({
          id: params.uid,
          inputs: params.controller?._inputEvents
        }).wrap.builder(wrapBuilder(${componentName}Builder), params, params.parentSlot.itemWrap({
          id: params.uid,
          inputs: params.controller?._inputEvents
        }).params)
      } else {
        ${componentName}Builder(params)
      }
    }
    \n`
  } else {
    let componentName = asImportName.replace("basic", "");
    componentName = componentName[0].toLowerCase() + componentName.slice(1);
    declaredComponentCode += `export const ${componentName} = (props: MyBricks.JSParams, appContext: MyBricks.AppContext): (...values: MyBricks.EventValue) => Record<string, MyBricks.EventValue> => {
      return createJSHandle(${asImportName}, { props, appContext });
    }\n`
  }
})

fs.writeFileSync(path.join(__dirname, "../../packages/rt-arkts/comlib/Index.ets"), `import {
  MyBricks,
  createEnv,
  _createEnv,
  createData,
  createStyles,
  createSlotsIO,
  createJSHandle,
  createModifier,
  CommonModifier,
  createInputsHandle,
  createEventsHandle,
  MyBricksComponentBuilderParams
} from '@mybricks/render-utils';

import {${importComponentCode}} from './src/main/ets/Index'\n\n${declaredComponentCode}`, 'utf-8');
