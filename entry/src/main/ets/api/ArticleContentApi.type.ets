/**
 * 通用的时间字段接口，用于记录创建和更新时间
 */
export interface BaseTime {
  /** 创建时间 */
  createTime?: Date;
  /** 最后更新时间 */
  updateTime?: Date;
}

/**
 * 分页请求参数基类
 */
export interface PageParam {
  /** 当前页码，从1开始 */
  page?: number;
  /** 每页条数 */
  pageSize?: number;
}

/**
 * 分页响应结构
 * @template T 返回的数据类型
 */
export interface PageVo<T> {
  /** 当前页码 */
  current: number;
  /** 每页数据条数 */
  size: number;
  /** 总数据条数 */
  total: number;
  /** 当前页的数据列表 */
  records: T[];
}

/**
 * 获取文章分页列表的查询参数
 */
export interface ArticleContentPageParam extends PageParam {
  /** 文章标题（模糊匹配） */
  title?: string;
  /** 内容分类，例如“面试”、“项目”等 */
  contentCategory?: string;
  /** 平台分类，例如“Android”、“HarmonyOS”等 */
  platformCategory?: string;
  /** 难度分类，例如“入门”、“进阶”、“高阶” */
  difficultyCategory?: string;
}

/**
 * 获取最新文章的分页参数
 */
export interface ArticleContentNewPageParam extends PageParam {
  /** 文章标题（模糊搜索） */
  title: string;
}

/**
 * 获取热门文章的分页参数
 */
export interface ArticleContentHotPageParam extends PageParam {
  /** 文章标题（模糊搜索） */
  title: string;
}

/**
 * 文章内容的完整数据结构
 */
export interface ArticleContentData extends BaseTime {
  /** 文章唯一 ID */
  id: number;
  /** 用户头像地址 */
  avatarUri: string;
  /** 用户昵称 */
  nickname: string;
  /** 文章标题 */
  title: string;
  /** 文章内容（富文本或 Markdown 渲染后的 HTML） */
  content: string;
  /** 阅读次数 */
  readCount: number;
  /** 点赞数量 */
  likeCount: number;
  /** 收藏数量 */
  collectCount: number;
  /** 文章封面图 URL */
  coverUrl: string;
  /** 内容分类（如：项目实战/面试经验等） */
  contentCategory: string;
  /** 平台分类（如：HarmonyOS/Android/iOS） */
  platformCategory: string;
  /** 难度分类（如：入门/进阶/高阶） */
  difficultyCategory: string;
  /** 当前用户是否已点赞 */
  isLike: boolean;
  /** 当前用户是否已收藏 */
  isCollect: boolean;
  /** 发布时间字符串（格式化后的时间，比如“2小时前”） */
  time: string;
}
