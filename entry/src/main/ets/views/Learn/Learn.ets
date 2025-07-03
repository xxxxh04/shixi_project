@Component
export struct Learn {
  @State currentPage: string = 'learn'

  build() {
    Column() {
      Row() {
        Text('知识就是力量')
          .fontSize(28)
          .fontWeight(FontWeight.Bold)
          .margin({ left: 15 })

        Blank()

        Image($r('app.media.icon_huawei_login'))
          .width(70)
          .height(70)
          .margin({ right: 15 })
      }
      .width('100%')
      .height(60)
      .backgroundColor('#FFFFFF')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)
      .shadow({ radius: 8, color: '#1A000000' })

      Scroll() {
        Column() {
          Stack() {
            Image($r('app.media.learn_img'))
              .width('100%')
              .height(200)
              .objectFit(ImageFit.Cover)

            Column() {
              Text('每日学习 成就未来')
                .fontSize(22)
                .fontWeight(FontWeight.Bold)
                .fontColor(Color.Black)
                .margin({ bottom: 5 })

              Text('坚持每日学习，提升专业技能')
                .fontSize(14)
                .fontColor(Color.Black)
            }
            .position({ x: 20, y: '50%' })
            .translate({ y: -25 })
          }
          .width('100%')
          .height(200)
          .margin({ bottom: 20 })

          Column() {
            Row() {
              Text('学习工具')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)

              Blank()

              Text('更多')
                .fontSize(14)
                .fontColor('#666666')
            }
            .width('100%')
            .margin({ bottom: 10 })

            Row() {
              Column() {
                Image($r('app.media.icon_system_message'))
                  .width(50)
                  .height(50)
                  .margin({ bottom: 8 })
                Text('学习打卡')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
              }
              .backgroundColor('#E6F7FF')
              .borderRadius(16)
              .padding(15)
              .margin({ left: 15 })
              .layoutWeight(1)
              .onClick(() => {
                console.log('打开学习打卡功能')
              })

              Column() {
                Image($r('app.media.icon_learn_target'))
                  .width(50)
                  .height(50)
                  .margin({ bottom: 8 })
                Text('学习目标')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
              }
              .backgroundColor('#E6F7FF')
              .borderRadius(16)
              .padding(15)
              .margin({ left: 15 })
              .layoutWeight(1)
              .onClick(() => {
                console.log('打开学习目标功能')
              })

              Column() {
                Image($r('app.media.icon_learn_clock'))
                  .width(50)
                  .height(50)
                  .margin({ bottom: 8 })
                Text('学习笔记')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
              }
              .backgroundColor('#E6F7FF')
              .borderRadius(16)
              .padding(15)
              .margin({ left: 15 })
              .layoutWeight(1)
              .onClick(() => {
                console.log('打开学习笔记功能')
              })
            }
            .width('100%')
            .margin({ bottom: 20 })
          }
          .padding(15)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .margin({ bottom: 20 })

          Column() {
            Row() {
              Text('学习平台')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)

              Blank()

              Text('全部')
                .fontSize(14)
                .fontColor('#666666')
            }
            .width('100%')
            .margin({ bottom: 10 })

            Grid() {

              GridItem() {
                Column() {
                  Image($r('app.media.icon_learn_hm'))
                    .width(50)
                    .height(50)
                    .margin({ bottom: 8 })
                  Text('鸿蒙开发')
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                }
                .width('100%')
                .height(120)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .backgroundColor('#E6F7FF')
                .borderRadius(12)
                .onClick(() => {
                  console.log('打开鸿蒙开发课程')
                })
              }


              GridItem() {
                Column() {
                  Image($r('app.media.icon_learn_java'))
                    .width(50)
                    .height(50)
                    .margin({ bottom: 8 })
                  Text('Java开发')
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                }
                .width('100%')
                .height(120)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .backgroundColor('#E6F7FF')
                .borderRadius(12)
                .onClick(() => {
                  console.log('打开Java开发课程')
                })
              }


              GridItem() {
                Column() {
                  Image($r('app.media.icon_learn_web'))
                    .width(50)
                    .height(50)
                    .margin({ bottom: 8 })
                  Text('Web前端')
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                }
                .width('100%')
                .height(120)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .backgroundColor('#E6F7FF')
                .borderRadius(12)
                .onClick(() => {
                  console.log('打开Web前端课程')
                })
              }


              GridItem() {
                Column() {
                  Image($r('app.media.icon_learn_linux'))
                    .width(50)
                    .height(50)
                    .margin({ bottom: 8 })
                  Text('运维开发')
                    .fontSize(16)
                    .fontWeight(FontWeight.Medium)
                }
                .width('100%')
                .height(120)
                .justifyContent(FlexAlign.Center)
                .alignItems(HorizontalAlign.Center)
                .backgroundColor('#E6F7FF')
                .borderRadius(12)
                .onClick(() => {
                  console.log('打开运维开发课程')
                })
              }
            }
            .columnsTemplate('1fr 1fr')
            .rowsTemplate('1fr 1fr')
            .rowsGap(15)
            .columnsGap(15)
            .height(255)
          }
          .padding(15)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
          .margin({ bottom: 20 })


          Column() {
            Row() {
              Text('面试大全')
                .fontSize(20)
                .fontWeight(FontWeight.Bold)

              Blank()

              Text('查看全部')
                .fontSize(14)
                .fontColor('#666666')
            }
            .width('100%')
            .margin({ bottom: 10 })

            Row() {

              Column() {
                Image($r('app.media.icon_learn_hm'))
                  .width(40)
                  .height(40)
                  .margin({ bottom: 8 })
                Text('鸿蒙面试题')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
              }
              .backgroundColor('#FFECEC')
              .borderRadius(12)
              .padding(15)
              .layoutWeight(1)
              .onClick(() => {
                console.log('打开鸿蒙面试题')
              })


              Column() {
                Image($r('app.media.icon_learn_java'))
                  .width(40)
                  .height(40)
                  .margin({ bottom: 8 })
                Text('Java面试题')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
              }
              .backgroundColor('#E6F7FF')
              .borderRadius(12)
              .padding(15)
              .margin({ left: 15 })
              .layoutWeight(1)
              .onClick(() => {
                console.log('打开Java面试题')
              })


              Column() {
                Image($r('app.media.icon_learn_web'))
                  .width(40)
                  .height(40)
                  .margin({ bottom: 8 })
                Text('前端面试题')
                  .fontSize(16)
                  .fontWeight(FontWeight.Medium)
              }
              .backgroundColor('#E6FFE6')
              .borderRadius(12)
              .padding(15)
              .margin({ left: 15 })
              .layoutWeight(1)
              .onClick(() => {
                console.log('打开前端面试题')
              })
            }
            .width('100%')
          }
          .padding(15)
          .backgroundColor('#FFFFFF')
          .borderRadius(16)
        }
        .width('100%')
        .padding(15)
        .backgroundColor('#F5F7FA')
      }
      .layoutWeight(1)

    }
  }
}