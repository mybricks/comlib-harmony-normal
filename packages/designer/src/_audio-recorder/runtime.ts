

export default function ({ data, inputs, outputs }) {
  if (data.immediate) {
    outputs['then']?.()
  } else {
    inputs["call"](() => {
      outputs["then"]?.();
    });
  }
}
