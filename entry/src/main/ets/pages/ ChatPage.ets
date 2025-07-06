// pages/ChatPage.ets
import { sendMessageToDeepSeek, ChatMessage } from '../utils/RequestUtil'

@Entry
@Component
export struct ChatPage {
  @State messages: ChatMessage[] = []
  @State userInput: string = ''
  @State isLoading: boolean = false
  @State error: string = ''

  //  API Key
  private readonly apiKey: string = ''

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
            // 每条消息一行
            Row()            {
              // 条件渲染：助手消息头像在左
              if (msg.role !== 'user') {
                Image($r('app.media.learn_img'))
                  .width(40)
                  .height(40)
                  .borderRadius(20)
                  .margin({ right: 5 }) // 留出气泡间距

              }

              // 消息气泡
              Text(`${msg.content}`)
                .fontSize(18)
                .backgroundColor(msg.role === 'user' ? '#D6EAF8' : '#F2F2F2')
                .padding(10)
                .borderRadius(6)
                .constraintSize({ maxWidth: '72%' })

              // 条件渲染：用户消息头像在右
              if (msg.role === 'user') {
                Image($r('app.media.learn_img'))
                  .width(40)
                  .height(40)
                  .borderRadius(20)
                  .margin({ left: 5 })
              }
            }
              .width('100%')
              .justifyContent(
                msg.role === 'user' ? FlexAlign.End : FlexAlign.Start
              )
              .margin({ top: 5, bottom: 5 })
            .alignItems(VerticalAlign.Top) // 👈 关键代码，让头像和消息框顶部对齐
          })
        }

        .padding(10)
      }
      .height('80%')

      if (this.error) {
        Text(this.error)
          .fontColor(Color.Red)
          .margin({ top: 5, bottom: 5 })
      }

      Row({ space: 6 }) {
        // 自定义 placeholder 效果
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
    .padding(16)
    .width('100%')
    .height('100%')
  }
}
