@ComponentV2
export struct SettingItem {
  @Require @Param label: string;
  @Param clickHandler: () => void = () => {};

  build() {
    Row() {
      Text(this.label)
        .fontSize(16)

      Blank()

      Image($r('app.media.icon_arrow'))
        .width(20)
        .height(20)
        .margin(10)
    }
    .margin({bottom:4,top:4})
    .backgroundColor(Color.White)
    .width('100%')
    .padding({ left: 16, right: 16 })
    .height(48)
    .alignItems(VerticalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .border({
      width: 1,
      color: '#E5E5E5',
      radius: 10,
    })
    .onClick(() => {
      if (this.clickHandler) {
        this.clickHandler();
      }
    })
  }
}
