import HarmonyPermissions from "../utils/conts/permissions";

export default {
  ":root": [
    {
      title: "应用权限",
      description: "选择需要校验授权的应用权限",
      type: "select",
      options: {
        showSearch: true,
        options: HarmonyPermissions,
        filterOption: (input, option) => {
          const filterLabel = (option?.label ?? "")
            .toLowerCase()
            .includes(input.toLowerCase());
          const filterValue = (option?.value ?? "")
            .toLowerCase()
            .includes(input.toLowerCase());
          return filterLabel || filterValue;
        },
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
