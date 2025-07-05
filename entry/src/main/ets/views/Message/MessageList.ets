
@Entry
@Component
export struct MessageList {

  @State showDialog: boolean = false

  build() {

    Stack(){

      Column() {Navigation(){
        // 顶部标题栏

        Column()

        {
          Row()

          {
            Text('欢迎大家来到百得知识库')
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

          Text('希望大家能在百得知识库里学到更多知识，不断进步与成长。')
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

        .onClick(() => {
          // this.newName = this.userName
          this.showDialog = true
        })

      }.title('系统消息') // ✅ 正确设置标题
      .titleMode(NavigationTitleMode.Mini) // ✅ 设置标题模式
      .mode(NavigationMode.Stack) // ✅ 设置导航模式
      .hideBackButton(false)
      .width('100%')
      .height('100%')
      .backgroundImage($r('app.media.background'))
      .backgroundImageSize(ImageSize.Cover)
      }

      if (this.showDialog) {
        this.EditNameDialog()
      }
    }
    .width('100%')
    .height('100%')

  }

  @Builder
  EditNameDialog() {
    Column() {
      Text('消息内容')
        .fontSize(20)
        .margin(10)
      Text('欢迎大家来到百得知识库,希望大家能在百得知识库里学到更多知识，不断进步与成长。')

      Row() {
        Button('确定')
          .backgroundColor('#007DFF')
          .onClick(() => {
            this.showDialog = false
          })
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
      .margin({ top: 20 })
    }
    .width('80%')
    .padding(20)
    .backgroundColor(Color.White)
    .borderRadius(16)
    .shadow({ radius: 12, color: '#1A000000', offsetX: 2, offsetY: 4 })
  }

}




