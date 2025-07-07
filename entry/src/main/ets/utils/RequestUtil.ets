// 引入 OpenHarmony 提供的 HTTP 网络模块
import http from '@ohos.net.http'

// 定义对话消息的结构体，每条消息包含角色和内容
export interface ChatMessage {
  role: 'system' | 'user' | 'assistant' // 消息发送者角色
  content: string                        // 消息内容
  duration?: number;
}

// 定义发送给 DeepSeek 接口的请求体结构
interface ChatRequestBody {
  model: string                         // 使用的模型名称（例如 deepseek-chat）
  messages: ChatMessage[]              // 当前的对话消息列表（包括上下文）
  temperature?: number                 // 模型回复的随机性（越高越发散）
}

// 定义模型返回的单条对话选择结构
interface ChatChoice {
  message: ChatMessage                 // 模型回复的一条消息
}

// 定义完整的 API 响应结构
interface ChatResponse {
  choices: ChatChoice[]               // 模型返回的多个选项（通常只取第一个）
}

/**
 * 调用 DeepSeek Chat API 发送多轮消息
 * @param messages 当前的对话消息历史（包含用户和助手的多轮交互）
 * @param apiKey DeepSeek 的 API Key（用于鉴权）
 * @returns 模型返回的回复内容（字符串）
 */
export async function sendMessageToDeepSeek(messages: ChatMessage[], apiKey: string): Promise<string> {
  // 构建请求体对象
  const requestBody: ChatRequestBody = {
    model: 'deepseek-chat',           // 使用 DeepSeek 的聊天模型
    messages,                         // 携带全部对话历史，实现多轮对话
    temperature: 0.7                  // 回复的多样性设置为中等
  }

  // 创建 HTTP 请求实例（每次使用后需要销毁）
  const httpRequest = http.createHttp()

  try {
    // 发起 POST 请求到 DeepSeek API 接口
    const response = await httpRequest.request(
      'https://api.deepseek.com/v1/chat/completions', // DeepSeek API 地址
      {
        method: http.RequestMethod.POST,              // 使用 POST 方法
        header: {
          'Content-Type': 'application/json',         // 设置请求体格式为 JSON
          'Authorization': `Bearer ${apiKey}`,        // 携带 Bearer Token 做鉴权
        },
        extraData: requestBody,                       // 请求体数据
        expectDataType: http.HttpDataType.OBJECT,     // 期望返回的是对象格式
      }
    )

    // 将响应结果强转为我们定义的结构（ChatResponse）
    const result = response.result as ChatResponse | undefined

    // 判空校验：若无返回或没有 choices，则提示无内容
    if (!result || !result.choices || result.choices.length === 0) {
      console.error('DeepSeek 返回无内容')  // 打印错误日志
      return '（无返回内容）'                 // 返回默认提示
    }

    // 返回第一条模型回复的内容
    return result.choices[0].message.content
  } catch (error) {
    // 捕获请求过程中的异常，例如网络错误、鉴权失败等
    console.error('请求 DeepSeek 异常:', error)
    return '（请求失败，请检查网络或 API Key）'
  } finally {
    // 释放 HTTP 请求资源，防止内存泄漏
    httpRequest.destroy()
  }
}
