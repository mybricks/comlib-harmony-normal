export default {
  '@init'({ style }) {
    style.width = 200
    style.height = 10
  },
  '@resize': {
    options: ['width', 'height'],
  },
  ':root': {
    style: [
      {
        title: '背景',
        options: ['border', 'background'],
        target: '.mybricks-progress-bg',
      },
      {
        title: '进度条',
        options: ['border', 'background'],
        target: '.mybricks-progress-bar',
      },
    ],
    items: [
      {
        title: '初始进度',
        type: 'inputnumber',
        options: [{ min: 1 }],
        value: {
          get({ data }) {
            return [data.initValue]
          },
          set({ data }, value: string) {
            if (Array.isArray(value)) {
              data.initValue = value?.[0]
            } else {
              data.initValue = value
            }
          },
        },
      },
      {
        title: "事件",
        items: [
          {
            title: "当进度结束时",
            type: "_event",
            options: {
              outputId: "onEnded",
            },
          },
        ],
      },
    ],
  },
}
