export interface BaseTime {
  createTime?: Date;
  updateTime?: Date;
}

export interface PageParam {
  page?: number;
  pageSize?: number;
}

export interface PageVo<T> {
  current: number;
  size: number;
  total: number;
  records: T[];
}

export interface ArticleContentPageParam extends PageParam {
  title?: string;
  contentCategory?: string;
  platformCategory?: string;
  difficultyCategory?: string;
}

export interface ArticleContentNewPageParam extends PageParam {
  title: string;
}

export interface ArticleContentHotPageParam extends PageParam {
  title: string;
}

export interface ArticleContentData extends BaseTime {
  id: number;
  avatarUri: string;
  nickname: string;
  title: string;
  content: string;
  readCount: number;
  likeCount: number;
  collectCount: number;
  coverUrl: string;
  contentCategory: string;
  platformCategory: string;
  difficultyCategory: string;
  isLike: boolean;
  isCollect: boolean;
  time: string;
}