import { CommonConstant } from '../../contants/CommonConstant'
import { prompt } from '@kit.ArkUI'
import feedbackInfoApi from '../../api/FeedbackInfoApi'

//点击反馈弹窗
@CustomDialog
@Component
struct feedBackComponent {
  controller: CustomDialogController = new CustomDialogController({
    builder: feedBackComponent()
  })

  feedbackText: string = ''

  build() {
    Column({ space: 20 }) {
      // 标题
      Text('反馈意见')
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .textAlign(TextAlign.Center)
        .width('100%')
        .padding({ top:10,bottom: 6 })

      // 输入框区域
      TextInput({
        placeholder: '请输入反馈意见,长度不能超过255字符',
        text: this.feedbackText,
      })
        .onChange((value: string) => {
          this.feedbackText = value;
        })
        .width('90%')
        .height(50)
        .backgroundColor('#CCCCCC')
        .borderRadius(12)
        .padding(10)
        .fontSize(16)






      Column(){
        Divider()
          .strokeWidth(1)
          .color('#CCCCCC')
          .width(CommonConstant.WIDTH_FULL)

        // 按钮区域
        Row() {
          // 取消按钮
          Button('取消', { type: ButtonType.Normal })
            .width('50%')
            .height(CommonConstant.HEIGHT_FULL)
            .backgroundColor('#FFFFFF')
            .fontColor(Color.Black)
            .onClick(() => this.controller.close())


          Row() {
            // 模拟左边框
            Column()
              .width(1)
              .height(CommonConstant.HEIGHT_FULL)
              .backgroundColor('#CCCCCC')

            // 确认按钮
            Button('确认', { type: ButtonType.Normal })
              .width(CommonConstant.WIDTH_FULL)
              .height(CommonConstant.HEIGHT_FULL)
              .backgroundColor('#FFFFFF')
              .fontColor(Color.Blue)
              .onClick(() => {
                console.log('提交反馈: ', this.feedbackText);

                if (!this.feedbackText.trim()) {
                  prompt.showToast({
                    message: '请输入反馈内容',
                    duration: 2000
                  });
                  return;
                }

                feedbackInfoApi.addFeedbackContent({ content: this.feedbackText.trim() })
                  .then(() => {
                    prompt.showToast({
                      message: '提交成功',
                      duration: 2000
                    });
                    this.feedbackText = '';
                    this.controller.close();
                  })
                  .catch((err:Error) => {
                    console.error(err.message);
                    prompt.showToast({
                      message: '提交失败，请稍后再试',
                      duration: 2000
                    });
                  });
              })
          }
          .width('50%')




        }
        .width(CommonConstant.WIDTH_FULL)
        .height(50)
        .borderRadius({
          topLeft: 0,
          topRight: 0,
          bottomLeft: 10,
          bottomRight: 10
        })
        .backgroundColor('#FFFFFF')
      }
      .width(CommonConstant.WIDTH_FULL)
      .backgroundColor('#FFFFFF')
      .borderRadius(20)

    }
    .margin({ top: 10 })
    // .padding(20)
    .width(CommonConstant.WIDTH_FULL)
    .backgroundColor('#FFFFFF')
    .borderRadius(5)
  }
}

export { feedBackComponent }
