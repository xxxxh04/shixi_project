import router from '@ohos.router';
import articleContentApi from '../../api/ArticleContentApi';
import { ArticleContentData, ArticleContentPageParam, PlatformCategory } from '../../api/ArticleContentApi.type';
import { LoadingComponent } from '../../components/LoadingComponent';
import { ErrorComponent } from '../../components/ErrorComponent';
import { RouterConstant } from '../../contants/RouterConstant';

interface RouteParams {
  contentCategory?: string;
  pageTitle?: string;
  platformCategory?: string;
  currentTabIndex?: number;
}

@Entry
@Component
struct LearnList {
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

    if (params.platformCategory &&
      (params.platformCategory === PlatformCategory.LEARNING ||
        params.platformCategory === PlatformCategory.INTERVIEW)) {
      this.platformCategory = params.platformCategory;
    }

    this.contentCategory = params.contentCategory || '';
    this.pageTitle = params.pageTitle || '学习内容';
    if (params.currentTabIndex !== undefined) {
      this.currentTabIndex = params.currentTabIndex;
    }

    this.loadAllArticles();
  }

  private loadAllArticles(): void {
    this.isLoading = true;
    this.loadError = false;
    this.errorMessage = '';

    const params: ArticleContentPageParam = {
      page: 1,
      pageSize: 100,
      contentCategory: this.contentCategory,
      platformCategory: this.platformCategory
    };

    articleContentApi.pageListArticleContent(params)
      .then((pageData) => {
        this.articleList = pageData.records;
        this.isLoading = false;
      })
      .catch((error: Error) => {
        this.handleLoadError(`加载失败: ${error.message || '未知错误'}`);
      });
  }

  private handleLoadError(message: string): void {
    this.isLoading = false;
    this.loadError = true;
    this.errorMessage = message;
  }

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
          Text(article.nickname).fontSize(14).fontWeight(FontWeight.Medium)
          Text(article.time).fontSize(12).fontColor('#666')
        }
        .margin({ left: 10 })
        .layoutWeight(1)

        Text(`${article.readCount}阅读`).fontSize(12).fontColor('#666')
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

      // 已删除点赞/收藏/评论功能栏和对应的Divider
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

  private getCategoryLabel(category: string): string {
    const categories: Record<string, string> = {
      '1': '鸿蒙', '2': 'Java', '3': 'Web', '4': '运维'
    };
    return categories[category] || '未知分类';
  }

  private getDifficultyLabel(difficulty: string): string {
    const difficulties: Record<string, string> = {
      '1': '简单', '2': '中等', '3': '困难'
    };
    return difficulties[difficulty] || '未知难度';
  }

  build() {
    Column() {
      this.TopBar()

      Column() {
        if (this.isLoading && this.articleList.length === 0) {
          LoadingComponent().height('80%')
        } else if (this.loadError) {
          ErrorComponent({
            message: this.errorMessage,
            onRetry: () => this.loadAllArticles()
          })
        } else if (this.articleList.length > 0) {
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
            Image($r('app.media.error')).width(100).height(100)
            Text('暂无内容').fontSize(16).margin({ top: 15 })
              .onClick(() => this.loadAllArticles())
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