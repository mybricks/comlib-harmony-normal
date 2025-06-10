const InputSchema = {
  openMapPoiDetail: {
    type: 'object',
    description: '地点信息',
    properties: {
      latitude: {
        type: 'number',
      },
      longitude: {
        type: 'number',
      },
      name: {
        type: 'string',
      },
      poiId: {
        type: 'string',
      },
    },
  },
  openMapRoutePlan: {
    type: 'object',
    properties: {
      origin: {
        type: 'object',
        description: '起点信息',
        properties: {
          latitude: {
            type: 'number',
          },
          longitude: {
            type: 'number',
          },
          name: {
            type: 'string',
          },
          poiId: {
            type: 'string',
          },
        },
      },
      destination: {
        type: 'object',
        description: '终点信息',
        properties: {
          latitude: {
            type: 'number',
          },
          longitude: {
            type: 'number',
          },
          name: {
            type: 'string',
          },
          poiId: {
            type: 'string',
          },
        },
      },
    },
  },
  openMapNavi: {
    type: 'object',
    description: '目的地信息',
    properties: {
      latitude: {
        type: 'number',
      },
      longitude: {
        type: 'number',
      },
      name: {
        type: 'string',
      },
      poiId: {
        type: 'string',
      },
    },
  },
}

export default {
  '@init': ({ data, setDesc }) => {
    setDesc('展示地点')
  },
  ':root'({ data, input, output, style }, cate0, cate1, cate2) {
    cate0.title = "常规";
    cate0.items = [
      {
        title: '打开地图',
        type: 'select',
        options: [
          { label: '展示地点', value: 'openMapPoiDetail' },
          { label: '规划路线', value: 'openMapRoutePlan' },
          { label: '开始导航', value: 'openMapNavi' },
        ],
        value: {
          get({ data, setTitle }) {
            return data.type ?? 'openMapPoiDetail'
          },
          set({ data, setDesc }, value: boolean) {
            data.type = value
  
            switch (data.type) {
              case 'openMapPoiDetail': {
                setDesc(`展示地点`)
                return input.get('call').setSchema(InputSchema.openMapPoiDetail)
              }
              case 'openMapRoutePlan': {
                setDesc(`规划路线`)
                return input.get('call').setSchema(InputSchema.openMapRoutePlan)
              }
              case 'openMapNavi': {
                setDesc(`开始导航`)
                return input.get('call').setSchema(InputSchema.openMapNavi)
              }
            }
          },
        },
      },
    ]
  }
}
