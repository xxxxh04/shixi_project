// pages/ChatPage.ets
import { sendMessageToDeepSeek, ChatMessage } from '../utils/RequestUtil'
import { router } from '@kit.ArkUI'
import { UserInfo } from '../api/UserApi.type'

@Entry
@Component
export struct ChatPage {
  @State messages: ChatMessage[] = []
  @State userInput: string = ''
  @State isLoading: boolean = false
  @State error: string = ''
  @State userInfo: UserInfo = {
    id: 0,
    account: '',
    nickname: '',
    avatarUri: 'app.media.icon_mine_avatar'
  }
  @State isThinking: boolean = false

  aboutToAppear() {
    const params = AppStorage.get<UserInfo>('userInfo');

    if (params) {
      this.userInfo = {
        id: params.id,
        account: params.account,
        nickname: params.nickname,
        avatarUri: params.avatarUri
      }
    } else {
      // 未登录，设置默认头像资源
      this.userInfo.avatarUri = 'app.media.icon_mine_avatar'
    }
  }

  //  API Key
  private readonly apiKey: string = ''

  async send() {
    if (!this.userInput.trim()) {
      this.error = '请输入内容'
      return
    }

    this.error = ''
    this.isLoading = true
    this.isThinking = true  // 👈 开始思考

    // 添加用户消息
    this.messages = [...this.messages, {
      role: 'user',
      content: this.userInput.trim()
    }]

    try {
      const reply = await sendMessageToDeepSeek(this.messages, this.apiKey)

      // 添加助手回复
      this.messages = [...this.messages, {
        role: 'assistant',
        content: reply
      }]
    } catch (e) {
      this.error = '请求失败'
      // 添加错误提示消息（可选）
      this.messages = [...this.messages, {
        role: 'assistant',
        content: '出错了，请稍后再试'
      }]
    }

    this.userInput = ''
    this.isLoading = false
    this.isThinking = false  // 👈 结束思考
  }


  // 顶部导航栏构建函数
  @Builder
  TopBar() {
    Row() {
      Column() {
        Image($r('app.media.icpn_back_black'))// 返回图标
          .width(25)
          .height(25)
      }
      .width(50)
      .height(50)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        router.back(); // 返回上一页
      })

      Text("AI助手")// 显示标题
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })// 标题超出省略
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Column().width(50) // 占位列（右侧空位）
    }
    .width('100%')
    .height(50)
    .padding({ left: 5, right: 5 })
    .backgroundColor('#f8f9fa')
  }

  build() {
    Column() {
      this.TopBar()

      // ✅ 聊天框区域自适应高度
      Column() {
        Scroll() {
          Column() {
            ForEach(this.messages, (msg: ChatMessage, index: number) => {
              Row() {
                if (msg.role !== 'user') {
                  Image($r('app.media.app_icon'))
                    .width(40).height(40).borderRadius(20).margin({ right: 5 })
                }

                Text(msg.content)
                  .fontSize(18)
                  .backgroundColor(msg.role === 'user' ? '#D6EAF8' : '#F2F2F2')
                  .padding(10)
                  .borderRadius(6)
                  .constraintSize({ maxWidth: '72%' })

                if (msg.role === 'user') {
                  Image($r(this.userInfo.avatarUri))
                    .width(40).height(40).borderRadius(20).margin({ left: 5 })
                }
              }
              .width('100%')
              .justifyContent(msg.role === 'user' ? FlexAlign.End : FlexAlign.Start)
              .margin({ top: 5, bottom: 5 })
              .alignItems(VerticalAlign.Top)
            })
            // 👇渲染思考中状态
            if (this.isThinking) {
              Row() {
                Image($r('app.media.app_icon'))  // 固定助手头像
                  .width(40).height(40).borderRadius(20).margin({ right: 5 })

                Text('思考中...')
                  .fontSize(18)
                  .backgroundColor('#F2F2F2')
                  .padding(10)
                  .borderRadius(6)
                  .constraintSize({ maxWidth: '72%' })
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
      .layoutWeight(1) // ✅ 自动占满剩余高度，确保输入框有空间

      // 错误提示
      if (this.error) {
        Text(this.error)
          .fontColor(Color.Red)
          .margin({ top: 5, bottom: 5 })
      }

      // ✅ 输入框固定在底部
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
        .width('75%')

        Button(this.isLoading ? '发送中...' : '发送')
          .width('25%')
          .height(40)
          .enabled(!this.isLoading)
          .onClick(() => this.send())
      }

      .margin({ top: 10 })
    }
    .expandSafeArea([SafeAreaType.SYSTEM, SafeAreaType.KEYBOARD], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .padding({top: 10, bottom : 10, left : 10 , right : 10})
    .width('100%')
    .height('100%')
  }
}