
import { router } from '@kit.ArkUI'
import AppRouter from '@ohos.router';
import { RouterConstant } from '../../contants/RouterConstant';

@Entry
@Component
export struct Message {
  // 🔴 这里声明状态
  @State sysMsgUnread: boolean = true
  @State notifyUnread: boolean = true

  build() {
    Column({ space: 15 }) {
      // 标题
      Text('消息')
        .margin({ top:15, left:15 })
        .fontSize(25)
        .width('100%')
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)

      // 消息总数
      Text('一共2条消息（未读0条）')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({ left:10, top:20 })

      // 系统消息
      Row({ space:10 }) {
        Image($r('app.media.icon_system_message'))
          .width('10%')

        Column({ space:5 }) {
          Text('系统消息')
            .width('100%')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)

          Text('希望大家能在百得知识库学到对应的知识.')
            .width('100%')
            .fontSize(16)
            .fontColor(Color.Gray)
            .textAlign(TextAlign.Start)
            .maxLines(1)
            .textOverflow({overflow:TextOverflow.Ellipsis})
        }

        // 🔴 红点
        if (this.sysMsgUnread) {
          Blank()
            .width(12)
            .height(12)
            .backgroundColor('#FF3B30')
            .borderRadius(6)
            .margin({ left:5, top:8 })
        }
      }
      .onClick(() => {
        AppRouter.pushUrl({
          url: RouterConstant.VIEWS_MESSAGE_LIST,
          params: { type: 'system' }
        })
        // 点击后标记为已读
        this.sysMsgUnread = false
      })
      .width('95%')
      .height(60)
      .backgroundColor(Color.White)
      .borderRadius(20)
      // 通知公告

      Row({ space:10 }) {
        Image($r('app.media.icon_bottom_message_selected'))
          .width('10%')


        Column({ space:5 }) {
          Text('通知公告')
            .width('100%')
            .fontSize(20)
            .fontWeight(FontWeight.Medium)
            .textAlign(TextAlign.Start)

          Text('大家记得仔细阅读隐私政策和用户协议...')
            .fontSize(16)
            .width('100%')
            .fontColor(Color.Gray)
            .textAlign(TextAlign.Start)
        }

        if (this.notifyUnread) {
          Blank()
            .width(12)
            .height(12)
            .backgroundColor('#FF3B30')
            .borderRadius(6)

            .margin({ left:5, top:8 })
        }
      }

      .onClick(() => {
        router.pushUrl({
          url: 'views/Message/systemInfo'
        })
        this.notifyUnread = false
      })
      .width('95%')
      .height(60)
      .backgroundColor(Color.White)
      .borderRadius(20)
    }
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
  }
}
