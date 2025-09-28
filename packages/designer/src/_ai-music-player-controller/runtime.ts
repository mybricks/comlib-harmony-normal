

export default function ({ env, data, inputs, outputs, onError }) {
  if (data.immediate) {
    if (!env.runtime) {
      return;
    }
    if (data.type === 'onChange') {
      outputs["then"]?.();
    } else {
      outputs["then"]?.();
    }
  } else {
    inputs["call"]((params) => {
      outputs["then"]?.();
    });
  }
}
