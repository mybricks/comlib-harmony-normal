export default function ({ data, input, output }) {
  if (!data?.imageSize) {
    data.imageSize = [14, 14];
  }

  return true;
}
