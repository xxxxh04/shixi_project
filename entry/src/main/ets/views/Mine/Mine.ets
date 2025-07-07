import { CommonConstant } from '../../contants/CommonConstant'
import { MineMenuItem } from './MineMenuItem'
import { UserInfo} from '../../api/UserApi.type'
import AppRouter from '@ohos.router';
import { RouterConstant } from '../../contants/RouterConstant';
import prompt from '@system.prompt';
import {loginoutDialogComponent} from './loginoutDialogComponent'
import {feedBackComponent} from './feedBackComponent'


@Entry
@Component
export struct Mine {
  @Styles fancy(){
    .margin({bottom:10})
    .backgroundColor($r('app.color.component_color'))
    .border({
      width: 1,
      color: '#E5E5E5',
      radius: 20
    })
  }
  // 是否登录
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
  controller: CustomDialogController = new CustomDialogController({
    builder:feedBackComponent()
  })
  controller1: CustomDialogController = new CustomDialogController({
    builder:loginoutDialogComponent()
  })


  build() {
    Stack(){
      Navigation(){
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
          Row() {
            Image(
              this.isLogin
                ? this.userInfo.avatarUri
                : $r(this.userInfo.avatarUri)
            )
              .width(60)
              .borderRadius(50)
              .height(60)
            Column() {
              Text(this.userInfo.nickname)
                .fontSize($r('app.float.common_font_size_medium'))
                .fontWeight(FontWeight.Medium)
                .margin(10)

              Text(this.isLogin ? '编辑个人信息' : '请先登录')
                .fontSize($r('app.float.common_font_size_small'))
                .fontColor('#6B6B6B')
                .margin(10)
            }
          }

          .fancy()
          .width(CommonConstant.WIDTH_FULL)
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)
          .padding({ left: 10, right: 10,top: 10, bottom: 10 })
          .onClick(() => {
            console.log('点击触发了');
            AppRouter.pushUrl({
              url: this.isLogin
                ? RouterConstant.VIEWS_MINE_INFO
                : RouterConstant.PAGE_LOGIN
            })
          })
          // 3------其他功能组件
          Column() {
            //1-----个人信息
            Column(){
              MineMenuItem({
                icon: $r('app.media.icon_mine_self'),
                label: '个人信息',
                clickHandler: () => {
                  console.log('点击触发了');
                  AppRouter.pushUrl({
                    url: this.isLogin
                      ? RouterConstant.VIEWS_MINE_INFO  // 已登录----个人信息
                      : RouterConstant.PAGE_LOGIN      // 未登录----登录
                  });
                }
              })
            }
            .fancy()
            Column(){
              //2-----我的收藏
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
              //3-----我的点赞
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
              //4-----我的打卡
              MineMenuItem({
                icon: $r('app.media.icon_mine_collect'),
                label: '我的打卡',
                clickHandler: () => {
                  console.log('点击触发了');
                  AppRouter.pushUrl({
                    url: RouterConstant.VIEWS_LEARN_TOOL
                  })
                }
              })
            }
            .fancy()
            Column(){
              //5-----关于我们
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
              //6-----点击反馈
              MineMenuItem({
                icon: $r('app.media.icon_mine_feedback'),
                label: '点击反馈',
                clickHandler: () => {
                  if (this.isLogin) {
                    this.controller.open();
                  } else {
                    prompt.showToast({
                      message: '请先登录',
                      duration: 2000,
                      bottom: 100,
                    })
                  }
                }
              })
              //7-----设置
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
            }
            .fancy()
            //8-----退出登录
            Column(){
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
            .fancy()
          }
        }
        .margin({ left: 20, right: 20 })
        .width(CommonConstant.WIDTH_FULL)
        .height(CommonConstant.HEIGHT_FULL)
        .padding({left:10,right:10})
      }

      .width(CommonConstant.WIDTH_FULL)
      .height(CommonConstant.HEIGHT_FULL)
      //.backgroundColor(Color.White)
    }
    // .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    // .backgroundImage($r('app.media.background'))
    // .backgroundImageSize(ImageSize.Cover)




  }
}




