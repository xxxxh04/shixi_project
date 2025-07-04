import { CommonConstant } from '../contants/CommonConstant';
import { router } from '@kit.ArkUI';
import { RouterConstant } from '../contants/RouterConstant';
import { showToast } from '../utils/Toast';
import userApi from '../api/UserApi';
import { PreferencesUtil } from '../utils/PreferencesUtil';
import { UserInfo} from '../api/UserApi.type'
import { LoginParam } from '../api/UserApi.type'
// 给 TextInput 扩展一个样式方法，统一输入框样式
@Extend(TextInput)
function textInputStyles() {
  .placeholderFont({ size: 12 }) // 设置占位文字大小
  .fontSize(12) // 设置输入文字大小
  .width(250) // 输入框宽度
  .borderRadius(10) // 圆角
}

@Entry
@Component
struct LoginPage {
  // 是否同意用户协议和隐私政策
  @State agree: boolean = false;

  // 账号（必须声明为string类型，避免字面量类型问题）
  @State account: string = '123';

  // 密码
  @State password: string = '123';

  //登陆成功
  @State loginSuccess: boolean = false

  //失败信息
  @State errorMsg: string = ''
  /**
   * 登录逻辑
   */
  async login() {
    // 账号不能为空
    if (!this.account || this.account.trim() === '') {
      showToast('账号不能为空');
      return;
    }



    // 没勾选协议
    if (!this.agree) {
      showToast('请勾选用户协议和隐私政策');
      return;
    }

    // 密码不能为空
    if (!this.password || this.password.trim() === '') {
      showToast('密码不能为空');
      return;
    }

    const param: LoginParam = {
      account: this.account,
      password: this.password
    }
    // 调用接口登录
    try {
      const token = await userApi.userLogin(param);
      this.loginSuccess = true;
      this.errorMsg = '';

      // 存储 token 到内存
      AppStorage.setOrCreate(CommonConstant.TOKEN_NAME, token);
      // 持久化 token 到 Preferences
      await PreferencesUtil.savaData(
        CommonConstant.PREFERENCES_NAME,
        CommonConstant.TOKEN_NAME,
        token
      );

      // 获取用户信息
      const userInfo: UserInfo = await userApi.getUserInfo();

      // 存储用户信息到内存
      AppStorage.setOrCreate(CommonConstant.USER_INFO, userInfo);
      // 持久化用户信息到 Preferences（需序列化为 JSON 字符串）
      await PreferencesUtil.savaData(
        CommonConstant.PREFERENCES_NAME,
        CommonConstant.USER_INFO,
        JSON.stringify(userInfo)
      );

      console.log('登录成功，token:', token);

      // 登录成功后跳转主页
      router.replaceUrl({ url: RouterConstant.PAGE_INDEX });
      // router.back()
    } catch (err) {
      // 优化异常捕获，避免 err 非 Error 类型时报错
      const msg = err instanceof Error ? err.message : CommonConstant.DEFAULT_LOGIN_ERROR;
      this.errorMsg = '登录失败: ' + msg;
      showToast(this.errorMsg);
    }
  }

  /**
   * 页面布局
   */
  build() {
    Column() {
      // 内层竖向排列
      Column({ space: 20 }) {
        // Logo
        Image($r('app.media.app_icon'))
          .width(100) // 宽度
          .aspectRatio(1) // 宽高比1:1
          .borderRadius(15); // 圆角

        // 应用名称
        Text($r('app.string.application_name'))
          .fontSize(24)
          .fontWeight(FontWeight.Medium);

        // 应用描述
        Text($r('app.string.app_description'))
          .fontSize(14)
          .fontColor($r('app.color.common_gray'));

        // 账号输入框
        TextInput({ placeholder: '请输入账号', text: this.account })
          .textInputStyles()
          .onChange((value: string) => { this.account = value; });

        // 密码输入框
        TextInput({ placeholder: '请输入密码', text: this.password })
          .type(InputType.Password)
          .textInputStyles()
          .onChange((value: string) => { this.password = value; });

        // 协议区域
        Row({ space: 6 }) {
          // 勾选框
          Checkbox()
            .select(this.agree)
            .width(18)
            .selectedColor('#007DFF') // 勾选后颜色
            .onChange((v: boolean) => { this.agree = v; });

          // 协议文字
          Text() {
            Span('已阅读并同意')
            Span(' 用户协议 ')
              .fontColor('#007DFF') // 蓝色文字
              .onClick(() => {
                router.pushUrl({ url: RouterConstant.PAGE_USER_POLICY });
              })
            Span('和')
            Span(' 隐私政策 ')
              .fontColor('#007DFF')
              .onClick(() => {
                router.pushUrl({ url: RouterConstant.PAGE_PRIVACY_POLICY });
              })
          }
          .fontSize(12)
          .fontColor($r('app.color.common_gray'));
        }

        // 登录按钮
        Button('登录')
          .width(250)
          .height(42)
          .borderRadius(10)
          .backgroundColor('#007DFF') // 按钮背景色
          .fontColor('#FFFFFF') // 文字颜色
          .fontSize(16)
          .onClick(() => { this.login(); });
      }
      .height('60%') // 内层高度
    }
    // 外层容器
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center) // 垂直居中
    .backgroundImage($r('app.media.background')) // 背景图
    .backgroundImageSize({ width: '100%', height: '100%' }) // 背景大小
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP]); // 适配安全区域
  }
}
