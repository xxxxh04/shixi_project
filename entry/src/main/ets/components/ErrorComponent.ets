// ErrorComponent.ets
@Component
export struct ErrorComponent {
  message: string = '加载失败';
  onRetry: () => void = () => {};

  build() {
    Column() {
      Image($r('app.media.error'))
        .width(80)
        .height(80)

      Text(this.message)
        .fontSize(16)
        .margin({ top: 15 })

      Button('重新加载')
        .width(120)
        .margin({ top: 20 })
        .onClick(() => this.onRetry())
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
  }
}