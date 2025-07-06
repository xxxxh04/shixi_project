
import type { UserInfo } from '../../api/UserApi.type'
import userapi from '../../api/UserApi'
import { prompt, router } from '@kit.ArkUI'
import { RouterConstant } from '../../contants/RouterConstant'
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { PreferencesUtil } from '../../utils/PreferencesUtil';
import { CommonConstant } from '../../contants/CommonConstant';

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
  //用于修改昵称
  @State showDialog: boolean = false
  @State newNickname: string = ''
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: (): void => this.buildDialog(),
    cancel: (): void => {}
  })



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
    }else {
      // 未登录，设置默认头像资源名
      this.userInfo.avatarUri = 'app.media.icon_mine_avatar'
    }
  }

  // 弹出图片选择器方法
  async openPicker() {
    try {
      const photoSelectOptions = new photoAccessHelper.PhotoSelectOptions()
      photoSelectOptions.MIMEType = photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
      photoSelectOptions.maxSelectNumber = 1
      const photoViewPicker = new photoAccessHelper.PhotoViewPicker()
      const result = await photoViewPicker.select(photoSelectOptions)

      if (!result || result.photoUris.length === 0) {
        return
      }

      const uri = result.photoUris[0]
      this.userInfo.avatarUri = uri

      // ✅ 本地保存头像地址到 AppStorage（持久化）
      const userInfo = AppStorage.get<UserInfo>('userInfo') ?? {
        id: 0,
        account: '',
        nickname: '登录/注册',
        avatarUri: ''
      }
      userInfo.avatarUri = uri
      AppStorage.setOrCreate('userInfo', userInfo)

      // ✅ 可选：PreferencesUtil 也同步保存
      PreferencesUtil.savaData(
        CommonConstant.PREFERENCES_NAME,
        CommonConstant.USER_INFO,
        JSON.stringify(userInfo)
      )
      router.pushUrl({                // 跳转首页并切换到“我的”Tab
        url: RouterConstant.PAGE_INDEX,
        params: {
          currentIndex: 3
        }
      })
    } catch (e) {
      hilog.error(0x0000, 'MineInfo', 'openPicker error: ' + JSON.stringify(e))
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


            Image( this.userInfo.avatarUri && this.userInfo.avatarUri.startsWith('app.media.')
              ? $r(this.userInfo.avatarUri)
              : this.userInfo.avatarUri)
              .width(40)
              .height(40)
              .borderRadius(50)

            Image($r('app.media.icon_arrow'))
              .width(20)
              .height(20)
              .margin(10)
          }
          .backgroundColor(Color.White)
          .margin({ bottom: 5,left:15,right:15 })
          .padding(5)
          .border({
            width: 1,
            color: '#E5E5E5',
            radius: 10
          })
          .onClick(() => this.openPicker())  // 点击头像触发图片选择

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
          .backgroundColor(Color.White)
          .margin({ left: 15 ,right: 15})
          .padding(5)
          .border({
            width: 1,
            color: '#E5E5E5',
            radius: 10
          })
          .onClick(() => {
            this.newNickname = this.userInfo.nickname
            this.dialogController.open()
          })

        }
        .title('个人信息')
        .titleMode(NavigationTitleMode.Mini)
        .mode(NavigationMode.Stack)
        .hideBackButton(false)
      }
    }
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])



  }
  @Builder
  buildDialog() {
    Column() {
      Text('修改昵称')
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .padding(10)

      TextInput({
        text: this.newNickname,
        placeholder: '请输入新昵称'
      })
        .onChange(value => {
          this.newNickname = value
        })
        .margin(10)


      Row() {
        Button('取消')
          .onClick(() => {
            this.dialogController.close()
          })
          .margin(5)

        Blank()


        Button('确定')
          .onClick(() => {
            const newName = this.newNickname.trim() || '登录/注册';

            // 调用接口更新昵称
            userapi.editNickname({ nickname: newName })
              .then(() => {
                // 接口成功后，更新本地存储
                this.userInfo.nickname = newName;
                AppStorage.set<UserInfo>('userInfo', this.userInfo);

                this.dialogController.close();

                // 返回 Mine 页面，Mine 页面会在 onShow 重新加载昵称
                // router.back();
                router.pushUrl({                // 跳转首页并切换到“我的”Tab
                  url: RouterConstant.PAGE_INDEX,
                  params: {
                    currentIndex: 3
                  }
                })

              })
              .catch(() => {
                // 接口失败，提示错误
                prompt.showToast({ message: '昵称修改失败', duration: 2000 });
              });
          });



      }
      .padding(10)
    }
    .width(300)
    .backgroundColor('#FFF')
    .borderRadius(10)
    .padding(10)
  }

}




