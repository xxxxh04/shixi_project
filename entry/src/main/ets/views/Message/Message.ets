import { router } from '@kit.ArkUI'
import AppRouter from '@ohos.router';
import { RouterConstant } from '../../contants/RouterConstant';

@Entry

@Component
export struct Message {
  build() {
    Column({ space: 15 }) {
      Text('消息')
        .margin({top:15,left:15})
        .fontSize(25)

        .width('100%')
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Start)

      Text('一共2条消息 （未读2条）')
        .width('100%')
        .textAlign(TextAlign.Start)
        .margin({left:10,top:20})
      Row() {
        Image($r('app.media.icon_system_message'))
          .width('15%')
        Column() {
          Text('系统消息')
            .fontSize(15)
            .margin({ top: 5, bottom: 5 })
          Text('这里是系统消息内容')
            .fontSize(10)
            .fontColor(Color.Gray)
        }
      }
      .width('95%')
      .height(80)
      .onClick(() => {
        console.log('点击触发了');
        AppRouter.pushUrl({
          url: RouterConstant.VIEWS_MESSAGE_LIST
        })
      })

      .backgroundColor(Color.White)
      .borderRadius(20)

      Row() {
        Image($r('app.media.icon_bottom_message_selected'))
          .width('15%')
        Column() {
          Text('通知公告')
            .fontSize(15)
            .margin({ top: 5, bottom: 5 })
          Text('这里是通知公告内容')
            .fontSize(10)
            .fontColor(Color.Gray)

        }
      }
      .width('95%')
      .height(80)
      .backgroundColor(Color.White)
      .borderRadius(20)
      .onClick(() => {
        console.log('点击触发了');
        router.pushUrl({
          url: 'views/Message/systemInfo'
        })
      })


    }
    .width('100%')       // 填满父容器
    .height('100%')      // 填满父容器
    .backgroundImage($r('app.media.background'))
    .backgroundImageSize(ImageSize.Cover)
    // .objectFit(ImageFit.Cover)

  }
}
