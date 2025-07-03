
@Entry
@Component
struct systemInfo {
  build() {
    Column() {Navigation(){
      // 顶部标题栏


      // 消息卡片
      Column()

      {
        Row()

        {
          Text('关于隐私政策和用户协议')
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)
            .flexGrow(1)

          Text('2025-07-06')
            .fontSize(14)
            .fontWeight(FontWeight.Normal)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.End)
        }.width('100%')
        //.justifyContent(SpaceBetween)
        .alignItems(VerticalAlign.Center)

        Text('大家记得阅读隐私政策和用户协议')
          .width('100%')
          .margin({ top: 8 })
          .fontSize(15)
          .fontWeight(FontWeight.Normal)
          .fontColor(Color.Gray)
          .textAlign(TextAlign.Start)
      }.width('95%')
      .margin({ top: 20 })
      .padding({ top: 15, bottom: 15, left: 15, right: 15 })
      .backgroundColor(Color.White)
      .borderRadius(20)

    }
    .title('系统消息') // ✅ 正确设置标题
    .titleMode(NavigationTitleMode.Mini) // ✅ 设置标题模式
    .mode(NavigationMode.Stack) // ✅ 设置导航模式
    .hideBackButton(false)
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
  }
  }
}
