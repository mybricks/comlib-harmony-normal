import { AnyType } from '../types'

export function getStyleValueByPattern<T>(
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
    return value || undefined;
  };

  // 规范化目标选择器
  const targetSelector = normalizeSelector(selectorParts[0]);

  // 在styles中查找匹配的选择器
  const matchingKey = Object.keys(styles).find(key =>
  normalizeSelector(key) === targetSelector
  );
  if (!matchingKey) {
    return defaultValue;
  }

  if (property) {
    const styleValue = styles?.[matchingKey]?.[property];
    return styleValue ? processValue(styleValue) : defaultValue;
  }

  return styles[matchingKey] ?? defaultValue;
}

export function parseRadius(radiusStr: string): AnyType {
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

    // 使用正则表达式匹配颜色和百分比
    // 支持 rgba, rgb, hex 和颜色名称
    const colorRegex = /(?:rgba?\(\s*\d+\s*,\s*\d+\s*,\s*\d+\s*(?:,\s*[\d.]+\s*)?\)|#[0-9a-fA-F]{3,6}|\w+)\s*(\d+)%/g;
    const colorMatches = content.match(colorRegex);

    const colors: Array<[string, number]> = [];

    if (colorMatches) {
      colorMatches.forEach(match => {
        // 分离颜色和百分比
        const lastSpaceIndex = match.lastIndexOf(' ');
        let color, percentStr;

        if (lastSpaceIndex === -1) {
          // 如果没有空格（比如 "0%" 单独出现），这可能是个错误情况
          return;
        } else {
          color = match.substring(0, lastSpaceIndex).trim();
          percentStr = match.substring(lastSpaceIndex).trim();
        }

        const percent = parseInt(percentStr.replace('%', ''));
        colors.push([color, percent / 100]);
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

export function parseBorder(borderStr: string, defaultColor: string = "#fff", defaultWidth: number = 1) {
  // 确保输入是字符串
  if (!borderStr) {
    return {
      width: defaultWidth,
      color:defaultColor
    }
  }
  if (typeof borderStr !== 'string') {
    throw new Error('Input must be a string');
  }

  // 提取宽度
  const widthMatch = borderStr.match(/(\d+)px/);
  const width = widthMatch ? parseInt(widthMatch[1]) : void 0;

  // 提取RGB颜色
  const rgbMatch = borderStr.match(/rgb\s*\(\s*(\d+)\s*,\s*(\d+)\s*,\s*(\d+)\s*\)/);
  const color = rgbMatch ? `rgb(${rgbMatch[1]}, ${rgbMatch[2]}, ${rgbMatch[3]})` : void 0;

  return {
    width: width || defaultWidth,
    color: color || defaultColor
  };
}
