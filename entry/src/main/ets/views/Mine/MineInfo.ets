import { CommonConstant } from '../../contants/CommonConstant'
import { MineMenuItem } from './MineMenuItem'

import AppRouter from '@ohos.router';
import { RouterConstant } from '../../contants/RouterConstant';
import type { UserInfo } from '../../api/UserApi.type'

@Entry
@Component
export struct MineInfo {
  // 声明响应式用户对象
  // 定义用户信息状态变量
  @State userInfo: UserInfo = {
    id: 0,
    account: '',
    nickname: '登录/注册',
    avatarUri: 'app.media.icon_mine_avatar'
  }

  // 页面出现时获取参数
  aboutToAppear() {
    const params = AppStorage.get<UserInfo>('userInfo');
    if (params) {
      this.userInfo = {
        id: params.id,
        account: params.account,
        nickname: params.nickname ?? '登录/注册',
        avatarUri: params.avatarUri ?? 'app.media.icon_mine_avatar',
      }
    }
  }

  build() {
    Column() {
      Column() {
        Navigation() {
          // 用户信息 头像行
          Row() {
            Text('头像')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)

            Blank()
              .layoutWeight(1)

            Image(this.userInfo.avatarUri)
              .width(40)
              .height(40)
              .borderRadius(50)

            Image($r('app.media.icon_arrow'))
              .width(20)
              .height(20)
              .margin(10)
          }
          .margin({ bottom: 5 })
          .padding(5)
          .border({
            width: 1,
            color: '#E5E5E5',
            radius: 10
          })

          // 用户信息 昵称行
          Row() {
            Text('昵称')
              .fontSize(20)
              .fontWeight(FontWeight.Medium)

            Blank()
              .layoutWeight(1)

            Text(this.userInfo.nickname)
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
        .title('个人信息')
        .titleMode(NavigationTitleMode.Mini)
        .mode(NavigationMode.Stack)
        .hideBackButton(false)

      }.margin({ left: 15, right: 15, bottom: 15 })
    }
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
  }
}
