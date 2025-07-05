// pages/ChatPage.ets
import { sendMessageToDeepSeek, ChatMessage } from '../utils/RequestUtil'

@Entry
@Component
export struct ChatPage {
  @State messages: ChatMessage[] = []
  @State userInput: string = ''
  @State isLoading: boolean = false
  @State error: string = ''

  // ✅ 替换为你的实际 API Key（可以改成常量或配置项）
  private readonly apiKey: string = 'sk-72c98ee8ef8647368e2a30f65fdc0d46'

  async send() {
    if (!this.userInput.trim()) {
      this.error = '请输入内容'
      return
    }

    this.error = ''
    this.isLoading = true

    // 添加用户消息
    this.messages = [...this.messages, {
      role: 'user',
      content: this.userInput.trim()
    }]

    const reply = await sendMessageToDeepSeek(this.messages, this.apiKey)

    // 添加助手回复
    this.messages = [...this.messages, {
      role: 'assistant',
      content: reply
    }]

    this.userInput = ''
    this.isLoading = false
  }

  build() {
    Column() {
      Scroll() {
        Column() {
          ForEach(this.messages, (msg: ChatMessage, index: number) => {
            Text(`${msg.role === 'user' ? '你' : '助手'}：${msg.content}`)
              .fontSize(15)
              .backgroundColor(msg.role === 'user' ? '#D6EAF8' : '#F2F2F2')
              .textAlign(msg.role === 'user' ? TextAlign.End : TextAlign.Start)
              .padding(10)
              .margin({ top: 5, bottom: 5 })
              .borderRadius(6)
          })
        }
        .padding(10)
      }
      .height(450)

      if (this.error) {
        Text(this.error)
          .fontColor(Color.Red)
          .margin({ top: 5, bottom: 5 })
      }

      Row({ space: 6 }) {
        // 自定义 placeholder 效果
        Stack() {
          TextInput({ text: this.userInput })
            .width('100%')
            .height(40)
            .padding({ left: 10 })
            .border({ width: 1, color: '#BBB', radius: 8 })
            .onChange((value: string) => this.userInput = value)

          if (!this.userInput) {
            Text('请输入内容...')
              .position({ left: 14, top: 10 })
              .fontColor('#888')
              .fontSize(14)
          }
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
    .padding(16)
    .width('100%')
    .height('100%')
  }
}
