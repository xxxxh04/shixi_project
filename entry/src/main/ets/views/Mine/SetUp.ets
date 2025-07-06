import AppRouter from '@ohos.router';
import { RouterConstant } from '../../contants/RouterConstant';
import { SettingItem } from './SettingItem';
import promptAction from '@ohos.promptAction';
import { CommonConstant } from '../../contants/CommonConstant';
import { UserInfo } from '../../api/UserApi.type';

@Entry
@Component
export struct SetUp {

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



  @State updateTip: string = ''  // 使用响应式变量

  private checkAppUpdate() {
    console.info('[Update] eventType: checkAppUpdate triggered');
    let hasUpdate = false; // 改为 true 模拟有更新

    if (hasUpdate) {
      this.updateTip = '发现新版本，请前往应用市场更新。';
    } else {
      this.updateTip = '当前已是最新版本。';
    }
  }
  private onEditProfile = () => {
    //个人信息
    if (!this.isLogin) {
      //未登录----跳转到登录页面
      AppRouter.pushUrl({ url: RouterConstant.PAGE_LOGIN });
    }else {
      //已登录----跳转到个人信息页面
      AppRouter.pushUrl({ url: RouterConstant.VIEWS_MINE_INFO });
    }
  }

  private onPrivacyPolicy = () => {
    //隐私政策
    AppRouter.pushUrl({ url: RouterConstant.PAGE_PRIVACY_POLICY });
  }

  private onCurrentVersion = () => {
    AppRouter.pushUrl({ url: RouterConstant.VIEWS_MINE_ABOUT_US });
    console.log('显示当前版本信息');
  }

  private onCheckUpdate = () => {

    this.checkAppUpdate(); // 触发更新事件

    setTimeout(() => {
      promptAction.showToast({
        message: this.updateTip,
        duration: 2000
      });
    }, 1000); // 延迟1000毫秒（即1秒）
    console.log('检查更新逻辑');
  }
  build() {
    Column()
    {
      Navigation() {
        // 放 UI 内容，比如 Text、Web、Column 等
        SettingItem({
          label: '编辑资料',
          clickHandler: this.onEditProfile,
        })

        SettingItem({
          label: '隐私政策',
          clickHandler: this.onPrivacyPolicy,
        })

        SettingItem({
          label: '当前版本',
          clickHandler: this.onCurrentVersion,
        })

        SettingItem({
          label: '检查更新',
          clickHandler: this.onCheckUpdate,
        })

      }
      .title('设置') //  正确设置标题
      .titleMode(NavigationTitleMode.Mini) //  设置标题模式
      .mode(NavigationMode.Stack) //  设置导航模式
      .hideBackButton(false)


    }  //.backgroundColor('#f8f8f8')
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
    .width(CommonConstant.WIDTH_FULL)
    .height(CommonConstant.HEIGHT_FULL)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .padding(10)
  }
}

