import AppRouter from '@ohos.router';

interface MineInfoParams {
  userId?: number;
  userName?: string;
  avatarUrl?: string;
}
@Entry
@Component
export struct MineInfo {
  private userId: number = 0;
  private userName: string = '默认昵称';
  private avatarUrl: string = 'app.media.icon_mine_self'; // 默认头像资源路径

  aboutToAppear() {
    const params = AppRouter.getParams() as MineInfoParams | undefined;
    this.userId = params?.userId ?? 0;
    this.userName = params?.userName ?? '默认昵称';
    this.avatarUrl = params?.avatarUrl ?? 'app.media.icon_mine_self';
  }

  build() {
    Column(){
      Column() {
        Navigation() {
          // 放 UI 内容，比如 Text、Web、Column 等

          // 用户信息  ----头像行
          Row(){
            Text('头像')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)

            Blank()
              .layoutWeight(1)

            Image($r(this.avatarUrl))
              .width(40)
              .height(40)
              .borderRadius(50)

            Image($r('app.media.icon_arrow'))
              .width(20)
              .height(20)
              .margin(10)
          }
          .margin({bottom:5})
          .padding(5)
          .border({
            width: 1,
            color: '#E5E5E5',
            radius: 10
          })


          // 用户信息  ----昵称行
          Row(){
            Text('昵称').fontSize(20)
              .fontWeight(FontWeight.Medium)

            Blank()
              .layoutWeight(1)


            Text(this.userName)
              .fontSize(15)
              .fontColor('#6B6B6B')

            Image($r('app.media.icon_arrow'))
              .width(20)
              .height(20)
              .margin(10)

          }
          .padding(5)
          .border({
            width: 1,
            color: '#E5E5E5',
            radius: 10

          })
        }
        .title('个人信息') // ✅ 正确设置标题
        .titleMode(NavigationTitleMode.Mini) // ✅ 设置标题模式
        .mode(NavigationMode.Stack) // ✅ 设置导航模式
        .hideBackButton(false)
        //.backButton(true) // ✅ 显示返回按钮（可选）




      }.margin({left: 15, right: 15, bottom: 15})
    }.backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
  }







}
