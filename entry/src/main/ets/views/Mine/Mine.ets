import { CommonConstant } from '../../contants/CommonConstant'
import { MineMenuItem } from './MineMenuItem'
import { UserInfo} from '../../api/UserApi.type'
import AppRouter from '@ohos.router';
import { RouterConstant } from '../../contants/RouterConstant';
import router from '@ohos.router';
import prompt from '@system.prompt';

@Entry
@Component
export struct Mine {
  // @State showFeedbackDialog: boolean = false;
  // @State feedbackText: string = '';
  // @State showToast: boolean = false;

  @State isLogin: boolean = false;
  // 定义用户信息状态变量
  @State userInfo: UserInfo = {
    id: 0,
    account: '',
    nickname: '登录/注册',
    avatarUri: 'app.media.icon_mine_avatar'
  }





  aboutToAppear() {
    this.loadUserInfo();
  }

  onShow() {
    this.loadUserInfo();
  }

  loadUserInfo() {
    const params = AppStorage.get<UserInfo>('userInfo');
    if (params) {
      this.userInfo = {
        id: params.id,
        account: params.account,
        nickname: params.nickname ?? '登录/注册',
        avatarUri: params.avatarUri ?? 'app.media.icon_mine_avatar',
      };
      this.isLogin = true;
    } else {
      this.userInfo = {
        id: 0,
        account: '',
        nickname: '登录/注册',
        avatarUri: 'app.media.icon_mine_avatar',
      };
      this.isLogin = false;
    }
  }


  // 页面出现时获取参数
  // aboutToAppear() {
  //   const params = AppStorage.get<UserInfo>('userInfo');
  //   if (params) {
  //     this.userInfo = {
  //       id: params.id,
  //       account: params.account,
  //       nickname: params.nickname ?? '登录/注册',
  //       avatarUri: params.avatarUri ?? 'app.media.icon_mine_avatar',
  //
  //     }
  //     this.isLogin = true;
  //   } else {
  //     // 未登录或未保存用户信息
  //     this.userInfo.nickname = '登录/注册';
  //     this.userInfo.avatarUri = 'app.media.icon_mine_avatar';
  //   }
  // }


  controller: CustomDialogController = new CustomDialogController({
    builder:MyDialogComponent()
  })

  controller1: CustomDialogController = new CustomDialogController({
    builder:loginoutDialogComponent()
  })




  build() {
    Stack() {
      Column() {
        // 1-----我的----标题
        Row() {
          Text('我的')
            .fontSize($r('app.float.common_font_size_huge'))
            .fontWeight(FontWeight.Medium)
        }
        .width(CommonConstant.WIDTH_FULL)
        .margin({ top: 10, bottom: 20 })
        .padding({ left: 20 })

        // 2------个人主页框




        if(this.isLogin){
          // 已登录
          Row() {
            Image((this.userInfo.avatarUri))
              .width(60)
              .borderRadius(50)
              .height(60)
            Column() {
              Text( this.userInfo.nickname)
                .fontSize($r('app.float.common_font_size_medium'))
                .fontWeight(FontWeight.Medium)
                .margin(10)
              Text('编辑个人信息')
                .fontSize($r('app.float.common_font_size_small'))
                .fontColor('#6B6B6B')
                .margin(10)
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)
          .margin({ left: 20, right: 20, bottom: 20 })
          .padding({ left: 20, right: 20 })
          .border({
            width: 1,
            color: '#E5E5E5',
            radius: 20
          })
          .onClick(() => {
            console.log('点击触发了');
            AppRouter.pushUrl({
              url: RouterConstant.VIEWS_MINE_INFO
            })
          })
        }else {
          Row() {
            Image($r(this.userInfo.avatarUri))
              .width(60)
              .borderRadius(50)
              .height(60)
            Column() {
              Text( this.userInfo.nickname)
                .fontSize($r('app.float.common_font_size_medium'))
                .fontWeight(FontWeight.Medium)
                .margin(10)
              Text('请先登录')
                .fontSize($r('app.float.common_font_size_small'))
                .fontColor('#6B6B6B')
                .margin(10)
            }
          }
          .width('100%')
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)
          .margin({ left: 20, right: 20, bottom: 20 })
          .padding({ left: 20, right: 20 })
          .border({
            width: 1,
            color: '#E5E5E5',
            radius: 20
          })
          .onClick(() => {
            //没有登录时   ----跳转到登录页面
            console.log('点击触发了');
            AppRouter.pushUrl({
              url: RouterConstant.PAGE_LOGIN
            })
          })
        }



        // 3------其他功能组件
        Column() {

          MineMenuItem({
            icon: $r('app.media.icon_mine_self'),
            label: '个人信息',
            clickHandler: () => {
              console.log('点击触发了');
              AppRouter.pushUrl({
                url: RouterConstant.VIEWS_MINE_INFO
              })
            }
          })

          MineMenuItem({
            icon: $r('app.media.icon_mine_collect'),
            label: '我的收藏',
            clickHandler: () => {
              console.log('点击触发了');
              AppRouter.pushUrl({
                url: RouterConstant.VIEWS_MINE_COLLECT
              })
            }
          })
          MineMenuItem({
            icon: $r('app.media.icon_mine_like'),
            label: '我的点赞',
            clickHandler: () => {
              console.log('点击触发了');
              AppRouter.pushUrl({
                url: RouterConstant.VIEWS_MINE_LIKE
              })
            }
          })
          MineMenuItem({
            icon: $r('app.media.icon_mine_collect'),
            label: '我的打卡',
          })
          MineMenuItem({
            icon: $r('app.media.icon_mine_info'),
            label: '关于我们',
            clickHandler: () => {
              console.log('点击触发了');
              AppRouter.pushUrl({
                url: RouterConstant.VIEWS_MINE_ABOUT_US
              })
            }
          })
          MineMenuItem({
            icon: $r('app.media.icon_mine_feedback'),
            label: '点击反馈',


            clickHandler: () => {
              console.log('点击触发了');
              this.controller.open()
            }
          })
          MineMenuItem({
            icon: $r('app.media.icon_mine_setting'),
            label: '设置',
            clickHandler: () => {
              console.log('点击触发了');
              AppRouter.pushUrl({
                url: RouterConstant.VIEWS_MINE_SET_UP
              })
            }
          })
          MineMenuItem({
            icon: $r('app.media.icon_mine_logout'),
            label: '退出登录',
            clickHandler: () => {
              if (this.isLogin) {
                this.controller1.open()
              } else {
                prompt.showToast({
                  message: '请先登录',
                  duration: 2000,
                  bottom: 100,
                })
              }
            }
          })

        }

      }.margin({ left: 10, right: 10 })
      .width('100%')
      .height('100%')

    }.backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
  }
}


@CustomDialog
@Component
struct MyDialogComponent {
  controller: CustomDialogController = new CustomDialogController({
    builder: MyDialogComponent()
  })

  feedbackText: string = ''

  build() {
    Column({ space: 20 }) {
      // 标题
      Text('反馈意见')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .width('100%')
        .padding({ top:10,bottom: 6 })

      // 输入框区域
      TextInput({
        placeholder: '请输入反馈意见,长度不能超过255字符',
        text: this.feedbackText,
      })
        .width('90%')
        .height(50)
        .backgroundColor('#CCCCCC')
        .borderRadius(12)
        .padding(10)
        .fontSize(16)


      Column(){
        Divider()
          .strokeWidth(1)
          .color('#CCCCCC')
          .width('100%')

        // 按钮区域
        Row() {
          // 取消按钮
          Button('取消', { type: ButtonType.Normal })
            .width('50%')
            .height('100%')
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
              .width('100%')
              .height('100%')
              .backgroundColor('#FFFFFF')
              .fontColor(Color.Blue)
              .onClick(() => {
                console.log('666')
                this.controller.close()
              })
          }
          .width('50%')
        }
        .width('100%')
        .height(50)
        .borderRadius({
          topLeft: 0,
          topRight: 0,
          bottomLeft: 10,
          bottomRight: 10
        })
        .backgroundColor('#FFFFFF')
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .borderRadius(20)

    }
    .margin({ top: 10 })
    // .padding(20)
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(5)
  }
}


//退出登录弹窗
@CustomDialog
@Component
struct loginoutDialogComponent {
  controller: CustomDialogController = new CustomDialogController({
    builder: loginoutDialogComponent()
  })

  // feedbackText: string = ''

  build() {
    Column({ space: 20 }) {
      // 标题
      Text('退出登录')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .width('100%')
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
          .width('100%')

        // 按钮区域
        Row() {
          // 取消按钮
          Button('取消', { type: ButtonType.Normal })
            .width('50%')
            .height('100%')
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
              .width('100%')
              .height('100%')
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
        .width('100%')
        .height(50)
        .borderRadius({
          topLeft: 0,
          topRight: 0,
          bottomLeft: 10,
          bottomRight: 10
        })
        .backgroundColor('#FFFFFF')
      }
      .width('100%')
      .backgroundColor('#FFFFFF')
      .borderRadius(20)

    }
    .margin({ top: 10 })
    // .padding(20)
    .width('100%')
    .backgroundColor('#FFFFFF')
    .borderRadius(5)
  }
}