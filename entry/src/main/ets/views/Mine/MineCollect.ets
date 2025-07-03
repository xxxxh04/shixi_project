
import AppRouter from '@ohos.router';
@Entry
@Component
export struct AboutUs {
  build() {
    // 使用 Stack + Column + justifyContent(SpaceBetween) 解决底部布局问题
    Stack() {

      Column() {

        Navigation() {
       Text('只保留当前最近的100条').fontSize(15)
         .fontColor(Color.Gray)
         .width('100%')
         .padding(10)

          //我的收藏
        }
        .title('我的收藏') // ✅ 正确设置标题
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
