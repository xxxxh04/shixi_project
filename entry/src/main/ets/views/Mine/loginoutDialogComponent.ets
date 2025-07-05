import { CommonConstant } from '../../contants/CommonConstant'
import { router } from '@kit.ArkUI'
import { RouterConstant } from '../../contants/RouterConstant'
import { PreferencesUtil } from '../../utils/PreferencesUtil'

// 退出登录弹窗
@CustomDialog
@Component
export struct loginoutDialogComponent {  // ✅ 必须 export struct，而不是 export { xxx }
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
        .padding({ top: 10, bottom: 6 })

      // 内容
      Text('是否退出登录?')
        .textAlign(TextAlign.Center)
        .width('90%')
        .height(50)
        .backgroundColor('#fff')
        .padding(10)
        .fontSize(20)

      Column() {
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
            Column()
              .width(1)
              .height('100%')
              .backgroundColor('#CCCCCC')

            Button('确认', { type: ButtonType.Normal })
              .width(CommonConstant.WIDTH_FULL)
              .height(CommonConstant.HEIGHT_FULL)
              .backgroundColor('#FFFFFF')
              .fontColor(Color.Blue)
              .onClick(async () => {
                console.log('退出登录')
                // 删除 AppStorage 数据
                AppStorage.delete(CommonConstant.USER_INFO)
                AppStorage.delete(CommonConstant.TOKEN_NAME)

                // 删除持久化数据
                await PreferencesUtil.delAllData(CommonConstant.PREFERENCES_NAME, CommonConstant.TOKEN_NAME)
                await PreferencesUtil.delAllData(CommonConstant.PREFERENCES_NAME, CommonConstant.USER_INFO)

                // 关闭弹窗 + 跳转
                this.controller.close()
                router.pushUrl({
                  url: RouterConstant.PAGE_INDEX,
                  params: { currentIndex: 3 }
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
