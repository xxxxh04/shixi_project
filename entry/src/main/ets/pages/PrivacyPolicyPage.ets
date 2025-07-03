import { webview } from '@kit.ArkWeb';
import { CommonConstant } from '../contants/CommonConstant';

@Entry
@Component
struct PolicyPage {
  // 创建 WebView 控制器
  webViewController: webview.WebviewController = new webview.WebviewController;

  build() {
    // Navigation 容器，带标题和返回
    Navigation() {
      // 竖向布局
      Column() {
        // 内嵌 WebView 显示 HTML 文件
        Web({
          src: $rawfile("PrivacyPolicy.html"),
          controller: this.webViewController
        })
          // 让WebView高度填满父容器
          .width('100%')
          .height('100%')
      }
      // 内层布局高度
      .height('100%')
      .width('100%')
      .justifyContent(FlexAlign.Center) // 内容垂直居中
    }
    // Navigation 容器属性
    .width('100%')
    .height('100%')
    .title($r('app.string.privacy_policy')) // 标题：隐私政策
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundImage($r('app.media.background')) // 背景图片
    .backgroundImageSize({ width: '100%', height: '100%' }) // 背景图大小
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP]) // 适配安全区域
  }
}
