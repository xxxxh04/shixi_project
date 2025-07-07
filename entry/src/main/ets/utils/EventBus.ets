import emitter from '@ohos.events.emitter';

// 定义事件类型枚举
export enum EventType {
  REFRESH_MESSAGE = 1,
}

// 定义事件数据接口
interface EventData {
  eventId: number;
}

// 事件总线类
export class EventBus {
  /**
   * 触发事件
   * @param eventType 事件类型
   */
  static emit(eventType: EventType): void {
    const eventData: EventData = {
      eventId: eventType
    };
    emitter.emit(eventData);
  }

  /**
   * 监听事件
   * @param eventType 事件类型
   * @param callback 回调函数
   */
  static on(eventType: EventType, callback: () => void): void {
    const eventData: EventData = {
      eventId: eventType
    };

    // 定义事件回调
    const innerCallback = (): void => {
      callback();
    };

    emitter.on(eventData, innerCallback);
  }

  /**
   * 取消事件监听
   * @param eventType 事件类型
   */
  static off(eventType: EventType): void {
    const eventData: EventData = {
      eventId: eventType
    };
    emitter.off(eventData.eventId);
  }
}