import { emitter } from '@kit.BasicServicesKit'

export class Event {
  static instance: Event

  static getInstance(): Event {
    if (!Event.instance) {
      Event.instance = new Event();
    }
    return Event.instance;
  }

  registerEvent(id: string, func: CallableFunction) {
    emitter.on(id, (eventData: emitter.EventData) => {
      func(eventData.data);
    })
  }

  emit(id: string, data: ESObject) {
    emitter.emit(id, {
      data: data
    });
  }

  unregisterEvent(id: string) {
    emitter.off(id);
  }
}