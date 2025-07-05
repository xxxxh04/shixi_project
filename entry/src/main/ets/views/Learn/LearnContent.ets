import router from '@ohos.router';
import articleContentApi from '../../api/ArticleContentApi';
import { ArticleContentData, ArticleContentPageParam } from '../../api/ArticleContentApi.type';
import { LoadingComponent } from '../../components/LoadingComponent';
import { ErrorComponent } from '../../components/ErrorComponent';
import { RouterConstant } from '../../contants/RouterConstant';

// 定义路由参数类型
type RouterParamValue = string | number | boolean | undefined;
type RouterParams = Record<string, RouterParamValue>;

@Entry
@Component
struct LearnContent {
  private readonly DEFAULT_PAGE_SIZE: number = 10;

  @State contentType: 'category' | 'detail' = 'category';
  @State contentCategory: number = 0;
  @State pageTitle: string = '学习内容';
  @State articleList: ArticleContentData[] = [];
  @State articleData: ArticleContentData | null = null;
  @State isLoading: boolean = true;
  @State loadError: boolean = false;
  @State errorMessage: string = '';
  @State currentPage: number = 1;
  @State hasMore: boolean = true;
  @State platformCategory: string = '1';

  aboutToAppear(): void {
    const params = router.getParams() as RouterParams;
    console.log('[DEBUG] LearnContent页面加载 - 路由参数:', JSON.stringify(params, null, 2));

    // 处理内容类型
    this.contentType = params['contentType'] === 'detail' ? 'detail' : 'category';
    console.log(`[DEBUG] 内容类型: ${this.contentType}`);

    // 处理平台分类
    this.platformCategory = this.validatePlatformCategory(params['platformCategory']?.toString());
    console.log(`[DEBUG] 平台分类: ${this.platformCategory}`);

    // 处理分类ID
    const categoryParam = params['contentCategory'];
    if (typeof categoryParam === 'string') {
      this.contentCategory = parseInt(categoryParam, 10) || 0;
    } else if (typeof categoryParam === 'number') {
      this.contentCategory = categoryParam;
    }
    console.log(`[DEBUG] 内容分类ID: ${this.contentCategory}`);

    // 处理页面标题
    const titleParam = params['pageTitle'];
    this.pageTitle = typeof titleParam === 'string' ? titleParam : '学习内容';
    console.log(`[DEBUG] 页面标题: ${this.pageTitle}`);

    // 根据参数类型加载内容
    if (this.contentType === 'category') {
      console.log('[DEBUG] 加载文章列表...');
      this.loadArticleList(1);
    } else {
      console.log('[DEBUG] 加载文章详情...');
      this.loadArticleDetail(params);
    }
  }

  // 验证平台分类参数
  private validatePlatformCategory(value?: string): string {
    if (value === '1' || value === '2') {
      return value;
    }
    console.warn(`[WARN] 无效的平台分类参数: ${value}, 使用默认值'1'`);
    return '1';
  }

  // 验证文章ID参数
  private validateArticleId(input: RouterParamValue): number | null {
    if (typeof input === 'number' && input > 0) {
      return input;
    }

    if (typeof input === 'string') {
      const id = parseInt(input.trim(), 10);
      if (!isNaN(id) && id > 0) {
        return id;
      }
    }

    console.error(`[ERROR] 无效的文章ID格式: ${input} (类型: ${typeof input})`);
    return null;
  }

  // 加载文章列表
  private loadArticleList(page: number = 1): void {
    if (!this.contentCategory) {
      this.handleLoadError('缺少内容分类参数');
      return;
    }

    this.isLoading = true;
    this.loadError = false;
    this.errorMessage = '';

    const params: ArticleContentPageParam = {
      page: page,
      pageSize: this.DEFAULT_PAGE_SIZE,
      contentCategory: this.contentCategory.toString(),
      platformCategory: this.platformCategory
    };

    console.log('[DEBUG] 请求文章列表参数:', JSON.stringify(params, null, 2));

    articleContentApi.pageListArticleContent(params)
      .then((pageData) => {
        console.log(`[DEBUG] 文章列表加载成功, 总数: ${pageData.total}, 当前页: ${pageData.records.length}`);

        // 检查文章ID有效性
        const invalidArticles = pageData.records.filter(article => !article.id || article.id <= 0);
        if (invalidArticles.length > 0) {
          console.warn(`[WARN] 发现${invalidArticles.length}篇文章ID无效`);
        }

        if (page === 1) {
          this.articleList = pageData.records;
        } else {
          this.articleList = [...this.articleList, ...pageData.records];
        }

        this.hasMore = pageData.total > this.articleList.length;
        this.currentPage = page;
        this.isLoading = false;
      })
      .catch((error: Error) => {
        console.error(`[ERROR] 文章列表加载失败: ${error.message}`);
        this.handleLoadError(`加载失败: ${error.message || '未知错误'}`);
      });
  }

  // 加载单篇文章详情
  private loadArticleDetail(params: RouterParams): void {
    this.isLoading = true;
    this.loadError = false;
    this.errorMessage = '';

    console.log('[DEBUG] 详情页参数:', JSON.stringify(params, null, 2));

    // 尝试从不同参数名获取文章ID
    const idSources = ['articleId', 'id', 'contentId', 'articleID'];
    let articleId: number | null = null;

    for (const key of idSources) {
      if (params[key] !== undefined) {
        console.log(`[DEBUG] 尝试从参数 ${key} 获取ID: ${params[key]}`);
        articleId = this.validateArticleId(params[key]);
        if (articleId) {
          console.log(`[DEBUG] 成功获取有效文章ID: ${articleId}`);
          break;
        }
      }
    }

    if (!articleId) {
      const errorMsg = `未获取到有效文章ID，参数: ${JSON.stringify(params)}`;
      console.error(`[ERROR] ${errorMsg}`);
      this.handleLoadError('文章ID参数错误或缺失');
      return;
    }

    console.log(`[DEBUG] 请求文章详情 ID: ${articleId}`);

    articleContentApi.getArticleContentInfo(articleId)
      .then((data: ArticleContentData) => {
        if (!data || !data.id) {
          throw new Error('API返回空数据或无效ID');
        }

        console.log(`[DEBUG] 文章详情加载成功 ID: ${data.id}, 标题: ${data.title}`);
        this.articleData = data;
        this.pageTitle = data.title;
        this.isLoading = false;
      })
      .catch((error: Error) => {
        console.error(`[ERROR] 文章详情加载失败 ID: ${articleId}: ${error.message}`);
        this.handleLoadError(`加载失败: ${error.message || '未知错误'}`);
      });
  }

  // 处理加载错误
  private handleLoadError(message: string): void {
    this.isLoading = false;
    this.loadError = true;
    this.errorMessage = message;
    console.error(`[ERROR] ${message}`);
  }

  // 点赞文章
  private likeArticle(): void {
    if (!this.articleData) {
      console.warn('[WARN] 点赞失败: 文章数据为空');
      return;
    }

    console.log(`[DEBUG] 点赞文章 ID: ${this.articleData.id}`);

    articleContentApi.likeArticleContent(this.articleData.id)
      .then(() => {
        console.log(`[DEBUG] 点赞成功 ID: ${this.articleData?.id}`);
        if (this.articleData) {
          this.articleData.isLike = !this.articleData.isLike;
          this.articleData.likeCount += this.articleData.isLike ? 1 : -1;
        }
      })
      .catch((error: Error) => {
        console.error(`[ERROR] 点赞失败 ID: ${this.articleData?.id}: ${error.message}`);
      });
  }

  // 收藏文章
  private collectArticle(): void {
    if (!this.articleData) {
      console.warn('[WARN] 收藏失败: 文章数据为空');
      return;
    }

    console.log(`[DEBUG] 收藏文章 ID: ${this.articleData.id}`);

    articleContentApi.collectArticleContent(this.articleData.id)
      .then(() => {
        console.log(`[DEBUG] 收藏成功 ID: ${this.articleData?.id}`);
        if (this.articleData) {
          this.articleData.isCollect = !this.articleData.isCollect;
          this.articleData.collectCount += this.articleData.isCollect ? 1 : -1;
        }
      })
      .catch((error: Error) => {
        console.error(`[ERROR] 收藏失败 ID: ${this.articleData?.id}: ${error.message}`);
      });
  }

  // 构建顶部导航栏
  @Builder
  TopBar(): void {
    Row() {
      Column() {
        Image($r('app.media.icon_back'))
          .width(25)
          .height(25)
      }
      .width(50)
      .height(50)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        console.log('[DEBUG] 返回上一页');
        router.back();
      })

      Text(this.pageTitle)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Column().width(50)
    }
    .width('100%')
    .height(50)
    .padding({ left: 5, right: 5 })
    .backgroundColor('#f8f9fa')
  }

  // 构建文章列表项
  @Builder
  ArticleListItem(article: ArticleContentData): void {
    Column({ space: 12 }) {
      Text(article.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
        .width('100%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      Row() {
        Image(article.avatarUri)
          .width(30)
          .height(30)
          .borderRadius(15)
          .objectFit(ImageFit.Cover)

        Column({ space: 4 }) {
          Text(article.nickname)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)

          Text(article.time)
            .fontSize(12)
            .fontColor('#666')
        }
        .margin({ left: 10 })
        .layoutWeight(1)

        Text(`${article.readCount}阅读`)
          .fontSize(12)
          .fontColor('#666')
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      Row({ space: 8 }) {
        Text(this.getCategoryLabel(article.contentCategory))
          .fontSize(10)
          .padding({ top: 3, bottom: 3, left: 6, right: 6 })
          .backgroundColor('#e6f7ff')
          .borderRadius(6)

        Text(this.getDifficultyLabel(article.difficultyCategory))
          .fontSize(10)
          .padding({ top: 3, bottom: 3, left: 6, right: 6 })
          .backgroundColor('#f6ffed')
          .borderRadius(6)
      }
      .width('100%')
      .margin({ top: 8 })

      if (article.coverUrl) {
        Image(article.coverUrl)
          .width('100%')
          .aspectRatio(2)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
          .margin({ top: 10 })
      }

      Divider()
        .margin({ top: 10, bottom: 5 })

      Row({ space: 20 }) {
        Column() {
          Image(article.isLike ? $r('app.media.icon_like_selected') : $r('app.media.icon_like_default'))
            .width(20)
            .height(20)

          Text(`${article.likeCount}`)
            .fontSize(12)
            .fontColor(article.isLike ? '#ff4500' : '#666')
            .margin({ top: 2 })
        }
        .onClick(() => this.likeArticleItem(article))

        Column() {
          Image(article.isCollect ? $r('app.media.icon_collect_selected') : $r('app.media.icon_collect_default'))
            .width(20)
            .height(20)

          Text(`${article.collectCount}`)
            .fontSize(12)
            .fontColor(article.isCollect ? '#ffc000' : '#666')
            .margin({ top: 2 })
        }
        .onClick(() => this.collectArticleItem(article))

        Column() {
          Image($r('app.media.Icon_app'))
            .width(20)
            .height(20)
          Text('评论')
            .fontSize(12)
            .fontColor('#666')
            .margin({ top: 2 })
        }
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .padding({ bottom: 5 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ bottom: 10 })
    .onClick(() => {
      console.log(`[DEBUG] 跳转到文章详情 ID: ${article.id}, 标题: ${article.title}`);

      if (!article.id || article.id <= 0) {
        console.error(`[ERROR] 无效的文章ID: ${article.id}, 无法跳转详情`);
        return;
      }

      router.pushUrl({
        url: RouterConstant.VIEWS_LEARN_CONTENT,
        params: {
          contentType: 'detail',
          articleId: article.id,
          pageTitle: article.title,
          platformCategory: this.platformCategory
        }
      }, (err) => {
        if (err) {
          console.error(`[ERROR] 路由跳转失败: ${err.code} - ${err.message}`);
        } else {
          console.log('[DEBUG] 路由跳转成功');
        }
      })
    })
  }

  // 文章详情头部
  @Builder
  ArticleHeader(): void {
    if (this.articleData) {
      Column({ space: 12 }) {
        Text(this.articleData.title)
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .width('100%')

        Row() {
          Image(this.articleData.avatarUri)
            .width(40)
            .height(40)
            .borderRadius(20)
            .objectFit(ImageFit.Cover)

          Column({ space: 4 }) {
            Text(this.articleData.nickname)
              .fontSize(16)
              .fontWeight(FontWeight.Medium)

            Text(this.articleData.time)
              .fontSize(12)
              .fontColor('#666')
          }
          .margin({ left: 10 })
          .layoutWeight(1)

          Text(`${this.articleData.readCount}阅读`)
            .fontSize(12)
            .fontColor('#666')
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
          Text(this.getCategoryLabel(this.articleData.contentCategory))
            .fontSize(12)
            .padding(6)
            .backgroundColor('#e6f7ff')
            .borderRadius(10)
            .margin({ right: 8, bottom: 8 })

          Text(this.getDifficultyLabel(this.articleData.difficultyCategory))
            .fontSize(12)
            .padding(6)
            .backgroundColor('#f6ffed')
            .borderRadius(10)
            .margin({ right: 8, bottom: 8 })

          Text(this.getPlatformLabel(this.articleData.platformCategory))
            .fontSize(12)
            .padding(6)
            .backgroundColor('#fff2e8')
            .borderRadius(10)
            .margin({ bottom: 8 })
        }
        .width('100%')
        .margin({ top: 10 })

        if (this.articleData.coverUrl) {
          Image(this.articleData.coverUrl)
            .width('100%')
            .aspectRatio(2)
            .objectFit(ImageFit.Cover)
            .borderRadius(8)
            .margin({ top: 15 })
        }

        Divider()
          .margin({ top: 15, bottom: 10 })

        Row({ space: 20 }) {
          Column() {
            Image(this.articleData.isLike ? $r('app.media.icon_like_selected') : $r('app.media.icon_like_default'))
              .width(24)
              .height(24)
              .onClick(() => this.likeArticle())

            Text(`${this.articleData.likeCount}`)
              .fontSize(12)
              .fontColor(this.articleData.isLike ? '#ff4500' : '#666')
              .margin({ top: 4 })
          }

          Column() {
            Image(this.articleData.isCollect ? $r('app.media.icon_collect_selected') : $r('app.media.icon_collect_default'))
              .width(24)
              .height(24)
              .onClick(() => this.collectArticle())

            Text(`${this.articleData.collectCount}`)
              .fontSize(12)
              .fontColor(this.articleData.isCollect ? '#ffc000' : '#666')
              .margin({ top: 4 })
          }

          Column() {
            Image($r('app.media.Icon_app'))
              .width(24)
              .height(24)
            Text('分享')
              .fontSize(12)
              .fontColor('#666')
              .margin({ top: 4 })
          }
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceAround)
        .padding({ bottom: 10 })
      }
      .width('100%')
      .padding(16)
    }
  }

  // 文章详情内容
  @Builder
  ArticleContent(): void {
    if (this.articleData) {
      Column() {
        Text(this.articleData.content)
          .fontSize(16)
          .lineHeight(24)
          .textAlign(TextAlign.Start)
          .width('100%')
      }
      .width('100%')
      .padding(16)
    }
  }

  // 构建加载更多按钮
  @Builder
  LoadMoreButton(): void {
    if (this.hasMore && !this.isLoading) {
      Button('加载更多', { type: ButtonType.Normal })
        .width(120)
        .height(40)
        .margin(10)
        .onClick(() => {
          console.log(`[DEBUG] 加载更多, 当前页: ${this.currentPage}`);
          this.loadArticleList(this.currentPage + 1);
        })
    } else if (this.isLoading) {
      LoadingComponent()
    } else if (!this.hasMore) {
      Text('没有更多内容了')
        .fontSize(14)
        .fontColor('#999')
        .margin(10)
    }
  }

  // 列表点赞处理
  private likeArticleItem(article: ArticleContentData): void {
    if (!article.id || article.id <= 0) {
      console.error(`[ERROR] 点赞失败: 无效文章ID ${article.id}`);
      return;
    }

    console.log(`[DEBUG] 点赞文章 ID: ${article.id}`);

    articleContentApi.likeArticleContent(article.id)
      .then(() => {
        console.log(`[DEBUG] 点赞成功 ID: ${article.id}`);
        const index = this.articleList.findIndex(item => item.id === article.id);
        if (index !== -1) {
          const updatedList = [...this.articleList];
          updatedList[index].isLike = !updatedList[index].isLike;
          updatedList[index].likeCount += updatedList[index].isLike ? 1 : -1;
          this.articleList = updatedList;
        }
      })
      .catch((error: Error) => {
        console.error(`[ERROR] 点赞失败 ID: ${article.id}: ${error.message}`);
      });
  }

  // 列表收藏处理
  private collectArticleItem(article: ArticleContentData): void {
    if (!article.id || article.id <= 0) {
      console.error(`[ERROR] 收藏失败: 无效文章ID ${article.id}`);
      return;
    }

    console.log(`[DEBUG] 收藏文章 ID: ${article.id}`);

    articleContentApi.collectArticleContent(article.id)
      .then(() => {
        console.log(`[DEBUG] 收藏成功 ID: ${article.id}`);
        const index = this.articleList.findIndex(item => item.id === article.id);
        if (index !== -1) {
          const updatedList = [...this.articleList];
          updatedList[index].isCollect = !updatedList[index].isCollect;
          updatedList[index].collectCount += updatedList[index].isCollect ? 1 : -1;
          this.articleList = updatedList;
        }
      })
      .catch((error: Error) => {
        console.error(`[ERROR] 收藏失败 ID: ${article.id}: ${error.message}`);
      });
  }

  // 分类标签转换
  private getCategoryLabel(category: string): string {
    const categories: Record<string, string> = {
      '1': '鸿蒙',
      '2': 'Java',
      '3': 'Web',
      '4': '运维'
    };
    return categories[category] || '未知分类';
  }

  // 难度标签转换
  private getDifficultyLabel(difficulty: string): string {
    const difficulties: Record<string, string> = {
      '1': '简单',
      '2': '中等',
      '3': '困难'
    };
    return difficulties[difficulty] || '未知难度';
  }

  // 平台标签转换
  private getPlatformLabel(platform: string): string {
    const platforms: Record<string, string> = {
      '1': '学习平台',
      '2': '面试题'
    };
    return platforms[platform] || '未知平台';
  }

  build() {
    Column() {
      // 导航栏
      this.TopBar()

      // 内容区域
      if (this.contentType === 'category') {
        this.BuildListContent()
      } else {
        this.BuildDetailContent()
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  BuildListContent(): void {
    Column() {
      if (this.isLoading && this.articleList.length === 0) {
        LoadingComponent()
          .height('80%')
      } else if (this.loadError) {
        ErrorComponent({
          message: this.errorMessage,
          onRetry: () => {
            console.log('[DEBUG] 重试加载文章列表');
            this.loadArticleList(1);
          }
        })
      } else if (this.articleList.length > 0) {
        List({ space: 10 }) {
          ForEach(this.articleList, (item: ArticleContentData) => {
            ListItem() {
              this.ArticleListItem(item)
            }
          })
        }
        .width('100%')
        .layoutWeight(1)
        .divider({ strokeWidth: 1, color: '#f0f0f0' })

        this.LoadMoreButton()
      } else {
        Column() {
          Image($r('app.media.error'))
            .width(100)
            .height(100)
          Text('暂无内容')
            .fontSize(16)
            .margin({ top: 15 })
            .onClick(() => {
              console.log('[DEBUG] 重试加载文章列表');
              this.loadArticleList(1);
            })
        }
        .width('100%')
        .height('80%')
        .justifyContent(FlexAlign.Center)
        .alignItems(HorizontalAlign.Center)
      }
    }
    .padding(10)
    .layoutWeight(1)
  }

  @Builder
  BuildDetailContent(): void {
    Scroll() {
      Column() {
        if (this.isLoading) {
          LoadingComponent()
            .height(300)
        } else if (this.loadError) {
          ErrorComponent({
            message: this.errorMessage,
            onRetry: () => {
              console.log('[DEBUG] 重试加载文章详情');
              this.loadArticleDetail(router.getParams() as RouterParams);
            }
          })
        } else if (this.articleData) {
          this.ArticleHeader()
          this.ArticleContent()
        }
      }
    }
    .scrollable(ScrollDirection.Vertical)
    .scrollBar(BarState.On)
    .scrollBarColor(Color.Gray)
    .scrollBarWidth(6)
    .edgeEffect(EdgeEffect.Spring)
    .layoutWeight(1)
  }
}