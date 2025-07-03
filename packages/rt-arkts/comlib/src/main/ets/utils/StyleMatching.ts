import { AnyType } from '../types'

export  function getStyleValueByPattern<T>(
  styles: Record<string, AnyType>,
  selectorParts: string[],
  property?: string,
  defaultValue: T = undefined
): T {
  // 处理输入的选择器：拆分、排序、重组
  const normalizeSelector = (selector: string) => {
    return selector.split(',')
      .map(part => part.trim())
      .sort()
      .join(',');
  };

  // 处理可能带有px的值
  const processValue = (value: any): any => {
    if (typeof value === 'string' && value.endsWith('px')) {
      // 移除'px'并转换为数字
      return parseInt(value.replace('px', ''));
    }
    return value || 0;
  };

  // 规范化目标选择器
  const targetSelector = normalizeSelector(selectorParts[0]);

  // 在styles中查找匹配的选择器
  const matchingKey = Object.keys(styles).find(key =>
  normalizeSelector(key) === targetSelector
  );
  if(property){
    return matchingKey ? processValue(styles[matchingKey][property]) : defaultValue;
  }else{
    return matchingKey ? styles[matchingKey] : defaultValue;
  }
}

export function parseRadius(radiusStr:string):AnyType {
  const values = radiusStr.trim().split(/\s+/);
  const numbers = values.map(val => parseInt(val));
  switch (numbers.length) {
    case 1:
      return numbers[0];
    case 2:
      return {
        topLeft: numbers[0],
        topRight: numbers[1],
        bottomRight: numbers[0],
        bottomLeft: numbers[1]
      };
    case 3:
      return {
        topLeft: numbers[0],
        topRight: numbers[1],
        bottomRight: numbers[2],
        bottomLeft: numbers[1]
      };
    case 4:
      return {
        topLeft: numbers[0],
        topRight: numbers[1],
        bottomRight: numbers[2],
        bottomLeft: numbers[3]
      };
    default:
      return 0;
  }
}
