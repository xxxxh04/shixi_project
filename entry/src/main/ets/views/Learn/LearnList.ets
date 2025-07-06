// 引入路由、接口、组件和常量
import router from '@ohos.router';
import articleContentApi from '../../api/ArticleContentApi';
import { ArticleContentData, ArticleContentPageParam, PlatformCategory } from '../../api/ArticleContentApi.type';
import { LoadingComponent } from '../../components/LoadingComponent';
import { ErrorComponent } from '../../components/ErrorComponent';
import { RouterConstant } from '../../contants/RouterConstant';

// 路由参数类型声明
interface RouteParams {
  contentCategory?: string;      // 文章内容分类
  pageTitle?: string;            // 页面标题
  platformCategory?: string;     // 平台分类（学习/面试）
  currentTabIndex?: number;      // 当前Tab页索引
}

@Entry
@Component
struct LearnList {
  // 页面状态变量
  @State contentCategory: string = '';                      // 当前内容分类
  @State pageTitle: string = '学习内容';                    // 页面顶部标题
  @State articleList: ArticleContentData[] = [];            // 加载的文章数据
  @State isLoading: boolean = true;                         // 是否加载中
  @State loadError: boolean = false;                        // 是否加载失败
  @State errorMessage: string = '';                         // 错误提示信息
  @State platformCategory: string = PlatformCategory.LEARNING; // 平台分类
  @State currentTabIndex: number = 1;                       // 当前 tab 索引

  // 页面加载时执行逻辑
  aboutToAppear(): void {
    const params = router.getParams() as RouteParams;
    console.log('[DEBUG] LearnList页面参数: ' + JSON.stringify(params));

    // 验证并设置平台分类参数
    if (params.platformCategory &&
      (params.platformCategory === PlatformCategory.LEARNING ||
        params.platformCategory === PlatformCategory.INTERVIEW)) {
      this.platformCategory = params.platformCategory;
    } else {
      console.warn('无效的平台分类参数，使用默认值');
      this.platformCategory = PlatformCategory.LEARNING;
    }

    // 设置内容分类、标题和 Tab 索引
    this.contentCategory = params.contentCategory || '';
    this.pageTitle = params.pageTitle || '学习内容';
    if (params.currentTabIndex !== undefined) {
      this.currentTabIndex = params.currentTabIndex;
    }

    console.log(`[DEBUG] 平台分类: ${this.platformCategory}, 内容分类: ${this.contentCategory}`);

    // 拉取文章数据
    this.loadAllArticles();
  }

  // 加载所有文章数据
  private loadAllArticles(): void {
    this.isLoading = true;
    this.loadError = false;
    this.errorMessage = '';

    const params: ArticleContentPageParam = {
      page: 1,
      pageSize: 100, // 一次获取足够多的数据
      contentCategory: this.contentCategory,
      platformCategory: this.platformCategory
    };

    console.log('[DEBUG] 请求所有文章数据: ' + JSON.stringify(params));

    articleContentApi.pageListArticleContent(params)
      .then((pageData) => {
        console.log(`[DEBUG] 加载成功, 总数: ${pageData.total}`);
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

  // 顶部导航栏构建
  @Builder
  TopBar() {
    Row() {
      // 左侧返回按钮
      Column() {
        Image($r('app.media.icpn_back_black'))
          .width(25)
          .height(25)
      }
      .width(50)
      .height(50)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        router.back(); // 返回上一页
      })

      // 标题文字
      Text(this.pageTitle)
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      // 占位区（右侧空列）
      Column().width(50)
    }
    .width('100%')
    .height(50)
    .padding({ left: 5, right: 5 })
    .backgroundColor('#f8f9fa')
  }

  // 文章列表项构建
  @Builder
  ArticleListItem(article: ArticleContentData) {
    Column({ space: 12 }) {
      // 文章标题
      Text(article.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
        .width('100%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      // 用户信息 + 阅读数
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

      // 分类和难度标签
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

      // 文章封面（可选）
      if (article.coverUrl) {
        Image(article.coverUrl)
          .width('100%')
          .aspectRatio(2)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
          .margin({ top: 10 })
      }

      Divider().margin({ top: 10, bottom: 5 })

      // 点赞、收藏、评论按钮
      Row({ space: 20 }) {
        // 点赞
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

        // 收藏
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

        // 评论
        Column() {
          Image($r('app.media.Icon_app')).width(20).height(20)
          Text('评论').fontSize(12).fontColor('#666').margin({ top: 2 })
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
      // 点击跳转到详情页
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

  // 点赞接口处理逻辑（含失败回滚）
  private likeArticleItem(article: ArticleContentData): void {
    // 安全检查
    if (!article.id) return;

    // 找到索引
    const index = this.articleList.findIndex(item => item.id === article.id);
    if (index === -1) return;

    // 状态预更新：先切换本地状态，提升响应速度
    const updatedList = [...this.articleList];
    const oldLikeStatus = updatedList[index].isLike;
    const oldLikeCount = updatedList[index].likeCount;

    updatedList[index].isLike = !oldLikeStatus;
    updatedList[index].likeCount += updatedList[index].isLike ? 1 : -1;
    this.articleList = updatedList;

    // 发起接口请求
    articleContentApi.likeArticleContent(article.id)
      .then(() => {
        console.log(`[UI] 点赞请求成功，文章ID: ${article.id}`);
      })
      .catch((err: Error) => {
        console.error(`[UI-ERROR] 点赞失败: ${err.message}`);

        // 回滚状态
        updatedList[index].isLike = oldLikeStatus;
        updatedList[index].likeCount = oldLikeCount;
        this.articleList = updatedList;
      });
  }


  // 收藏接口处理逻辑（含失败回滚）
  private collectArticleItem(article: ArticleContentData): void {
    // 检查ID合法性
    if (!article.id) return;

    // 找到索引
    const index = this.articleList.findIndex(item => item.id === article.id);
    if (index === -1) return;

    // 状态预更新
    const updatedList = [...this.articleList];
    const oldCollectStatus = updatedList[index].isCollect;
    const oldCollectCount = updatedList[index].collectCount;

    updatedList[index].isCollect = !oldCollectStatus;
    updatedList[index].collectCount += updatedList[index].isCollect ? 1 : -1;
    this.articleList = updatedList;

    // 发起收藏请求
    articleContentApi.collectArticleContent(article.id)
      .then(() => {
        console.log(`[UI] 收藏请求成功，文章ID: ${article.id}`);
      })
      .catch((err: Error) => {
        console.error(`[UI-ERROR] 收藏失败: ${err.message}`);

        // 回滚状态
        updatedList[index].isCollect = oldCollectStatus;
        updatedList[index].collectCount = oldCollectCount;
        this.articleList = updatedList;
      });
  }


  // 获取分类标签名称
  private getCategoryLabel(category: string): string {
    const categories: Record<string, string> = {
      '1': '鸿蒙', '2': 'Java', '3': 'Web', '4': '运维'
    };
    return categories[category] || '未知分类';
  }

  // 获取难度标签名称
  private getDifficultyLabel(difficulty: string): string {
    const difficulties: Record<string, string> = {
      '1': '简单', '2': '中等', '3': '困难'
    };
    return difficulties[difficulty] || '未知难度';
  }

  // 页面UI渲染
  build() {
    Column() {
      this.TopBar() // 顶部导航栏

      Column() {
        if (this.isLoading && this.articleList.length === 0) {
          // 加载中组件
          LoadingComponent().height('80%')
        } else if (this.loadError) {
          // 加载失败组件
          ErrorComponent({
            message: this.errorMessage,
            onRetry: () => this.loadAllArticles()
          })
        } else if (this.articleList.length > 0) {
          // 渲染文章列表
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
          // 空状态提示
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
