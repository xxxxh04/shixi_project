import router from '@ohos.router';
import articleContentApi from '../../api/ArticleContentApi';
import { ArticleContentData } from '../../api/ArticleContentApi.type';
import { LearnRichText } from '../../components/LearnRichText';
import { showToast } from '../../utils/Toast';


interface RouterParams {
  articleId: number
}

@Entry
@Component
export struct ArticleInfo {



  @State articleData: ArticleContentData = {
    id: 0,
    avatarUri: '',
    nickname: '',
    title: '',
    content: '',
    readCount: 0,
    likeCount: 0,
    collectCount: 0,
    coverUrl: '',
    contentCategory: '',
    platformCategory: '',
    difficultyCategory: '',
    isLike: false,
    isCollect: false,
    time: ''
  }

  async aboutToAppear() {
    const params = router.getParams() as RouterParams;
    const articleId = params.articleId;
    if (articleId) {
      const res = await articleContentApi.getArticleContentInfo(articleId);
      this.articleData = res;
    }
  }

  @Builder AuthorInfo() {
    Row() {
      Image(this.articleData.avatarUri)
        .width(40)
        .height(40)
        .margin({ right: 10 })
        .borderRadius(20)
      Text(this.articleData.nickname)
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .padding({ bottom: 8 })
  }

  // 点赞切换处理
  async toggleLike() {
    if (!this.articleData.id) return;

    try {
      // 调用接口
      await articleContentApi.likeArticleContent(this.articleData.id);

      // 本地切换状态和数量
      this.articleData.isLike = !this.articleData.isLike;
      this.articleData.likeCount += this.articleData.isLike ? 1 : -1;
    } catch (error) {
      // 失败了可以提示用户，或者恢复状态
      showToast('点赞失败，请重试');
    }
  }

  // 收藏切换处理
  async toggleCollect() {
    if (!this.articleData.id) return;

    try {
      await articleContentApi.collectArticleContent(this.articleData.id);

      this.articleData.isCollect = !this.articleData.isCollect;
      this.articleData.collectCount += this.articleData.isCollect ? 1 : -1;
    } catch (error) {
      showToast('收藏失败，请重试');
    }
  }

  @Builder StatsInfo() {
    Row() {
      Row() {
        Text(`${this.articleData.readCount} 阅读 |`).fontSize(10)
        Text(`${this.articleData.likeCount} 喜欢 |`).fontSize(10)
        Text(`${this.articleData.collectCount} 收藏 | `).fontSize(10)
        Text(`${this.articleData.time} |`).fontSize(10)
        Text('鸿蒙 | 基础知识') // 如有分类字段可替换
          .fontSize(10)
          .fontColor('#1a73e8')
      }
      .layoutWeight(1)

      Row() {
        Image(this.articleData.isLike ? $r('app.media.icon_like_selected') : $r('app.media.icon_like_default'))
          .width(18)
          .height(18)
          .margin({ right: 10 })
          .onClick(() => {
            this.toggleLike();
          })

        Image(this.articleData.isCollect ? $r('app.media.icon_collect_selected') : $r('app.media.icon_collect_default'))
          .width(18)
          .height(18)
          .onClick(() => {
            this.toggleCollect();
          })
      }
    }
    .width('100%')
    .padding({ bottom: 15 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Column() {
      // 顶部标题栏
      Row({ space: 10 }) {
        Image($r('app.media.icpn_back_black'))
          .width(30)
          .height(30)
          .onClick(() => {
            router.back()
          })

        Text('内容详情')
          .fontColor($r('app.color.text_color'))
          .fontWeight(FontWeight.Bold)
          .fontSize(22)
          .layoutWeight(1)
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .padding({ bottom: 20, top: 10 })

      // 标题 + 作者 + 时间/分类 + 点赞收藏
      Column() {
        Text(this.articleData.title)
          .fontColor($r('app.color.text_color'))
          .width('100%')
          .fontWeight(FontWeight.Bold)
          .fontSize(18)
          .padding({ bottom: 10 })

        this.AuthorInfo()
        this.StatsInfo()
      }
      .width('100%')
      .padding({ left: 15, right: 15 })
      .border({
        width: { bottom: 1 },
        color: { bottom: 'app.color.text_color' }
      })

      // 正文内容
      Scroll() {
        Column({ space: 20 }) {
          LearnRichText({ richTextContent: this.articleData.content })
          // .fontSize(16)
          // .lineHeight(24)
          // .textAlign(TextAlign.Start)
          // .padding({ bottom: 30 })
        }
        .width('100%')
        .padding(20)
      }
      .scrollable(ScrollDirection.Vertical)
      .scrollBar(BarState.On)
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
    .padding({ left: 15, right: 15 })
    .backgroundColor($r('app.color.background_color'))
  }
}
