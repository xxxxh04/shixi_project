import router from '@ohos.router';

let initialView: number = 1;
let initialLike: number = 1;
let initialCollection: number = 1;
let initialYear: number = 2025;
let initialMonth: number = 1;
let initialDay: number = 20;

@Entry
@Component
export struct ArticleInfo {

  @State view: number = initialView;
  @State like: number = initialLike;
  @State collection: number = initialCollection;
  @State year: number = initialYear;
  @State month: number = initialMonth;
  @State day: number = initialDay;


  @State isLiked: boolean = false;
  @State isCollected: boolean = false;


  private readonly CONTENT_TITLE: string = '鸿蒙介绍';
  private readonly CONTENT_SUBTITLE: string = '简单介绍';
  private readonly CONTENT_TEXT: string =
    'HarmonyOS是新一代的智能终端操作系统,为不同设备的智能化、互联与协同提供了统一的语言。' +
      '带来简洁,流畅,连续,安全可靠的全场景交互体验。\n\n' +
      '鸿蒙操作系统发展历程\n\n' +
      '2019年8月9日 鸿蒙1.0发布,首次应用于华为荣耀智慧屏产品中,标志着华为正式进军操作系统领域\n' +
      '2020年9月10日 鸿蒙2.0在华为开发者大会上发布,适用于部分手机、车机、智能电视等设备\n' +
      '2022年7月27日 鸿蒙3.0在HarmonyOS3及华为全场景新品发布会上正式发布,支持更多设备加入超级终端,' +
      '并提升了鸿蒙智联、万能卡片、流畅性能、隐私安全、信息无障碍等方面\n' +
      '2023年8月4日 鸿蒙4.0在华为开发者大会上正式发布,提供了强大的智能互联能力,并在多屏跨设备投屏等方面实现突破\n' +
      '2024年1月18日 鸿蒙Next开发者预览版本发布,将不在兼容安卓应用';


  @Builder AuthorInfo() {
    Row() {
      Image($r('app.media.headPicture'))
        .width(40)
        .height(40)
        .margin({ right: 10 })
        .borderRadius(20)
      Text('鸿蒙知识库')
        .fontSize(16)
        .fontWeight(FontWeight.Medium)
    }
    .width('100%')
    .padding({ bottom: 8 })
  }

  @Builder StatsInfo() {
    Row() {

      Row() {
        Text(`${this.view} 阅读 |`)
          .fontSize(10)
        Text(`${this.like} 喜欢 |`)
          .fontSize(10)
        Text(`${this.collection} 收藏 | `)
          .fontSize(10)
        Text(`${this.year}-${this.month.toString().padStart(2, '0')}-${this.day.toString().padStart(2, '0')} |`)
          .fontSize(10)
        Text('鸿蒙 | 基础知识')
          .fontSize(10)
          .fontColor('#1a73e8')
      }
      .layoutWeight(1)


      Row() {
        Image(this.isLiked ? $r('app.media.icon_like_selected') : $r('app.media.icon_like_default'))
          .width(18)
          .height(18)
          .margin({ right: 10 })
          .onClick(() => {
            this.isLiked = !this.isLiked;
            this.like = this.isLiked ? this.like + 1 : this.like - 1;
          })

        Image(this.isCollected ? $r('app.media.icon_collect_selected') : $r('app.media.icon_collect_default'))
          .width(18)
          .height(18)
          .onClick(() => {
            this.isCollected = !this.isCollected;
            this.collection = this.isCollected ? this.collection + 1 : this.collection - 1;
          })
      }
    }
    .width('100%')
    .padding({ bottom: 15 })
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    Column() {

      Row({ space: 10 }) {
        Image($r('app.media.icon_back'))
          .width(30)
          .height(30)
          .onClick(() => {
            router.back();
          })

        Text('内容详情')
          .fontWeight(FontWeight.Bold)
          .fontSize(22)
          .layoutWeight(1)
          .textAlign(TextAlign.Start)
      }
      .width('100%')
      .padding({ bottom: 20, top: 10 })


      Column() {
        Text('鸿蒙NEXT开发-鸿蒙介绍')
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
        color: { bottom: '#f0f0f0' }
      })


      Scroll() {
        Column({ space: 20 }) {
          Text(this.CONTENT_TITLE)
            .fontSize(24)
            .fontWeight(FontWeight.Bold)
            .width('100%')
            .textAlign(TextAlign.Start)

          Text(this.CONTENT_SUBTITLE)
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .width('100%')
            .textAlign(TextAlign.Start)
            .fontColor('#666')

          Text(this.CONTENT_TEXT)
            .fontSize(16)
            .lineHeight(24)
            .textAlign(TextAlign.Start)
            .padding({ bottom: 30 })
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
    .backgroundColor(Color.White)
  }
}