import { CommonConstant } from '../../contants/CommonConstant'
import { router } from '@kit.ArkUI'
import { RouterConstant } from '../../contants/RouterConstant'

//退出登录弹窗
@CustomDialog
@Component
struct loginoutDialogComponent {
  controller: CustomDialogController = new CustomDialogController({
    builder: loginoutDialogComponent()
  })
  build() {
    Column({ space: 20 }) {
      // 标题
      Text('退出登录')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .width(CommonConstant.WIDTH_FULL)
        .padding({ top:10,bottom: 6 })

      // 是否退出登录
      Text('是否退出登录?')
        .textAlign(TextAlign.Center)
        .width('90%')
        .height(50)
        .backgroundColor('#fff')
          // .borderRadius(12)
        .padding(10)
        .fontSize(20)


      Column(){
        Divider()
          .strokeWidth(1)
          .color('#CCCCCC')
          .width(CommonConstant.WIDTH_FULL)

        // 按钮区域
        Row() {
          // 取消按钮
          Button('取消', { type: ButtonType.Normal })
            .width('50%')
            .height(CommonConstant.HEIGHT_FULL)
            .backgroundColor('#FFFFFF')
            .fontColor(Color.Black)
            .onClick(() => this.controller.close())

          // 确认按钮区域，包含左边框
          Row() {
            // 模拟左边框
            Column()
              .width(1)
              .height('100%')
              .backgroundColor('#CCCCCC')

            // 确认按钮
            Button('确认', { type: ButtonType.Normal })
              .width(CommonConstant.WIDTH_FULL)
              .height(CommonConstant.HEIGHT_FULL)
              .backgroundColor('#FFFFFF')
              .fontColor(Color.Blue)
              .onClick(() => {
                console.log('退出登录')
                AppStorage.delete('userInfo') // 清空登录状态
                this.controller.close()       // 关闭弹窗
                router.pushUrl({                // 跳转首页并切换到“我的”Tab
                  url: RouterConstant.PAGE_INDEX,
                  params: {
                    currentIndex: 3
                  }
                })
              })
          }
          .width('50%')
        }
        .width(CommonConstant.WIDTH_FULL)
        .height(50)
        .borderRadius({
          topLeft: 0,
          topRight: 0,
          bottomLeft: 10,
          bottomRight: 10
        })
        .backgroundColor('#FFFFFF')
      }
      .width(CommonConstant.WIDTH_FULL)
      .backgroundColor('#FFFFFF')
      .borderRadius(20)

    }
    .margin({ top: 10 })
    .width(CommonConstant.WIDTH_FULL)
    .backgroundColor('#FFFFFF')
    .borderRadius(5)
  }
}

export { loginoutDialogComponent }
