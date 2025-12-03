export default function ({ data, input, output }) {
  if (!input.get("reset")) {
    input.add({
      id: "reset",
      title: "重置",
      schema: {
        type: "any",
      },
    });
  }

  return true;
}
