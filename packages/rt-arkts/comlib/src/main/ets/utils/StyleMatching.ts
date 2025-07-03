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

interface GradientResult {
  angle: number;
  colors: Array<[string, number]>;
}

export function parseLinearGradient(gradientStr: string): GradientResult {
  try {
    // 移除 'linear-gradient(' 和最后的 ')'
    const content: string = gradientStr.replace(/^linear-gradient\(|\)$/g, '');

    // 使用正则表达式匹配角度
    const angleMatch = content.match(/(\d+)deg/);
    const angle: number = angleMatch ? parseInt(angleMatch[1]) : 0;

    // 使用正则表达式匹配rgba颜色和百分比
    const colorRegex = /rgba\(\s*\d+\s*,\s*\d+\s*,\s*\d+\s*,\s*\d+\s*\)\s*\d+%/g;
    const colorMatches = content.match(colorRegex);

    const colors: Array<[string, number]> = [];

    if (colorMatches) {
      colorMatches.forEach(match => {
        // 分离rgba和百分比
        const lastSpaceIndex = match.lastIndexOf(' ');
        const rgba = match.substring(0, lastSpaceIndex);
        const percent = parseInt(match.substring(lastSpaceIndex).replace('%', ''));
        colors.push([rgba, percent / 100]);
      });
    }

    return {
      angle: angle,
      colors: colors
    };
  } catch (error) {
    console.error('Invalid gradient string format:', error);
    return {
      angle: 0,
      colors: []
    };
  }
}
