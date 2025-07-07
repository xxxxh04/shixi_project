import { router } from '@kit.ArkUI';
import { RouterConstant } from '../../contants/RouterConstant';
import { CommonConstant } from '../../contants/CommonConstant';
import { ArticleComponent } from '../../components/ArticleComponent';
import { LoadingComponent } from '../../components/LoadingComponent';
import articleContentApi from '../../api/ArticleContentApi';
import { ArticleContentData } from '../../api/ArticleContentApi.type';
import { showToast } from '../../utils/Toast';
import { IBestFloatBubble } from "@ibestservices/ibest-ui";
import { IBestInit } from "@ibestservices/ibest-ui"
import { window } from '@kit.ArkUI'
import { UIAbility } from '@kit.AbilityKit'


// export default class EntryAbility extends UIAbility {
//   onWindowStageCreate(windowStage: window.WindowStage) {
//     windowStage.loadContent('pages/Index', (err, data) => {
//
//     })
//   }
// }


// @Entry
@Component
export struct Home {
  @State isShow_2:boolean = false
  // 顶部“最新”标签是否选中
  @State newDividerShow: boolean = true;
  // 顶部“热门”标签是否选中
  @State hotDividerShow: boolean = false;

  // 搜索关键字双向绑定
  @State keyword: string = '';
  // 实际用于接口请求的标题（通过 encodeURIComponent 处理）
  @State title: string = '';

  // 文章列表数据
  @State articleContentList: ArticleContentData[] = [];
  // 文章总数
  @State total: number = 0;
  // 当前页码
  @State page: number = 1;
  // 每页条数
  @State pageSize: number = 7;
  // 列表是否显示
  @State isShow: boolean = false;
  // 是否正在下拉刷新
  @State isRefreshing: boolean = false;
  // 是否正在加载更多
  isLoad: boolean = false;
  // 是否显示“没有更多”文本
  @State textShow: boolean = false;

  /**
   * 生命周期：页面首次进入时加载最新数据
   */
  async aboutToAppear() {
    await this.getArticleNewDataList(true, false);
    setTimeout(()=>{
      this.isShow_2 = true
    },500)
  }

  aboutToDisappear(): void {
    this.isShow_2 = false
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
    // 列表可见
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
    // 列表可见
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
    Stack() {
      // 1. 主内容区
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
            // 渲染文章列表
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
                    .fontColor($r('app.color.text_color'))
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

      // 2. AI浮窗
      IBestFloatBubble({
        show: this.isShow_2,
        icon: $r('app.media.app_icon'),  // 图标资源
        iconSize: 120,
        pos: { right: 40, top: 40 },
        bgColor: '#198cff',
        bubbleSize: 48,
        isMagnetic: true,
        dragAxis:"xy",
        bubbleShadow: {
          radius: 12,
          color: '#aaa2',
          offsetX: 0,
          offsetY: 4
        },
        onBubbleClick: () => {
          this.isShow_2 = false
          router.pushUrl({ url: 'pages/ ChatPage' })
        }
      })
    }
  }
}

// 样式扩展
@Extend(Text)
function textStyles() {
  .fontColor($r('app.color.text_color'))
  .fontSize(20)
  .fontWeight(FontWeight.Medium);
}

@Extend(Divider)
function dividerStyles() {
  .color($r('app.color.text_color'))
  .width(20)
  .strokeWidth(3);
}
