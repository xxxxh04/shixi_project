import http from '../request/Request';
import {
  ArticleContentData,
  ArticleContentHotPageParam,
  ArticleContentNewPageParam,
  ArticleContentPageParam,
  PageVo
} from './ArticleContentApi.type';

class ArticleContentApi {
  /**
   * 获取文章分页列表（支持按标题、分类等条件筛选）
   * @param data - 分页和筛选参数（page, pageSize, title, contentCategory 等）
   * @returns 分页结果（文章列表）
   */
  pageListArticleContent(data: ArticleContentPageParam): Promise<PageVo<ArticleContentData>> {
    const queryParams: string[] = [];

    if (data.page !== undefined) queryParams.push(`page=${data.page}`);
    if (data.pageSize !== undefined) queryParams.push(`pageSize=${data.pageSize}`);
    if (data.title) queryParams.push(`title=${encodeURIComponent(data.title)}`);

    // 确保所有分类参数转为字符串
    if (data.contentCategory !== undefined && data.contentCategory !== null) {
      queryParams.push(`contentCategory=${String(data.contentCategory)}`);
    }
    if (data.platformCategory !== undefined && data.platformCategory !== null) {
      queryParams.push(`platformCategory=${String(data.platformCategory)}`);
    }
    if (data.difficultyCategory !== undefined && data.difficultyCategory !== null) {
      queryParams.push(`difficultyCategory=${String(data.difficultyCategory)}`);
    }

    const queryString = queryParams.length > 0 ? `?${queryParams.join('&')}` : '';

    // 添加调试日志
    console.log(`[API] 请求文章列表: /v1/article/page${queryString}`);

    return http.get(`/v1/article/page${queryString}`);
  }

  /**
   * 获取指定文章的详细信息
   * @param id - 文章 ID（允许0值）
   * @returns 文章详情数据
   */
  getArticleContentInfo(id: number): Promise<ArticleContentData> {
    // 放宽验证 - 只拒绝无效数字
    if (id === undefined || id === null || isNaN(id)) {
      const errorMsg = `无效的文章ID: ${id} (类型: ${typeof id})`;
      console.error(`[API-ERROR] ${errorMsg}`);
      return Promise.reject(new Error(errorMsg));
    }

    // 添加调试日志
    console.log(`[API] 请求文章详情 ID: ${id}`);
    return http.get(`/v1/article/info?id=${id}`);
  }

  /**
   * 点赞指定文章
   * @param id - 文章 ID
   * @returns 无返回值（成功/失败）
   */
  likeArticleContent(id: number): Promise<void> {
    // 添加验证和日志
    if (id === undefined || id === null || isNaN(id)) {
      console.error(`[API-ERROR] 点赞失败: 无效文章ID ${id}`);
      return Promise.reject(new Error('无效的文章ID'));
    }

    console.log(`[API] 点赞文章 ID: ${id}`);
    return http.put(`/v1/article/like?id=${id}`);
  }

  /**
   * 收藏指定文章
   * @param id - 文章 ID
   * @returns 无返回值（成功/失败）
   */
  collectArticleContent(id: number): Promise<void> {
    // 添加验证和日志
    if (id === undefined || id === null || isNaN(id)) {
      console.error(`[API-ERROR] 收藏失败: 无效文章ID ${id}`);
      return Promise.reject(new Error('无效的文章ID'));
    }

    console.log(`[API] 收藏文章 ID: ${id}`);
    return http.put(`/v1/article/collect?id=${id}`);
  }

  /**
   * 获取当前用户点赞过的文章列表
   * @returns 文章数据数组
   */
  getUserLike(): Promise<ArticleContentData[]> {
    console.log('[API] 请求用户点赞文章列表');
    return http.get('/v1/article/myLike');
  }

  /**
   * 获取当前用户收藏的文章列表
   * @returns 文章数据数组
   */
  getUserCollect(): Promise<ArticleContentData[]> {
    console.log('[API] 请求用户收藏文章列表');
    return http.get('/v1/article/myCollect');
  }

  /**
   * 获取最新发布的文章分页列表
   * @param data - 分页参数和可选标题筛选
   * @returns 分页结果（最新文章列表）
   */
  getNewArticle(data: ArticleContentNewPageParam): Promise<PageVo<ArticleContentData>> {
    const queryParams: string[] = [];
    if (data.page !== undefined) queryParams.push(`page=${data.page}`);
    if (data.pageSize !== undefined) queryParams.push(`pageSize=${data.pageSize}`);
    if (data.title) queryParams.push(`title=${encodeURIComponent(data.title)}`);

    const queryString = queryParams.length > 0 ? `?${queryParams.join('&')}` : '';

    console.log(`[API] 请求最新文章: /v1/article/new${queryString}`);
    return http.get(`/v1/article/new${queryString}`);
  }

  /**
   * 获取最热门的文章分页列表
   * @param data - 分页参数和可选标题筛选
   * @returns 分页结果（热门文章列表）
   */
  getHotArticle(data: ArticleContentHotPageParam): Promise<PageVo<ArticleContentData>> {
    const queryParams: string[] = [];
    if (data.page !== undefined) queryParams.push(`page=${data.page}`);
    if (data.pageSize !== undefined) queryParams.push(`pageSize=${data.pageSize}`);
    if (data.title) queryParams.push(`title=${encodeURIComponent(data.title)}`);

    const queryString = queryParams.length > 0 ? `?${queryParams.join('&')}` : '';

    console.log(`[API] 请求热门文章: /v1/article/hot${queryString}`);
    return http.get(`/v1/article/hot${queryString}`);
  }
}

// 单例导出文章内容 API 实例
const articleContentApi = new ArticleContentApi();
export default articleContentApi;