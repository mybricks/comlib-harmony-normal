export const getFilterSelector = () => `:not(#{id} *[data-isslot="1"] *)`;

export const getFilterSelectorWithId = (id: string) => `:not(#${id} *[data-isslot="1"] *)`;

