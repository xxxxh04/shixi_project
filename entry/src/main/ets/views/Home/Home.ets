import { router } from '@kit.ArkUI';
import { RouterConstant } from '../../contants/RouterConstant';
import { CommonConstant } from '../../contants/CommonConstant';
import { ArticleComponent } from '../../components/ArticleComponent';
import { LoadingComponent } from '../../components/LoadingComponent';
import articleContentApi from '../../api/ArticleContentApi';
import { ArticleContentData } from '../../api/ArticleContentApi.type';
import { showToast } from '../../utils/Toast';

@Entry
@Component
export struct Home {
  // 顶部标签控制
  @State newDividerShow: boolean = true;
  @State hotDividerShow: boolean = false;

  // 搜索关键字
  @State keyword: string = '';
  @State title: string = '';

  // 数据相关
  @State articleContentList: ArticleContentData[] = [];
  @State total: number = 0;
  @State page: number = 1;
  @State pageSize: number = 7;
  @State isShow: boolean = false;
  @State isRefreshing: boolean = false;
  isLoad: boolean = false;
  @State textShow: boolean = false;

  /**
   * 生命周期：页面首次进入时加载最新数据
   */
  async aboutToAppear() {
    await this.getArticleNewDataList(true, false);
  }

  /**
   * 查询最新文章数据
   */
  async getArticleNewDataList(isFlushed: boolean, isUpdate: boolean) {
    const res = await articleContentApi.getNewArticle({
      page: this.page,
      pageSize: this.pageSize,
      title: this.title
    });

    if (isFlushed) {
      this.articleContentList = res.records;
    } else {
      this.articleContentList.push(...res.records);
    }

    this.total = res.total;
    this.textShow = !(this.total > this.page * this.pageSize);
    this.isShow = true;
    this.isLoad = false;
    this.isRefreshing = false;

    if (isUpdate) {
      showToast('已更新');
    }
  }

  /**
   * 查询最热门文章数据
   */
  async getArticleHotDataList(isFlushed: boolean, isUpdate: boolean) {
    const res = await articleContentApi.getHotArticle({
      page: this.page,
      pageSize: this.pageSize,
      title: this.title
    });

    if (isFlushed) {
      this.articleContentList = res.records;
    } else {
      this.articleContentList.push(...res.records);
    }

    this.total = res.total;
    this.textShow = !(this.total > this.page * this.pageSize);
    this.isShow = true;
    this.isLoad = false;
    this.isRefreshing = false;

    if (isUpdate) {
      showToast('已更新');
    }
  }

  /**
   * 根据当前标签决定加载哪个数据源
   */
  async getArticleDataList(isFlushed: boolean) {
    if (this.newDividerShow) {
      await this.getArticleNewDataList(isFlushed, true);
    } else if (this.hotDividerShow) {
      await this.getArticleHotDataList(isFlushed, true);
    }
  }

  build() {
    Column() {
      // 顶部标签栏
      Row({ space: 10 }) {
        Column() {
          Text('最新').textStyles();
          if (this.newDividerShow) {
            Divider().dividerStyles();
          }
        }.onClick(() => {
          this.newDividerShow = true;
          this.hotDividerShow = false;
          this.page = 1;
          this.isShow = false;
          this.getArticleNewDataList(true, true);
        });

        Column() {
          Text('热门').textStyles();
          if (this.hotDividerShow) {
            Divider().dividerStyles();
          }
        }.onClick(() => {
          this.newDividerShow = false;
          this.hotDividerShow = true;
          this.page = 1;
          this.isShow = false;
          this.getArticleHotDataList(true, true);
        });
      }
      .justifyContent(FlexAlign.Start)
      .margin({ top: 10, bottom: 20 })
      .width(CommonConstant.WIDTH_FULL);

      // 搜索框
      Search({ placeholder: '请输入关键字', value: $$this.keyword })
        .placeholderFont({ size: 14 })
        .textFont({ size: 14 })
        .onSubmit(() => {
          this.title = encodeURIComponent(this.keyword);
          this.page = 1;
          this.isShow = false;
          this.getArticleDataList(true);
        })
        .width(CommonConstant.WIDTH_FULL)
        .height(30);

      // 列表或加载中
      if (this.isShow) {
        Refresh({ refreshing: $$this.isRefreshing }) {
          List() {
            ForEach(this.articleContentList, (item: ArticleContentData) => {
              ListItem() {
                ArticleComponent({ articleContentData: item })
                  .onClick(() => {
                    router.pushUrl({
                      url: RouterConstant.VIEWS_HOME_ARTICLE_INFO,
                      params: { articleId: item.id }
                    });
                  });
              }
            });

            if (this.textShow) {
              ListItem() {
                Text('没有更多了')
                  .fontColor('#999')
                  .fontSize(14)
                  .width(CommonConstant.WIDTH_FULL)
                  .textAlign(TextAlign.Center)
                  .margin({ top: 50 });
              }
            }
          }
          .width(CommonConstant.WIDTH_FULL)
          .height(CommonConstant.HEIGHT_FULL)
          .scrollBar(BarState.Off)
          .onReachEnd(() => {
            if (!this.isLoad && this.total > this.page * this.pageSize) {
              this.isLoad = true;
              this.page++;
              this.getArticleDataList(false);
            } else {
              this.textShow = true;
            }
          });
        }
        .onRefreshing(() => {
          if (!this.isLoad) {
            this.isLoad = true;
            this.textShow = false;
            this.page = 1;
            this.getArticleDataList(true);
          }
        });
      } else {
        LoadingComponent();
      }
    }
    .padding($r('app.float.common_padding'))
    .width(CommonConstant.WIDTH_FULL)
    .height(CommonConstant.HEIGHT_FULL);
  }
}

// 样式扩展
@Extend(Text)
function textStyles() {
  .fontSize(20)
  .fontWeight(FontWeight.Medium);
}

@Extend(Divider)
function dividerStyles() {
  .color('#000')
  .width(20)
  .strokeWidth(3);
}
