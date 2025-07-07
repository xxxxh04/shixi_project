// 页面路径：pages/ChatPage.ets

// 导入对话请求工具和消息类型
import { sendMessageToDeepSeek, ChatMessage } from '../utils/RequestUtil'
// 导入路由管理
import { router } from '@kit.ArkUI'
// 导入用户信息类型
import { UserInfo } from '../api/UserApi.type'
// 导入 loading 组件
import { IBestLoading } from "@ibestservices/ibest-ui";

@Entry
@Component
export struct ChatPage {
  // 消息列表状态
  @State messages: ChatMessage[] = []
  // 输入框内容
  @State userInput: string = ''
  // 正在发送消息中
  @State isLoading: boolean = false
  // 错误信息
  @State error: string = ''
  // 当前用户信息
  @State userInfo: UserInfo = {
    id: 0,
    account: '',
    nickname: '',
    avatarUri: 'app.media.icon_mine_avatar' // 默认头像
  }
  // 助手是否正在思考（用于显示 loading）
  @State isThinking: boolean = false

  // 页面加载时，从本地 AppStorage 获取 userInfo
  aboutToAppear() {
    const params = AppStorage.get<UserInfo>('userInfo');
    if (params) {
      this.userInfo = {
        id: params.id,
        account: params.account,
        nickname: params.nickname,
        avatarUri: params.avatarUri
      }
    }
  }

  // AI 接口 key
  private readonly apiKey: string = ''

  // 点击“发送”按钮处理逻辑
  async send() {
    if (!this.userInput.trim()) {
      this.error = '请输入内容'
      return
    }

    this.error = ''
    this.isLoading = true
    this.isThinking = true

    const userMsg = this.userInput.trim()
    // 添加用户消息
    this.messages = [...this.messages, {
      role: 'user',
      content: userMsg
    }]
    this.userInput = ''

    const startTime = Date.now()
    try {
      // 调用后端接口获得回复
      const reply = await sendMessageToDeepSeek(this.messages, this.apiKey)
      const endTime = Date.now()
      const duration = endTime - startTime

      // 插入头像消息，携带该条耗时
      const avatarMsg: ChatMessage = {
        role: 'assistant',
        content: '[avatar]', // 特殊标记用于头像显示
        duration: duration  // 绑定本条回复耗时
      }
      this.messages = [...this.messages, avatarMsg]

      // 插入空消息，用于流式填充回复文本
      const newTextMsg: ChatMessage = {
        role: 'assistant',
        content: ''
      }
      this.messages = [...this.messages, newTextMsg]
      const textMsgIndex = this.messages.length - 1

      this.isThinking = false

      // 流式输出，每30ms添加一个字符
      let i = 0
      const interval = setInterval(() => {
        if (i < reply.length) {
          this.messages[textMsgIndex].content += reply[i]
          this.messages = [...this.messages] // 触发 UI 刷新
          i++
        } else {
          clearInterval(interval)
          this.isLoading = false
          this.isThinking = false
        }
      }, 30)
    } catch (e) {
      this.error = '请求失败'
      this.messages = [...this.messages, {
        role: 'assistant',
        content: '出错了，请稍后再试'
      }]
      this.isLoading = false
      this.isThinking = false
    }
  }

  // 顶部标题栏
  @Builder
  TopBar() {
    Row() {
      // 返回按钮区域
      Column() {
        Image($r('app.media.icpn_back_black'))
          .width(25).height(25)
      }
      .width(50).height(50).justifyContent(FlexAlign.Center)
      .onClick(() => router.back()) // 返回上一页

      // 中间标题文字
      Text("AI助手")
        .fontSize(18).fontWeight(FontWeight.Medium)
        .maxLines(1).textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1).textAlign(TextAlign.Center)

      // 占位列，右侧空白区域
      Column().width(50)
    }
    .width('100%').height(50)
    .padding({ left: 5, right: 5 })
    .backgroundColor('#f8f9fa')
  }

  // 每条消息的渲染方法
  @Builder
  renderMessage(msg: ChatMessage) {
    // 助手头像消息（独立一条），显示对应耗时
    if (msg.role === 'assistant' && msg.content === '[avatar]') {
      Row() {
        Image($r('app.media.app_icon'))
          .width(40).height(40).borderRadius(20).margin({ right: 5 })
        Text(`思考用时：${((msg.duration ?? 0) / 1000).toFixed(2)} 秒`)

      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .margin({ top: 5, bottom: 0 })
    }
    // 用户消息（右对齐）
    else if (msg.role === 'user') {
      Row() {
        Text(msg.content)
          .fontSize(18)
          .backgroundColor('#D6EAF8')
          .padding(10)
          .borderRadius(6)
          .constraintSize({ maxWidth: '72%' })

        Image(this.userInfo.avatarUri)
          .width(40).height(40).borderRadius(20).margin({ left: 5 })
      }
      .width('100%')
      .justifyContent(FlexAlign.End)
      .margin({ top: 5, bottom: 5 })
      .alignItems(VerticalAlign.Top)
    }
    // 助手文字消息（左对齐）
    else if (msg.role === 'assistant') {
      Row() {
        Text(msg.content)
          .fontSize(18)
          .backgroundColor('#F2F2F2')
          .padding(10)
          .borderRadius(6)
          .constraintSize({ maxWidth: '90%' })
      }
      .width('100%')
      .justifyContent(FlexAlign.Start)
      .margin({ top: 5, bottom: 5 })
      .alignItems(VerticalAlign.Top)
    }
  }

  // 页面主构建函数
  build() {
    Column() {
      this.TopBar() // 顶部导航栏

      // 聊天消息区域
      Column() {
        Scroll() {
          Column() {
            // 渲染消息列表
            ForEach(this.messages, (msg: ChatMessage, index: number) => {
              this.renderMessage(msg)
            })

            // 思考中动画提示
            if (this.isThinking) {
              Row() {
                Image($r('app.media.app_icon'))
                  .width(40).height(40).borderRadius(20).margin({ right: 5 })

                Text('亲，请稍等，小助手正十万火急的思考你的问题')
                  .fontSize(18)
                  .backgroundColor('#F2F2F2')
                  .padding(10)
                  .borderRadius(6)
                  .constraintSize({ maxWidth: '72%' })

                IBestLoading({
                  loadingText: "思考中...",
                  loadingIconType: "spinner"
                })
              }
              .width('100%')
              .justifyContent(FlexAlign.Start)
              .margin({ top: 5, bottom: 5 })
              .alignItems(VerticalAlign.Top)
            }
          }
          .padding(10)
        }
        .align(Alignment.Top)
      }
      .layoutWeight(1) // 自动撑满剩余高度

      // 错误提示
      if (this.error) {
        Text(this.error)
          .fontColor(Color.Red)
          .margin({ top: 5, bottom: 5 })
      }

      // 底部输入区域
      Row({ space: 6 }) {
        Stack() {
          TextInput({
            text: this.userInput,
            placeholder: '请输入内容'
          })
            .width('100%')
            .height(40)
            .padding({ left: 10 })
            .border({ width: 1, color: '#BBB', radius: 8 })
            .onChange((value: string) => this.userInput = value)
        }
        .width('75%') // 输入框占 3/4

        Button(this.isLoading ? '发送中...' : '发送')
          .width('25%')
          .height(40)
          .enabled(!this.isLoading)
          .onClick(() => this.send())
      }
      .margin({ top: 10 })
    }
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.KEYBOARD], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]) // 键盘和系统安全区适配
    .padding({ top: 10, bottom: 10, left: 10, right: 10 })
    .width('100%')
    .height('100%')
  }
}
