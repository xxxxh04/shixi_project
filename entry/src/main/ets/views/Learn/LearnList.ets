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
  @State filteredList: ArticleContentData[] = [];
  @State isLoading: boolean = true;
  @State loadError: boolean = false;
  @State errorMessage: string = '';
  @State platformCategory: string = PlatformCategory.LEARNING;
  @State currentTabIndex: number = 1;
  @State selectedDifficulty: string = 'all';
  @State searchKeyword: string = '';

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
        this.filteredList = [...this.articleList];
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

  // 过滤文章
  private filterArticles(): void {
    if (this.selectedDifficulty === 'all' && this.searchKeyword === '') {
      this.filteredList = [...this.articleList];
      return;
    }

    this.filteredList = this.articleList.filter(article => {
      // 难度过滤
      const difficultyMatch = this.selectedDifficulty === 'all' || article.difficultyCategory === this.selectedDifficulty;

      // 搜索关键词过滤
      const keywordMatch = this.searchKeyword === '' ||
      article.title.toLowerCase().includes(this.searchKeyword.toLowerCase()) ||
      article.nickname.toLowerCase().includes(this.searchKeyword.toLowerCase());

      return difficultyMatch && keywordMatch;
    });
  }

  // 选择难度
  private selectDifficulty(difficulty: string): void {
    this.selectedDifficulty = difficulty;
    this.filterArticles();
  }

  // 处理搜索输入
  private onSearchInput(value: string): void {
    this.searchKeyword = value;
    this.filterArticles();
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
  SearchBar() {
    Row() {
      Search({ placeholder: '请输入关键字' })
        .placeholderFont({ size: 14 })
        .textFont({ size: 14 })
        .height(30);
    }
    .width('100%')
    .padding(10)
    .backgroundColor('#f8f9fa')
  }

  @Builder
  DifficultyFilter() {
    Row({ space: 10 }) {
      Button('全部', { type: ButtonType.Capsule, stateEffect: true })
        .width('20%')
        .backgroundColor(this.selectedDifficulty === 'all' ? '#1890ff' : '#ffffff')
        .fontColor(this.selectedDifficulty === 'all' ? '#ffffff' : '#666666')
        .onClick(() => this.selectDifficulty('all'))
        .fontWeight(FontWeight.Medium)

      Button('简单', { type: ButtonType.Capsule, stateEffect: true })
        .width('20%')
        .backgroundColor(this.selectedDifficulty === '1' ? '#52c41a' : '#ffffff')
        .fontColor(this.selectedDifficulty === '1' ? '#ffffff' : '#666666')
        .onClick(() => this.selectDifficulty('1'))
        .fontWeight(FontWeight.Medium)

      Button('中等', { type: ButtonType.Capsule, stateEffect: true })
        .width('20%')
        .backgroundColor(this.selectedDifficulty === '2' ? '#faad14' : '#ffffff')
        .fontColor(this.selectedDifficulty === '2' ? '#ffffff' : '#666666')
        .onClick(() => this.selectDifficulty('2'))
        .fontWeight(FontWeight.Medium)

      Button('困难', { type: ButtonType.Capsule, stateEffect: true })
        .width('20%')
        .backgroundColor(this.selectedDifficulty === '3' ? '#ff4d4f' : '#ffffff')
        .fontColor(this.selectedDifficulty === '3' ? '#ffffff' : '#666666')
        .onClick(() => this.selectDifficulty('3'))
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .padding({ left: 10, right: 10, bottom: 5 })
    .backgroundColor('#f8f9fa')
  }

  @Builder
  ArticleListItem(article: ArticleContentData) {
    Column({ space: 12 }) {
      // 标签和难度
      Row({ space: 8 }) {
        Text(this.getCategoryLabel(article.contentCategory))
          .fontSize(10)
          .padding({ top: 3, bottom: 3, left: 6, right: 6 })
          .backgroundColor('#e6f7ff')
          .borderRadius(6)
          .fontColor('#1890ff')

        Text(this.getDifficultyLabel(article.difficultyCategory))
          .fontSize(10)
          .padding({ top: 3, bottom: 3, left: 6, right: 6 })
          .backgroundColor(this.getDifficultyBackground(article.difficultyCategory))
          .fontColor(this.getDifficultyColor(article.difficultyCategory))
          .borderRadius(6)
      }
      .width('100%')
      .margin({ top: 5 })

      // 标题
      Text(article.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)
        .width('100%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      // 作者信息
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

      // 封面图
      if (article.coverUrl) {
        Image(article.coverUrl)
          .width('100%')
          .aspectRatio(2)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
          .margin({ top: 10 })
      }


    }
    .width('100%')
    .padding(15)
    .backgroundColor(Color.White)
    .borderRadius(12)
    .margin({ bottom: 15 })
    .shadow({ radius: 6, color: '#1a000000', offsetX: 1, offsetY: 1 })
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

  private getDifficultyBackground(difficulty: string): string {
    const backgrounds: Record<string, string> = {
      '1': '#f6ffed', '2': '#fffbe6', '3': '#fff1f0'
    };
    return backgrounds[difficulty] || '#f5f5f5';
  }

  private getDifficultyColor(difficulty: string): string {
    const colors: Record<string, string> = {
      '1': '#52c41a', '2': '#faad14', '3': '#ff4d4f'
    };
    return colors[difficulty] || '#666';
  }

  build() {
    Column() {
      this.TopBar()
      this.SearchBar()
      this.DifficultyFilter()

      Column() {
        if (this.isLoading && this.articleList.length === 0) {
          LoadingComponent().height('70%')
        } else if (this.loadError) {
          ErrorComponent({
            message: this.errorMessage,
            onRetry: () => this.loadAllArticles()
          })
        } else if (this.filteredList.length > 0) {
          List({ space: 10 }) {
            ForEach(
              this.filteredList,
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
              .width(150)
              .height(150)
              .objectFit(ImageFit.Contain)
            Text('没有找到相关内容')
              .fontSize(16)
              .margin({ top: 15 })
              .fontColor('#999')
            Button('重新加载', { type: ButtonType.Capsule })
              .width(120)
              .height(36)
              .margin({ top: 20 })
              .backgroundColor('#1890ff')
              .fontColor('#ffffff')
              .onClick(() => this.loadAllArticles())
          }
          .width('100%')
          .height('70%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
        }
      }
      .padding(15)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }
}