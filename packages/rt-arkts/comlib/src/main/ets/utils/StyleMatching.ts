import { AnyType } from '../types'

export  function getStyleValueByPattern<T>(
  styles: Record<string, AnyType>,
  selectorParts: string[],
  property: string,
  defaultValue: T
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
    return value;
  };

  // 规范化目标选择器
  const targetSelector = normalizeSelector(selectorParts[0]);

  // 在styles中查找匹配的选择器
  const matchingKey = Object.keys(styles).find(key =>
  normalizeSelector(key) === targetSelector
  );

  return matchingKey ? processValue(styles[matchingKey][property]) : defaultValue;
}
