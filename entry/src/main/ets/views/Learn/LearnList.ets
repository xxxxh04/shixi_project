import router from '@ohos.router';
import articleContentApi from '../../api/ArticleContentApi';
import { ArticleContentData, ArticleContentPageParam, PlatformCategory } from '../../api/ArticleContentApi.type';
import { LoadingComponent } from '../../components/LoadingComponent';
import { ErrorComponent } from '../../components/ErrorComponent';
import { RouterConstant } from '../../contants/RouterConstant';

// 定义路由参数接口
interface RouteParams {
  contentCategory?: string;
  pageTitle?: string;
  platformCategory?: string;
  currentTabIndex?: number;
}

@Entry
@Component
struct LearnList {
  // 移除分页相关状态变量
  @State contentCategory: string = '';
  @State pageTitle: string = '学习内容';
  @State articleList: ArticleContentData[] = [];
  @State isLoading: boolean = true;
  @State loadError: boolean = false;
  @State errorMessage: string = '';
  @State platformCategory: string = PlatformCategory.LEARNING;
  @State currentTabIndex: number = 1;

  aboutToAppear(): void {
    const params = router.getParams() as RouteParams;
    console.log('[DEBUG] LearnList页面参数: ' + JSON.stringify(params));

    // 处理平台分类
    if (params.platformCategory &&
      (params.platformCategory === PlatformCategory.LEARNING ||
        params.platformCategory === PlatformCategory.INTERVIEW)) {
      this.platformCategory = params.platformCategory;
    } else {
      console.warn('无效的平台分类参数，使用默认值');
      this.platformCategory = PlatformCategory.LEARNING;
    }

    // 处理内容分类
    this.contentCategory = params.contentCategory || '';

    // 处理页面标题
    this.pageTitle = params.pageTitle || '学习内容';

    // 处理Tab索引
    if (params.currentTabIndex !== undefined) {
      this.currentTabIndex = params.currentTabIndex;
    }

    console.log(`[DEBUG] 平台分类: ${this.platformCategory}, 内容分类: ${this.contentCategory}`);

    // 加载所有文章数据
    this.loadAllArticles();
  }

  // 加载所有文章数据（不分页）
  private loadAllArticles(): void {
    this.isLoading = true;
    this.loadError = false;
    this.errorMessage = '';

    // 设置一个较大的 pageSize 一次性获取所有数据
    const params: ArticleContentPageParam = {
      page: 1,
      pageSize: 100, // 设置足够大的值获取所有数据
      contentCategory: this.contentCategory,
      platformCategory: this.platformCategory
    };

    console.log('[DEBUG] 请求所有文章数据: ' + JSON.stringify(params));

    articleContentApi.pageListArticleContent(params)
      .then((pageData) => {
        console.log(`[DEBUG] 加载成功, 总数: ${pageData.total}`);

        // 直接设置所有文章数据
        this.articleList = pageData.records;
        this.isLoading = false;
      })
      .catch((error: Error) => {
        console.error(`[ERROR] 加载失败: ${error.message}`);
        this.handleLoadError(`加载失败: ${error.message || '未知错误'}`);
      });
  }

  // 处理加载错误
  private handleLoadError(message: string): void {
    this.isLoading = false;
    this.loadError = true;
    this.errorMessage = message;
  }

  // 构建顶部导航栏
  @Builder
  TopBar() {
    Row() {
      Column() {
        Image($r('app.media.icpn_back_black'))
          .width(25)
          .height(25)
      }
      .width(50)
      .height(50)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
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
  ArticleListItem(article: ArticleContentData) {
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
      router.pushUrl({
        url: RouterConstant.VIEWS_LEARN_CONTENT,
        params: {
          contentType: 'detail',
          articleId: article.id,
          pageTitle: article.title,
          platformCategory: this.platformCategory,
          currentTabIndex: this.currentTabIndex
        }
      })
    })
  }

  // 列表点赞处理
  private likeArticleItem(article: ArticleContentData): void {
    if (!article.id) return;

    articleContentApi.likeArticleContent(article.id)
      .then(() => {
        const index = this.articleList.findIndex(item => item.id === article.id);
        if (index !== -1) {
          const updatedList = [...this.articleList];
          updatedList[index].isLike = !updatedList[index].isLike;
          updatedList[index].likeCount += updatedList[index].isLike ? 1 : -1;
          this.articleList = updatedList;
        }
      })
  }

  // 列表收藏处理
  private collectArticleItem(article: ArticleContentData): void {
    if (!article.id) return;

    articleContentApi.collectArticleContent(article.id)
      .then(() => {
        const index = this.articleList.findIndex(item => item.id === article.id);
        if (index !== -1) {
          const updatedList = [...this.articleList];
          updatedList[index].isCollect = !updatedList[index].isCollect;
          updatedList[index].collectCount += updatedList[index].isCollect ? 1 : -1;
          this.articleList = updatedList;
        }
      })
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

  build() {
    Column() {
      // 导航栏
      this.TopBar()

      // 内容区域
      Column() {
        if (this.isLoading && this.articleList.length === 0) {
          LoadingComponent()
            .height('80%')
        } else if (this.loadError) {
          ErrorComponent({
            message: this.errorMessage,
            onRetry: () => {
              this.loadAllArticles();
            }
          })
        } else if (this.articleList.length > 0) {
          // 列表区域 - 移除分页相关组件
          List({ space: 10 }) {
            ForEach(
              this.articleList,
              (item: ArticleContentData) => {
                ListItem() {
                  this.ArticleListItem(item)
                }
              },
              (item: ArticleContentData) => item.id.toString()
            )
          }
          .width('100%')
          .layoutWeight(1)
          .divider({ strokeWidth: 1, color: '#f0f0f0' })
        } else {
          Column() {
            Image($r('app.media.error'))
              .width(100)
              .height(100)
            Text('暂无内容')
              .fontSize(16)
              .margin({ top: 15 })
              .onClick(() => {
                this.loadAllArticles();
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
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}