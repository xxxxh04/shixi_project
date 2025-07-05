@ComponentV2

export struct MineMenuItem {

  @Require @Param icon: Resource;      // 头像图标资源
  @Require @Param label: string;       // 显示文本
  @Param clickHandler: () => void = () => {};  // 可选回调，给默认空函数，避免报错

  build() {
    Row()
    {

      Image(this.icon)
        .width(40)
        .height(40)
        .margin(5)
        .borderRadius(50)

      Text(this.label)
        .fontSize($r('app.float.common_font_size_medium'))
        .fontWeight(FontWeight.Medium)
        .margin(10)

      Blank()
        .layoutWeight(1)

      Image($r('app.media.icon_arrow'))
        .width(20)
        .height(20)
        .margin(10)
    }     .width('100%')
    .margin({ left: 20, right: 20, bottom: 5 })
    .alignItems(VerticalAlign.Center)
    .padding({ left: 10, right: 10 })
    .onClick(() => {
      if (this.clickHandler) {
        this.clickHandler();
      }
    })
  }
}
