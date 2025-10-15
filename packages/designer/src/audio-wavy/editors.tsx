export default {
  "@init"({ style }) {
    style.width = "100%";
    style.height = 42;
  },
  "@resize": {
    options: ["width", "height"],
  },
  ":root": {

  },
};
