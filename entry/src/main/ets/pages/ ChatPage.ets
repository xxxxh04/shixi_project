import { chatWithDeepSeek } from '../utils/RequestUtil'
//测试ai对话
@Entry
@Component
struct ChatPage {
  @State inputText: string = ''
  @State outputText: string = '你好，我是DeepSeek助手！'

  async sendMessage() {
    const reply = await chatWithDeepSeek(this.inputText)
    this.outputText = reply
  }

  build() {
    Column() {
      Text(this.outputText)
        .fontSize(20)
        .padding(10)

      TextInput({ placeholder: '输入你的问题' })
        .onChange((value: string) => {
          this.inputText = value
        })
        .margin({ top: 20 })

      Button('发送')
        .onClick(() => {
          this.sendMessage()
        })
        .margin({ top: 10 })
    }
    .padding(20)
  }
}
