import HarmonyPermissions from "../utils/conts/permissions";

export default {
  ":root": [
    {
      title: "应用权限",
      description: "选择需要授权的应用权限",
      type: "select",
      options: {
        showSearch: true,
        options: HarmonyPermissions,
      },
      value: {
        get({ data }) {
          return data.permissions;
        },
        set({ data }, value) {
          data.permissions = value;
        },
      },
    },
  ],
};
