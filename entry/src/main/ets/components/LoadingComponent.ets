/**
 * 加载组件
 * 用于页面数据加载时的提示
 */
@Component
export struct LoadingComponent {
  // 加载提示文字
  @State message: string = '数据正在加载中...';

  build() {
    Row() {
      // 圆形加载动画
      LoadingProgress()
        .width(30)
        .height(30)
        .color(Color.Gray);
      // 文字
      Text(this.message)
        .fontSize(14)
        .fontColor($r('app.color.text_color'));
    }
    .height('80%')
    .width('100%')
    .justifyContent(FlexAlign.Center); // 水平居中
  }
}
