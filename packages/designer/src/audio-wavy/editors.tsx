export default {
  "@init"({ style }) {
    style.width = "100%";
    style.height = 42;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {
    style: [
      {
        title: "样式",
        options: ["border", "background", "padding", "boxShadow"],
        target: `.mybricks-audio-wavy`,
      },
    ],
  },
};
