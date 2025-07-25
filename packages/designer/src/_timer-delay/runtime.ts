import { Data, InputIds } from './constants';

export default function (props: RuntimeParams<Data>) {
  const { env, data, outputs, inputs } = props;
  let timer;

  if (env?.runtime && inputs) {
    inputs[InputIds.Trigger]((val) => {
      clearInterval(timer);
      timer = setTimeout(() => {
        outputs[InputIds.Trigger](val);
      }, data.delay);
    });
    inputs[InputIds.Cancel]?.(() => {
      clearTimeout(timer);
    });
  }
}
