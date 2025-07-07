import { webview } from '@kit.ArkWeb';
import { CommonConstant } from '../contants/CommonConstant';

@Entry
@Component
struct UserPolicyPage {
  // 创建 WebView 控制器
  webViewController: webview.WebviewController = new webview.WebviewController;

  build() {
    // Navigation 容器
    Navigation() {
      // WebView 展示用户协议HTML
      Web({
        src: $rawfile("UserPolicy.html"),
        controller: this.webViewController
      })
        .width('100%')
        .height('100%')
    }
    .title('用户协议')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .height('100%')
    .width('100%')
  }
}
