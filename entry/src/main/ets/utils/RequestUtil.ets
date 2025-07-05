import http from '@ohos.net.http'

interface ChatMessage {
  role: 'system' | 'user' | 'assistant'
  content: string
}

interface ChatRequestBody {
  model: string
  messages: ChatMessage[]
  temperature?: number
}

interface ChatChoice {
  message: ChatMessage
}

interface ChatResponse {
  choices: ChatChoice[]
}
//连接deepseekAPI
export async function chatWithDeepSeek(userMessage: string): Promise<string> {
  const requestBody: ChatRequestBody = {
    model: 'deepseek-chat',
    messages: [
      { role: 'system', content: 'You are a helpful assistant.' },
      { role: 'user', content: userMessage }
    ],
    temperature: 0.7,
  }

  const httpRequest = http.createHttp()
  try {
    const response = await httpRequest.request(
      'https://api.deepseek.com/v1/chat/completions',
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer sk-ff5f28872a6a4dad8a714fe045874140',  // 替换成你的API Key
        },
        extraData: requestBody,
        expectDataType: http.HttpDataType.OBJECT,
      }
    )

    // 打印完整响应对象方便调试
    console.info('完整响应:', response)

    const result = response.result as ChatResponse | undefined

    if (!result || !result.choices) {
      console.error('接口返回格式异常，缺少 choices 字段')
      return '无返回内容'
    }

    if (result.choices.length > 0) {
      return result.choices[0].message.content
    }
    return '无返回内容'
  } catch (err) {
    console.error('请求 DeepSeek 失败，错误详情:', err)
    if (err instanceof Error) {
      console.error('错误消息:', err.message)
      console.error('错误堆栈:', err.stack)
    }
    return '请求失败'
  } finally {
    httpRequest.destroy()
  }
}
