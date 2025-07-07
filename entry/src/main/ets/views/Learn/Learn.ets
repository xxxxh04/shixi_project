import { ClockComponent } from '../../components/ClockComponent'
import { CommonConstant } from '../../contants/CommonConstant'
import { LearnApplicationData } from '../../models/LearnApplicationData'
import { router } from '@kit.ArkUI'
import { RouterConstant } from '../../contants/RouterConstant'
import { TitleComponent } from '../../components/TitleComponent'
import { PlatformCategory } from '../../api/ArticleContentApi.type'

@Entry
@Component
struct Learn {
  @State learnApplicationList: LearnApplicationData[] = [
    { id: 1, name: '鸿蒙', icon: $r("app.media.icon_learn_hm") },
    { id: 2, name: 'Java', icon: $r("app.media.icon_learn_java") },
    { id: 3, name: 'Web前端', icon: $r("app.media.icon_learn_web") },
    { id: 4, name: '运维', icon: $r("app.media.icon_learn_linux") }
  ]

  @State interviewApplicationList: LearnApplicationData[] = [
    { id: 1, name: '鸿蒙面试题', icon: $r("app.media.icon_learn_hm") },
    { id: 2, name: 'Java面试题', icon: $r("app.media.icon_learn_java") }
  ]

  @State clockData: LearnApplicationData[] = [
    { id: 1, name: '学习打卡', icon: $r("app.media.icon_learn_clock") },
    { id: 2, name: '学习目标', icon: $r("app.media.icon_learn_target") }
  ]

  @State pageTitle: string = '学习'

  // 修复点 1: 使用明确的 Resource 类型
  @Builder
  fontTitleBuilder(title: string) {
    Row() {
      Text(title)
        .fontSize($r('app.float.common_font_size_big'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.text_color'))
    }.width(CommonConstant.WIDTH_FULL).margin({ top: 25, bottom: 15 })
  }

  // 修复点 2-3: 重构样式扩展方法
  @Builder
  learnApplicationBuilder(id: number, icon: Resource, text: string) {
    Column({ space: 10 }) {
      Image(icon)
        .width(40).aspectRatio(1)

      // 修复点 2: 内联文本样式
      Text(text)
        .fontSize($r('app.float.common_font_size_small'))
        .fontColor($r('app.color.text_color'))
        .fontWeight(FontWeight.Normal)
    }
    // 修复点 3: 内联列样式
    .width(75)
    .height($r('app.float.common_height_big'))
    .backgroundColor($r('app.color.background_color'))
    .justifyContent(FlexAlign.Center)
    .borderRadius(8)
    .onClick(() => {
      router.pushUrl({
        url: RouterConstant.VIEWS_LEARN_LIST,
        params: {
          contentType: 'category',
          contentCategory: String(id),
          pageTitle: text,
          platformCategory: PlatformCategory.LEARNING,
          currentTabIndex: 1
        }
      })
    })
  }

  @Builder
  interviewApplicationBuilder(id: number, icon: Resource, text: string) {
    Column({ space: 10 }) {
      Image(icon)
        .width(40).aspectRatio(1)

      // 修复点 2: 内联文本样式
      Text(text)
        .fontSize($r('app.float.common_font_size_small'))
        .fontColor($r('app.color.text_color'))
        .fontWeight(FontWeight.Normal)
    }
    // 修复点 3: 内联列样式
    .width(75)
    .height($r('app.float.common_height_big'))
    .backgroundColor($r('app.color.background_color'))
    .justifyContent(FlexAlign.Center)
    .borderRadius(8)
    .onClick(() => {
      router.pushUrl({
        url: RouterConstant.VIEWS_LEARN_LIST,
        params: {
          contentType: 'category',
          contentCategory: String(id),
          pageTitle: text,
          platformCategory: PlatformCategory.INTERVIEW,
          currentTabIndex: 1
        }
      })
    })
  }

  build() {
    Column() {
      TitleComponent({ title: this.pageTitle })

      Stack({ alignContent: Alignment.BottomStart }) {
        Image($r('app.media.learn_img02'))
          .width(CommonConstant.WIDTH_FULL)
        Text('').height($r('app.float.common_height_huge'))
          .fontWeight(FontWeight.Medium)
          .fontColor($r('app.color.text_color'))
      }

      this.fontTitleBuilder('学习工具')
      Row({ space: 15 }) {
        ForEach(this.clockData, (item: LearnApplicationData) => {
          // 修复点 1: 确保传递 Resource 类型
          ClockComponent({ icon: item.icon, text: item.name })
            .onClick(() => {
              if (item.id === 1) {
                router.pushUrl({ url: RouterConstant.VIEWS_LEARN_TOOL })
              } else {
                router.pushUrl({ url: RouterConstant.VIEWS_LEARN_TARGET })
              }
            })
        })
      }

      this.fontTitleBuilder('学习平台')
      Row({ space: 15 }) {
        ForEach(this.learnApplicationList, (item: LearnApplicationData) => {
          // 修复点 1: 确保传递 Resource 类型
          this.learnApplicationBuilder(item.id, item.icon, item.name)
        })
      }

      this.fontTitleBuilder('面试大全')
      Row({ space: 15 }) {
        ForEach(this.interviewApplicationList, (item: LearnApplicationData) => {
          // 修复点 1: 确保传递 Resource 类型
          this.interviewApplicationBuilder(item.id, item.icon, item.name)
        })
      }.width(CommonConstant.WIDTH_FULL)

    }
    .padding($r('app.float.common_padding'))
    .height(CommonConstant.HEIGHT_FULL)
    .width(CommonConstant.WIDTH_FULL)
  }
}

export { Learn }
