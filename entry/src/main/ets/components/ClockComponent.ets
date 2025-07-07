@Component
export struct ClockComponent {
  // icon图标
  @State icon: ResourceStr = ''
  // 文本
  @State text: string = ''

  build() {
    Row({ space: 10 }) {
      Image(this.icon)
        .width(48).aspectRatio(1)
      Text(this.text)
        .fontSize($r('app.float.common_font_size_medium'))
        .fontColor($r('app.color.text_color'))
        .fontWeight(FontWeight.Normal)

    }
    .width(165)
    .height(90)
    .backgroundColor($r('app.color.component_color'))
    .justifyContent(FlexAlign.Center)
    .borderRadius(8)
  }
}