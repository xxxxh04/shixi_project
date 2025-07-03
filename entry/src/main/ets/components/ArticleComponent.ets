import { ArticleContentData } from '../api/ArticleContentApi.type';

/**
 * 单个文章组件
 * 用于展示文章信息（头像、昵称、标题、封面、阅读数、分类标签等）
 */
@Component
export struct ArticleComponent {
  // 父组件传入的文章数据
  @Prop articleContentData: ArticleContentData;

  build() {
    Column() {
      // 第一行：用户头像 + 用户昵称
      Row({ space: 10 }) {
        // 头像
        Image(this.articleContentData.avatarUri)
          .width(30)
          .aspectRatio(1)
          .borderRadius(10);
        // 昵称
        Text(this.articleContentData.nickname)
          .fontSize(16)
          .fontColor('#999')
          .width('70%')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis });
      }
      .width('100%');

      // 第二行：文章标题 + 封面图片
      Row() {
        Text(this.articleContentData.title)
          .fontSize(14)
          .width('80%')
          .maxLines(3)
          .textOverflow({ overflow: TextOverflow.Ellipsis });
        Image(this.articleContentData.coverUrl)
          .width(60)
          .aspectRatio(1)
          .objectFit(ImageFit.Contain)
          .borderRadius(5);
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceBetween);

      // 第三行：阅读数 + 时间 + 分类标签 + 难度标签
      Row({ space: 5 }) {
        Text(this.articleContentData.readCount + '阅读').textStyles();
        Text('|').textStyles();
        Text(this.articleContentData.time).textStyles();
        Text('|').textStyles();
        // 内容分类标签
        Text(this.getContentLabel()).textLabelStyles();
        Text('|').textStyles();
        // 难度分类标签
        Text(this.getDifficultyLabel()).textLabelStyles();
      }
      .width('100%');
    }
    // 整体样式
    .padding(10)
    .width('100%')
    .margin({ top: 8 })
    .backgroundColor('#fff')
    .borderRadius(8);
  }

  /**
   * 获取文章内容分类标签
   */
  private getContentLabel(): string {
    switch (this.articleContentData.contentCategory) {
      case '1': return '鸿蒙';
      case '2': return 'Java';
      case '3': return 'Web前端';
      case '4': return '运维';
      default: return '未知分类';
    }
  }

  /**
   * 获取文章难度分类标签
   */
  private getDifficultyLabel(): string {
    const platform = this.articleContentData.platformCategory;
    const difficulty = this.articleContentData.difficultyCategory;
    if (difficulty === '1') return platform === '1' ? '基础知识' : '简单面试题';
    if (difficulty === '2') return platform === '1' ? '进阶知识' : '中等面试题';
    if (difficulty === '3') return platform === '1' ? '高级知识' : '困难面试题';
    return '未知难度';
  }
}

// 通用文本样式
@Extend(Text)
function textStyles() {
  .fontColor('#999')
  .fontSize(12)
}

// 标签文本样式
@Extend(Text)
function textLabelStyles() {
  .fontColor('#000')
  .fontSize(12)
}
