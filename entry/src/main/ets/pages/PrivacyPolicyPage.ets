import { webview } from '@kit.ArkWeb'

@Entry
@Component
export struct PrivacyPolicyPage {
  webViewController: webview.WebviewController = new webview.WebviewController()

  build() {
    Navigation() {
      Web({
        src: $rawfile('PrivacyPolicy.html'),
        controller: this.webViewController
      })
        .width('100%')
        .height('100%')
    }
    .title('隐私政策')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
    .height('100%')
    .width('100%')
  }
}

