import http from '../request/Request';
import {
  ArticleContentData,
  ArticleContentHotPageParam,
  ArticleContentNewPageParam,
  ArticleContentPageParam,
  PageVo
} from './ArticleContentApi.type';

class ArticleContentApi {
  pageListArticleContent(data: ArticleContentPageParam): Promise<PageVo<ArticleContentData>> {
    const queryParams: string[] = [];

    // 添加参数
    if (data.page !== undefined) queryParams.push(`page=${data.page}`);
    if (data.pageSize !== undefined) queryParams.push(`pageSize=${data.pageSize}`);
    if (data.title) queryParams.push(`title=${encodeURIComponent(data.title)}`);
    if (data.contentCategory) queryParams.push(`contentCategory=${encodeURIComponent(data.contentCategory)}`);
    if (data.platformCategory) queryParams.push(`platformCategory=${encodeURIComponent(data.platformCategory)}`);
    if (data.difficultyCategory) queryParams.push(`difficultyCategory=${encodeURIComponent(data.difficultyCategory)}`);

    const queryString = queryParams.length > 0 ? `?${queryParams.join('&')}` : '';

    return http.get(`/v1/article/page${queryString}`);
  }

  getArticleContentInfo(id: number): Promise<ArticleContentData> {
    if (!id || isNaN(id)) {
      return Promise.reject(new Error('无效的文章ID'));
    }
    console.log('请求文章详情 ID:', id);
    return http.get(`/v1/article/info?id=${id}`);
  }

  likeArticleContent(id: number): Promise<void> {
    return http.put(`/v1/article/like?id=${id}`);
  }

  collectArticleContent(id: number): Promise<void> {
    return http.put(`/v1/article/collect?id=${id}`);
  }

  getUserLike(): Promise<ArticleContentData[]> {
    return http.get('/v1/article/myLike');
  }

  getUserCollect(): Promise<ArticleContentData[]> {
    return http.get('/v1/article/myCollect');
  }

  getNewArticle(data: ArticleContentNewPageParam): Promise<PageVo<ArticleContentData>> {
    const queryParams: string[] = [];
    if (data.page !== undefined) queryParams.push(`page=${data.page}`);
    if (data.pageSize !== undefined) queryParams.push(`pageSize=${data.pageSize}`);
    if (data.title) queryParams.push(`title=${encodeURIComponent(data.title)}`);

    return http.get(`/v1/article/new?${queryParams.join('&')}`);
  }

  getHotArticle(data: ArticleContentHotPageParam): Promise<PageVo<ArticleContentData>> {
    const queryParams: string[] = [];
    if (data.page !== undefined) queryParams.push(`page=${data.page}`);
    if (data.pageSize !== undefined) queryParams.push(`pageSize=${data.pageSize}`);
    if (data.title) queryParams.push(`title=${encodeURIComponent(data.title)}`);

    return http.get(`/v1/article/hot?${queryParams.join('&')}`);
  }
}

const articleContentApi = new ArticleContentApi();
export default articleContentApi;