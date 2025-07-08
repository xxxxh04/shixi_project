import { CommonConstant } from '../contants/CommonConstant'
import { router } from '@kit.ArkUI'
import { RouterConstant } from '../contants/RouterConstant'
import { PreferencesUtil } from '../utils/PreferencesUtil'

@Entry
@Component
struct Advertising {
  // 倒计时秒数，初始值从常量获取（比如3秒）
  @State countDownSeconds: number = CommonConstant.ADVERTISING_TIME

  // 定时器句柄
  private timerHandle: number = 0

  private hasJumped: boolean = false;
  /**
   * 生命周期：页面即将显示时，启动倒计时
   */
  aboutToAppear() {
    this.timerHandle = setInterval(() => {
      if (this.countDownSeconds <= 1) {
        this.clearTimer()
        this.countDownSeconds = 0
        this.jumpToHome()
      } else {
        this.countDownSeconds--
      }
    }, 1000)
  }

  /**
   * 生命周期：页面即将隐藏时，清除倒计时
   */
  aboutToDisappear() {
    this.clearTimer()
  }

  /**
   * 清除定时器
   */
  private clearTimer() {
    if (this.timerHandle) {
      clearInterval(this.timerHandle)
      this.timerHandle = 0
    }
  }

  /**
   * 跳转到首页（根据缓存中是否存在 token 和 userInfo）
   */
  private jumpToHome() {
    if(this.hasJumped) return;
    const token = PreferencesUtil.getData(CommonConstant.PREFERENCES_NAME, CommonConstant.TOKEN_NAME, '')
    const userInfo = PreferencesUtil.getData(CommonConstant.PREFERENCES_NAME, CommonConstant.USER_INFO, '')

    if (token && userInfo) {
      AppStorage.setOrCreate(CommonConstant.TOKEN_NAME, token)
      AppStorage.setOrCreate(CommonConstant.USER_INFO, JSON.parse(userInfo))
    }

    router.replaceUrl({ url: RouterConstant.PAGE_INDEX })
    this.hasJumped = true;
  }

  /**
   * UI 构建方法
   */
  build() {
    Stack() {
      // 广告背景图
      Image($r('app.media.advertising1'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])

      // 右上角倒计时与跳过按钮（在倒计时内才显示）
      if (this.countDownSeconds > 0) {
        Row({ space: 8 }) {
          // 倒计时显示
          Text(`${this.countDownSeconds}s`)
            .fontColor(Color.White)
            .fontSize(16)
            .width(48)
            .height(28)
            .backgroundColor('#99000000') // 半透明黑
            .textAlign(TextAlign.Center)
            .borderRadius(8)

          // 跳过按钮
          Text('跳过')
            .fontColor(Color.White)
            .fontSize(16)
            .width(48)
            .height(28)
            .backgroundColor('#99000000')
            .textAlign(TextAlign.Center)
            .borderRadius(8)
            .onClick(() => {
              this.clearTimer()
              this.jumpToHome()
            })
        }
        // 固定右上角
        .position({ top: 20, right: 20 })
      }
    }
    .width('100%')
    .height('100%')
  }
}
