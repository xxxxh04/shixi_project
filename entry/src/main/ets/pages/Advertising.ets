import { CommonConstant } from '../contants/CommonConstant';
import { router } from '@kit.ArkUI';
import { RouterConstant } from '../contants/RouterConstant';
import { PreferencesUtil } from '../utils/PreferencesUtil';

@Entry
@Component
struct Advertising {
  // 倒计时秒数
  @State countDownSeconds: number = CommonConstant.ADVERTISING_TIME;

  // 定时器句柄
  timerHandle: number = 0;

  /**
   * 生命周期函数：页面显示时启动倒计时
   */
  onPageShow() {
    this.timerHandle = setInterval(() => {
      if (this.countDownSeconds <= 1) {
        // 最后一次倒计时
        clearInterval(this.timerHandle);
        this.countDownSeconds = 0;
        this.jumpToHome();
      } else {
        // 继续递减
        this.countDownSeconds--;
      }
    }, 1000);
  }

  /**
   * 生命周期函数：页面隐藏时清理定时器
   */
  onPageHide() {
    clearInterval(this.timerHandle);
  }

  /**
   * 跳转到首页
   */
  jumpToHome() {
    // 从本地获取token和用户信息
    const token = PreferencesUtil.getData(CommonConstant.PREFERENCES_NAME, CommonConstant.TOKEN_NAME, '');
    const userInfo = PreferencesUtil.getData(CommonConstant.PREFERENCES_NAME, CommonConstant.USER_INFO, '');
    if (token && userInfo) {
      AppStorage.setOrCreate(CommonConstant.TOKEN_NAME, token);
      AppStorage.setOrCreate(CommonConstant.USER_INFO, JSON.parse(userInfo));
    }
    // 跳转首页
    router.replaceUrl({ url: RouterConstant.PAGE_INDEX });
  }

  build() {
    Stack() {
      // 背景图
      Image($r('app.media.advertising'))
        .width('100%')
        .height('100%')
        .objectFit(ImageFit.Cover)

      // 右上角倒计时 + 跳过按钮
      if (this.countDownSeconds > 0) {
        Row({ space: 8 }) {
          // 倒计时数字
          Text(`${this.countDownSeconds}s`)
            .fontColor(Color.White)
            .fontSize(16)
            .width(48)
            .height(28)
            .backgroundColor('#99000000')
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
              clearInterval(this.timerHandle);
              this.jumpToHome();
            })
        }
        // 固定在右上角
        .position({ top: 20, right: 20 })
      }
    }
    .width('100%')
    .height('100%')
  }
}
