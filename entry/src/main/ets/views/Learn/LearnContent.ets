// 引入所需模块
import router from '@ohos.router'; // 路由模块
import articleContentApi from '../../api/ArticleContentApi'; // 文章接口
import { ArticleContentData } from '../../api/ArticleContentApi.type'; // 文章数据类型
import { LoadingComponent } from '../../components/LoadingComponent'; // 加载组件
import { ErrorComponent } from '../../components/ErrorComponent'; // 错误组件
import { RouterConstant } from '../../contants/RouterConstant'; // 路由常量
import { LearnRichText } from '../../components/LearnRichText';

// 定义路由参数的类型
interface RouteParams {
  articleId: number; // 文章ID，必填
  pageTitle?: string; // 页面标题，可选
  platformCategory?: string; // 平台分类，可选
}

@Entry
@Component
struct LearnContent {
  @State pageTitle: string = '文章详情'; // 页面标题
  @State articleData: ArticleContentData | null = null; // 当前文章详情
  @State isLoading: boolean = true; // 是否加载中
  @State loadError: boolean = false; // 是否加载失败
  @State errorMessage: string = ''; // 错误信息
  @State platformCategory: string = '1'; // 平台分类，默认学习平台

  // 页面加载时触发
  aboutToAppear(): void {
    const params: RouteParams = router.getParams() as RouteParams; // 获取路由参数

    if (params.platformCategory) {
      this.platformCategory = params.platformCategory; // 设置平台分类
    }

    if (params.pageTitle) {
      this.pageTitle = params.pageTitle; // 设置标题
    }

    this.loadArticleDetail(params.articleId); // 加载文章详情
  }

  // 加载文章详情数据
  private loadArticleDetail(articleId: number): void {
    if (!articleId || articleId <= 0) {
      this.handleLoadError('无效的文章ID'); // ID 无效直接报错
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

        // 如果页面标题未设置，则用文章标题
        if (this.pageTitle === '文章详情') {
          this.pageTitle = data.title;
        }

        this.isLoading = false;
      })
      .catch((error: Error) => {
        this.handleLoadError(`加载失败: ${error.message || '未知错误'}`);
      });
  }

  // 加载失败时的处理逻辑
  private handleLoadError(message: string): void {
    this.isLoading = false;
    this.loadError = true;
    this.errorMessage = message;
  }

  // 顶部导航栏构建函数
  @Builder
  TopBar() {
    Row() {
      Column() {
        Image($r('app.media.icpn_back_black')) // 返回图标
          .width(25)
          .height(25)
      }
      .width(50)
      .height(50)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        router.back(); // 返回上一页
      })

      Text(this.pageTitle) // 显示标题
        .fontSize(18)
        .fontWeight(FontWeight.Medium)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis }) // 标题超出省略
        .layoutWeight(1)
        .textAlign(TextAlign.Center)

      Column().width(50) // 占位列（右侧空位）
    }
    .width('100%')
    .height(50)
    .padding({ left: 5, right: 5 })
    .backgroundColor('#f8f9fa')
  }

  // 文章详情顶部信息（标题、作者等）
  @Builder
  ArticleHeader() {
    if (this.articleData) {
      Column({ space: 12 }) {
        Text(this.articleData.title) // 文章标题
          .fontSize(22)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .width('100%')

        Row() {
          Image(this.articleData.avatarUri) // 作者头像
            .width(40)
            .height(40)
            .borderRadius(20)
            .objectFit(ImageFit.Cover)

          Column({ space: 4 }) {
            Text(this.articleData.nickname) // 昵称
              .fontSize(16)
              .fontWeight(FontWeight.Medium)
            Text(this.articleData.time) // 时间
              .fontSize(12)
              .fontColor('#666')
          }
          .margin({ left: 10 })
          .layoutWeight(1)

          Text(`${this.articleData.readCount}阅读`) // 阅读数
            .fontSize(12)
            .fontColor('#666')
        }
        .width('100%')
        .alignItems(VerticalAlign.Center)

        // 标签区域
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Start }) {
          Text(this.getCategoryLabel(this.articleData.contentCategory)) // 内容分类
            .fontSize(12)
            .padding(6)
            .backgroundColor('#e6f7ff')
            .borderRadius(10)
            .margin({ right: 8, bottom: 8 })

          Text(this.getDifficultyLabel(this.articleData.difficultyCategory)) // 难度
            .fontSize(12)
            .padding(6)
            .backgroundColor('#f6ffed')
            .borderRadius(10)
            .margin({ right: 8, bottom: 8 })

          Text(this.getPlatformLabel(this.articleData.platformCategory)) // 平台
            .fontSize(12)
            .padding(6)
            .backgroundColor('#fff2e8')
            .borderRadius(10)
            .margin({ bottom: 8 })
        }
        .width('100%')
        .margin({ top: 10 })

        // 封面图（如果有）
        if (this.articleData.coverUrl) {
          Image(this.articleData.coverUrl)
            .width('100%')
            .aspectRatio(2)
            .objectFit(ImageFit.Cover)
            .borderRadius(8)
            .margin({ top: 15 })
        }

        Divider() // 分割线
          .margin({ top: 15, bottom: 10 })

        // 点赞、收藏、分享
        Row({ space: 20 }) {
          Column() {
            Image(this.articleData.isLike ? $r('app.media.icon_like_selected') : $r('app.media.icon_like_default')) // 点赞图标
              .width(24)
              .height(24)
              .onClick(() => this.likeArticle()) // 点赞事件

            Text(`${this.articleData.likeCount}`) // 点赞数
              .fontSize(12)
              .fontColor(this.articleData.isLike ? '#ff4500' : '#666')
              .margin({ top: 4 })
          }

          Column() {
            Image(this.articleData.isCollect ? $r('app.media.icon_collect_selected') : $r('app.media.icon_collect_default')) // 收藏图标
              .width(24)
              .height(24)
              .onClick(() => this.collectArticle()) // 收藏事件

            Text(`${this.articleData.collectCount}`) // 收藏数
              .fontSize(12)
              .fontColor(this.articleData.isCollect ? '#ffc000' : '#666')
              .margin({ top: 4 })
          }

          Column() {
            Image($r('app.media.icon_mine_logout')) // 分享图标（待实现）
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

  // 正文内容区域
  @Builder
  ArticleContent() {
    if (this.articleData) {
      Column() {
        // Text(this.articleData.content) // 内容文本
        LearnRichText({ richTextContent: this.articleData.content })
          // .fontSize(16)
          // .lineHeight(24)
          // .textAlign(TextAlign.Start)
          // .width('100%')
      }
      .width('100%')
      .padding(16)
    }
  }

  // 点赞操作
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

  // 收藏操作
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

  // 内容分类标签转换
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

  // 页面主结构
  build() {
    Column() {
      this.TopBar() // 顶部栏

      Scroll() {
        Column() {
          if (this.isLoading) {
            LoadingComponent() // 加载中
              .height(300)
          } else if (this.loadError) {
            ErrorComponent({
              message: this.errorMessage,
              onRetry: () => {
                const params: RouteParams = router.getParams() as RouteParams;
                this.loadArticleDetail(params.articleId); // 重新加载
              }
            })
          } else if (this.articleData) {
            this.ArticleHeader() // 显示文章头部信息
            this.ArticleContent() // 显示文章内容
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
    .backgroundColor('#F5F5F5') // 页面背景色
  }
}
