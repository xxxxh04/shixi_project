import { CommonConstant } from '../../contants/CommonConstant'
import { ArticleContentData } from '../../api/ArticleContentApi.type'
import { ArticleComponent } from '../../components/ArticleComponent'
import { router } from '@kit.ArkUI'
import { RouterConstant } from '../../contants/RouterConstant'
import { LoadingComponent } from '../../components/LoadingComponent'
import articleContentApi from '../../api/ArticleContentApi'
import { showToast } from '../../utils/Toast'

@Entry
@Component
export struct MineCollect {
  @State collectList: ArticleContentData[] = []
  @State isLoading: boolean = true

  async aboutToAppear() {
    await this.loadCollectList()
  }

  /**
   * 加载我的收藏
   */
  private async loadCollectList() {
    this.isLoading = true
    try {
      const res = await articleContentApi.getUserCollect()
      this.collectList = res
    } catch (error) {
      console.error('加载收藏失败:', JSON.stringify(error))
    } finally {
      this.isLoading = false
    }
  }

  build() {
    Navigation() {
      Column() {
        Text('只保留当前最近的100条')
          .fontSize(15)
          .fontColor(Color.Gray)
          .width('100%')
          .padding(10)

        if (this.isLoading) {
          // 加载中
          Text('加载中...')
            .fontSize(16)
            .fontColor('#999')
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 50 })
        } else if (this.collectList.length === 0) {
          // 空态
          Text('暂无收藏')
            .fontSize(16)
            .fontColor('#999')
            .width('100%')
            .textAlign(TextAlign.Center)
            .margin({ top: 50 })
        } else {
          // 列表
          List() {
            ForEach(this.collectList, (item: ArticleContentData) => {
              ListItem() {
                ArticleComponent({ articleContentData: item })
                  .onClick(() => {
                    // 路由到内容详情页
                    router.pushUrl({
                      url: RouterConstant.VIEWS_HOME_ARTICLE_INFO, params: {
                        "articleId": item.id
                      }
                    })
                  })
              }
            })
          }
          .width('100%')
        }
      }
    }
    .title('我的收藏')
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .hideBackButton(false)
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
  }
}
