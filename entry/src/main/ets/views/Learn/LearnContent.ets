import router from '@ohos.router';
import articleContentApi from '../../api/ArticleContentApi';
import { ArticleContentData } from '../../api/ArticleContentApi.type';
import { LoadingComponent } from '../../components/LoadingComponent';
import { ErrorComponent } from '../../components/ErrorComponent';
import { RouterConstant } from '../../contants/RouterConstant';

// 定义路由参数接口
interface RouteParams {
  articleId: number; // 明确定义为数字类型
  pageTitle?: string;
  platformCategory?: string;
}

@Entry
@Component
struct LearnContent {
  @State pageTitle: string = '文章详情';
  @State articleData: ArticleContentData | null = null;
  @State isLoading: boolean = true;
  @State loadError: boolean = false;
  @State errorMessage: string = '';
  @State platformCategory: string = '1';

  aboutToAppear(): void {
    const params: RouteParams = router.getParams() as RouteParams;

    // 处理平台分类
    if (params.platformCategory) {
      this.platformCategory = params.platformCategory;
    }

    // 处理页面标题
    if (params.pageTitle) {
      this.pageTitle = params.pageTitle;
    }

    // 加载文章详情
    this.loadArticleDetail(params.articleId);
  }

  // 加载单篇文章详情
  private loadArticleDetail(articleId: number): void {
    // 验证ID有效性
    if (!articleId || articleId <= 0) {
      this.handleLoadError('无效的文章ID');
      return;
    }

    this.isLoading = true;
    this.loadError = false;
    this.errorMessage = '';

    articleContentApi.getArticleContentInfo(articleId)
      .then((data: ArticleContentData) => {
        if (!data || !data.id) {
          throw new Error('API返回空数据');
        }

        this.articleData = data;

        // 更新页面标题
        if (this.pageTitle === '文章详情') {
          this.pageTitle = data.title;
        }

        this.isLoading = false;
      })
      .catch((error: Error) => {
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

  // 文章详情头部
  @Builder
  ArticleHeader() {
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
            Image($r('app.media.icon_mine_logout'))
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
  ArticleContent() {
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

  // 点赞文章
  private likeArticle(): void {
    if (!this.articleData) return;

    articleContentApi.likeArticleContent(this.articleData.id)
      .then(() => {
        if (this.articleData) {
          this.articleData.isLike = !this.articleData.isLike;
          this.articleData.likeCount += this.articleData.isLike ? 1 : -1;
        }
      })
  }

  // 收藏文章
  private collectArticle(): void {
    if (!this.articleData) return;

    articleContentApi.collectArticleContent(this.articleData.id)
      .then(() => {
        if (this.articleData) {
          this.articleData.isCollect = !this.articleData.isCollect;
          this.articleData.collectCount += this.articleData.isCollect ? 1 : -1;
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
      Scroll() {
        Column() {
          if (this.isLoading) {
            LoadingComponent()
              .height(300)
          } else if (this.loadError) {
            ErrorComponent({
              message: this.errorMessage,
              onRetry: () => {
                const params: RouteParams = router.getParams() as RouteParams;
                this.loadArticleDetail(params.articleId);
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
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}