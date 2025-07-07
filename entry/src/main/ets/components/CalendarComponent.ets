@Entry
@Component
export struct CalendarComponent {
  @State currentYear: number = new Date().getFullYear()
  @State currentMonth: number = new Date().getMonth() + 1
  @Prop clockDates: string[] = []

  private getWeeks(): Array<Array<number | null>> {
    const daysInMonth = new Date(this.currentYear, this.currentMonth, 0).getDate()
    const firstDay = new Date(this.currentYear, this.currentMonth - 1, 1).getDay()
    let weeks: Array<Array<number | null>> = []
    let week: Array<number | null> = []
    let day = 1
    for (let i = 0; i < firstDay; i++) week.push(null)
    while (day <= daysInMonth) {
      week.push(day)
      if (week.length === 7) {
        weeks.push(week)
        week = []
      }
      day++
    }
    if (week.length > 0) {
      while (week.length < 7) week.push(null)
      weeks.push(week)
    }
    return weeks
  }

  private isClocked(day: number): boolean {
    if (!day) return false
    const m = String(this.currentMonth).padStart(2, '0')
    const dStr = String(day).padStart(2, '0')
    const dateStr = `${this.currentYear}-${m}-${dStr}`
    return this.clockDates.includes(dateStr)
  }

  build() {
    Column() {
      // 年月切换
      Row() {
        Button('«')
          .onClick(() => { this.currentYear-- })
          .width(45).height(38).fontSize(22)
          .backgroundColor('#f5f5f5').fontColor('#198cff').borderRadius(19)
        Button('<')
          .onClick(() => {
            if (this.currentMonth === 1) { this.currentYear--; this.currentMonth = 12 }
            else { this.currentMonth-- }
          })
          .width(42).height(38).fontSize(22)
          .backgroundColor('#f5f5f5').fontColor('#198cff').borderRadius(19)
        Text(`${this.currentYear}年${this.currentMonth < 10 ? '0' + this.currentMonth : this.currentMonth}月`)
          .fontSize(20).fontWeight(FontWeight.Bold)
          .width('36%').textAlign(TextAlign.Center)
        Button('>')
          .onClick(() => {
            if (this.currentMonth === 12) { this.currentYear++; this.currentMonth = 1 }
            else { this.currentMonth++ }
          })
          .width(43).height(38).fontSize(22)
          .backgroundColor('#f5f5f5').fontColor('#198cff').borderRadius(19)
        Button('»')
          .onClick(() => { this.currentYear++ })
          .width(45).height(38).fontSize(22)
          .backgroundColor('#f5f5f5').fontColor('#198cff').borderRadius(19)
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .margin({ top: 10, bottom: 8 })
      .padding({ left: 8, right: 8 })

      // 星期标题
      Row() {
        ForEach(['日', '一', '二', '三', '四', '五', '六'], (day: string, idx: number) => {
          Text(day)
            .width('14.28%')
            .textAlign(TextAlign.Center)
            .fontSize(18)
            .fontWeight(FontWeight.Medium)
        })
      }.margin({ bottom: 10 })

      // 日历主体
      ForEach(this.getWeeks(), (week: Array<number | null>, wi: number) => {
        Row() {
          ForEach(week, (d: number | null, di: number) => {
            if (d !== null) {
              // 用 Stack 做一个可点的纯方格
              Stack() {
                Rect()
                  .width(46).height(46)
                  .fill(this.isClocked(d) ? '#198cff' : '#f3f5f7')
                  .border({ color: '#e0e0e0', width: 1 })
                  .radius(0) // 重点！！！！
                Text(`${d}`)
                  .fontColor(this.isClocked(d) ? '#fff' : '#333')
                  .fontSize(14)
                  .align(Alignment.Center)
              }
              .width(46).height(46)
              .margin({ left: 2, right: 2, top: 4, bottom: 4 })
              .gesture(
                TapGesture().onAction(() => {
                  // 点击逻辑
                })
              )
            } else {
              // 空格
              Blank().width(46).height(46)
                .margin({ left: 2, right: 2, top: 4, bottom: 4 })
            }
          })
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
      })
    }
    .width('100%')
    .backgroundColor('#fff')
    .borderRadius(16)
    .margin({ top: 10, bottom: 10 })
    .padding(10)
  }
}
