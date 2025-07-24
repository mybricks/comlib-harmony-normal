import * as React from 'react';
import ComponentRuntime from './runtime'
import { useDisabledArea } from './../utils/hooks'

export default (props) => {

  const DisabledArea = useDisabledArea()

  return (
    <DisabledArea>
      <ComponentRuntime {...props} />
    </DisabledArea>
  )
}