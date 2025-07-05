// utils/RequestUtil.ets
import http from '@ohos.net.http'

export interface ChatMessage {
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

/**
 * 调用 DeepSeek Chat API 发送多轮消息
 * @param messages 当前的对话消息历史
 * @param apiKey DeepSeek 的 API Key
 * @returns 模型返回的回复内容
 */
export async function sendMessageToDeepSeek(messages: ChatMessage[], apiKey: string): Promise<string> {
  const requestBody: ChatRequestBody = {
    model: 'deepseek-chat',
    messages,
    temperature: 0.7
  }

  const httpRequest = http.createHttp()
  try {
    const response = await httpRequest.request(
      'https://api.deepseek.com/v1/chat/completions',
      {
        method: http.RequestMethod.POST,
        header: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${apiKey}`, // 外部传入 API Key
        },
        extraData: requestBody,
        expectDataType: http.HttpDataType.OBJECT,
      }
    )

    const result = response.result as ChatResponse | undefined

    if (!result || !result.choices || result.choices.length === 0) {
      console.error('DeepSeek 返回无内容')
      return '（无返回内容）'
    }

    return result.choices[0].message.content
  } catch (error) {
    console.error('请求 DeepSeek 异常:', error)
    return '（请求失败，请检查网络或 API Key）'
  } finally {
    httpRequest.destroy()
  }
}
