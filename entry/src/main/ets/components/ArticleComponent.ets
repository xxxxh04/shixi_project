import type { ArticleContentData } from '../api/ArticleContentApi.type'
import router from '@ohos.router'

/**
 * 工具函数：根据分类编号返回中文标签
 */
function getContentLabel(category: string): string {
  switch (category) {
    case '1': return '鸿蒙'
    case '2': return 'Java'
    case '3': return 'Web'
    case '4': return '运维'
    default: return '未知'
  }
}
/**
 * 工具函数：根据难度编号返回中文标签
 */
function getDifficultyLabel(difficulty: string): string {
  switch (difficulty) {
    case '1': return '简单'
    case '2': return '中等'
    case '3': return '困难'
    default: return '未知'
  }
}

@Component
export struct ArticleComponent {
  @Prop articleContentData: ArticleContentData

  build() {
    Column({ space: 12 }) {
      // 文章标题
      Text(this.articleContentData.title)
        .fontSize(18)
        .fontWeight(FontWeight.Bold)
        .width('100%')
        .maxLines(2)
        .textOverflow({ overflow: TextOverflow.Ellipsis })

      // 用户信息和阅读数
      Row() {
        Image(this.articleContentData.avatarUri)
          .width(30)
          .height(30)
          .borderRadius(15)
        Column() {
          Text(this.articleContentData.nickname)
            .fontSize(14)
            .fontWeight(FontWeight.Medium)
          Text(this.articleContentData.time)
            .fontSize(12)
            .fontColor('#666')
        }
        .margin({ left: 10 })
        .layoutWeight(1)
        Text(`${this.articleContentData.readCount ?? 0}阅读`)
          .fontSize(12)
          .fontColor('#666')
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)

      // 分类和难度标签 靠左显示
      Row({ space: 8 }) {
        Text(getContentLabel(this.articleContentData.contentCategory))
          .fontSize(12)
          .fontColor('#333')
          .padding({ top: 3, bottom: 3, left: 12, right: 12 })
          .backgroundColor('#e6f7ff')
          .borderRadius(12)
        Text(getDifficultyLabel(this.articleContentData.difficultyCategory))
          .fontSize(12)
          .fontColor('#333')
          .padding({ top: 3, bottom: 3, left: 12, right: 12 })
          .backgroundColor('#f6ffed')
          .borderRadius(12)
      }
      .width('100%')                       // 让标签行占满宽度
      .justifyContent(FlexAlign.Start)     // 标签靠左对齐
      .margin({ top: 8 })

      // 文章封面
      if (this.articleContentData.coverUrl) {
        Image(this.articleContentData.coverUrl)
          .width('100%')
          .aspectRatio(2)
          .objectFit(ImageFit.Cover)
          .borderRadius(8)
          .margin({ top: 10 })
      }
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(8)
    .margin({ bottom: 10 })
  }
}
