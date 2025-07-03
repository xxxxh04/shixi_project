
import AppRouter from '@ohos.router';
@Entry
@Component
export struct AboutUs {
  build() {
    // 使用 Stack + Column + justifyContent(SpaceBetween) 解决底部布局问题
    Stack() {
      // 背景图
      // Image($r('app.media.background'))
      //   .width('100%')
      //   .height('100%')
      //   .objectFit(ImageFit.Cover)
      // 页面主内容
      Column() {
        // 顶部导航栏
        // Row() {
        //   // Image($r('app.media.icon_back'))
        //   //   .width(24)
        //   //   .height(24)
        //   //   .margin({ left: 16 })
        //   //   .onClick(() => {
        //   //     // 返回操作，按你的路由写
        //   //   })
        //
        //   Image($r('app.media.Icon_back_black'))
        //     .width(24)
        //     .height(24)
        //     .borderRadius(50)
        //     .backgroundColor('#6B6B6B')
        //     .margin({ left: 16 })
        //     .onClick(() => {
        //       AppRouter.back(); // 返回上一页
        //     })
        //
        //   Text('关于我们')
        //     .fontSize(20)
        //     .fontWeight(FontWeight.Bold)
        //     .margin({ left: 12 })
        // }
        // .width('100%')
        // .height(56)
        // .alignItems(VerticalAlign.Center)
        // .justifyContent(FlexAlign.Start)
        Navigation() {
          // 中间内容
          Column() {
            Image($r('app.media.Icon_app'))
              .width(96)
              .height(96)
              .borderRadius(48)
              .margin({ top: 40 })

            Text('百得知识库')
              .fontSize(22)
              .fontWeight(FontWeight.Bold)
              .margin({ top: 16 })

            Text('百得知识库，让学习更简便')
              .fontSize(16)
              .fontColor('#666')
              .margin({ top: 10 })

            Text('版本号：V1.0.0')
              .fontSize(14)
              .fontColor('#999')
              .margin({ top: 8 })
          }
          .align(Alignment.Center)
          .layoutWeight(1)

          // 占位空间撑开页面，模拟 spacer 功能
          //Blank().layoutWeight(1)

          // 底部描述文字
          Text('百得知识库是某科技有限公司研发的一款编程知识分享的App')
            .fontSize(14)
            .fontColor('#999')
            .textAlign(TextAlign.Center)
            .padding({ left: 30, right: 30, bottom: 40 })
        }
        .title('关于我们') // ✅ 正确设置标题
        .titleMode(NavigationTitleMode.Mini) // ✅ 设置标题模式
        .mode(NavigationMode.Stack) // ✅ 设置导航模式
        .hideBackButton(false)




      }
      .width('100%')
      .height('100%')
    }.backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)

  }
}
