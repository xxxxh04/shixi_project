@Component
export struct UploadDialog {
  @Prop isVisible: boolean = false  // 控制是否显示

  build() {
    // 只渲染一个根节点 Column，避免多根错误
    Column() {
      if (this.isVisible) {
        // 用 Stack 包住遮罩和加载框
        Stack() {
          // 背景遮罩（使用 Column 包住）
          Column() {
            Blank()  // 需要包在 Column 内
          }
          .width('100%')
          .height('100%')
          .backgroundColor('rgba(0, 0, 0, 0.4)')  // 半透明背景

          // 居中加载提示框
          Column() {
            LoadingProgress()
              .width(40)
              .height(40)
              .color('#ffffff')
              .margin(10)

            Text('上传中...')
              .fontSize(16)
              .fontColor('#ffffff')
          }
          .padding(20)
          .backgroundColor('#333333')
          .borderRadius(10)
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
        }
        .width('100%')
        .height('100%')
      }
    }
    .width('100%')
    .height('100%')
  }
}
