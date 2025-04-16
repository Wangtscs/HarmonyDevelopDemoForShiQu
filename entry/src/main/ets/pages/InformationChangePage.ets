import { promptAction, router } from '@kit.ArkUI';

@Entry
@Component
struct InformationChangePage {
  @State nickName: string = "小明"
  @State isMaleSelected: boolean = true;
  @State isLunar: boolean = false
  @State selectedDate: string = "请填写你的生日"
  @State showDatePicker: boolean = false

  formatDate(dateStr: string): string {
    const date = new Date(dateStr)
    const year = date.getFullYear()
    const month = String(date.getMonth() + 1).padStart(2, '0') // 月份是从0开始的
    const day = String(date.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  }

  getCurrentDate(): string {
    const now = new Date()
    const year = now.getFullYear()
    const month = String(now.getMonth() + 1).padStart(2, '0') // 月份从0开始
    const day = String(now.getDate()).padStart(2, '0')
    return `${year}-${month}-${day}`
  }

  aboutToAppear(): void {
    this.selectedDate = this.getCurrentDate()
  }

  build() {
    Column() {
      // 顶部navBar
      Row() {
        Image($r('app.media.icon_back_arrow_black'))
          .width(20)
          .onClick(() => {
            router.back()
          })
        Text("编辑信息")
          .fontSize(18)
        // .fontWeight(FontWeight.Regular)
        Blank()
          .width(20)
      }
      .width("100%")
      .padding({ left: 10, right: 10, top: 15 })
      .justifyContent(FlexAlign.SpaceBetween)

      // 头像信息
      Column({ space: 5 }) {
        Image($r('app.media.avatar'))
          .width(80)
          .borderRadius(40)
        Text('点击更换头像')
          .fontSize(12)
          .fontColor("#ff757171")
      }
      .margin({ top: 80 })
      .width('100%')

      // 性别选择
      Row({ space: 20 }) {
        Button() {
          this.sexSelectionButStyle($r('app.media.icon_boy'), "男生")
        }
        .alignSelf(ItemAlign.Center)
        .width(120)
        .padding({
          left: 10,
          right: 10,
          top: 10,
          bottom: 10
        })
        .onClick(() => {
          this.isMaleSelected = true;
        })
        .backgroundColor("#F5F5F5")
        .borderWidth(2)
        .borderColor(this.isMaleSelected ? '#007DFF' : '#F5F5F5')
        .fontColor('#000000')

        Button() {
          this.sexSelectionButStyle($r('app.media.icon_girl'), "女生")
        }
        .alignSelf(ItemAlign.Center)
        .width(120)
        .padding({
          left: 10,
          right: 10,
          top: 10,
          bottom: 10
        })
        .onClick(() => {
          this.isMaleSelected = false;
        })
        .backgroundColor("#F5F5F5")
        .borderWidth(2)
        .borderColor(!this.isMaleSelected ? '#007DFF' : '#F5F5F5')
        .fontColor('#000000')
      }
      .margin({ top: 40 })
      .width('100%')
      .justifyContent(FlexAlign.Center)

      // 昵称和生日填写
      Column({ space: 20 }) {
        Column({ space: 10 }) {
          Text("昵称")
            .fontSize(16)
          TextInput({ placeholder: "来填写你的昵称吧~", text: this.nickName })
            .onChange((value: string) => {
              this.nickName = value
            })
        }
        .alignItems(HorizontalAlign.Start)

        Column({ space: 10 }) {
          Text("你的生日")
            .fontSize(16)
          Button() {
            this.selectBirthdayButStyle()
          }
          .padding({
            top: 14,
            left: 18,
            right: 18,
            bottom: 14
          })
          .onClick(() => {
            this.showDatePicker = true
          })
          .width("100%")
          .backgroundColor("#F4F5F7")

          .alignSelf(ItemAlign.Start)
          .align(Alignment.Start)

        }
        .alignItems(HorizontalAlign.Start)
      }
      .margin({ top: 20 })
      .width("80%")

      Column() {
        Button("完成")
          .width("100%")
          .padding({
            bottom: 10,
            top: 10
          })
          .shadow({
            radius: 20,
            color: "#0A59F7",
            offsetX: 0,
            offsetY: 15
          })
          .onClick(() => {
            promptAction.showDialog({
              message: `${this.nickName} 是一位 ${this.isMaleSelected ? '男生' : '女生'}，${this.isMaleSelected ? '他' :
                '她'} 的生日是 ${this.selectedDate}`
            })
          })
      }
      .position({
        bottom: 40,
        left: "50%"
      })
      .translate({ x: '-50%' })
      .width("80%")

      // 日期选择器弹窗
      if (this.showDatePicker) {
        Stack() {
          Column()
            .width("100%")
            .height("100%")
            .backgroundColor("#39484242")
            .onClick(() => {
              this.showDatePicker = false
            })
          Column() {
            // 顶部操作栏
            Row() {
              Button("取消")
                .fontSize(16)
                .fontWeight(FontWeight.Normal)
                .fontColor("#323232")
                .onClick(() => {
                  this.showDatePicker = false
                })
                .backgroundColor(Color.Transparent)
              Text("生日")
                .fontSize(16)
                .fontColor("#323232")
                .fontWeight(FontWeight.Normal)
                .margin({ left: 24, right: 24 })
              Button("确定")
                .fontSize(16)
                .fontWeight(FontWeight.Normal)
                .fontColor("#323232")
                .onClick(() => {
                  this.showDatePicker = false
                })
                .backgroundColor(Color.Transparent)

            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .padding(16)

            // 日期选择器
            DatePicker({
              start: new Date('1900-1-1'),
              end: new Date('2100-1-1'),
              selected: new Date(this.selectedDate)
            })
              .disappearTextStyle({ color: Color.Gray, font: { size: '16fp', weight: FontWeight.Bold } })
              .textStyle({ color: '#ACACAC', font: { size: '16fp', weight: FontWeight.Normal } })
              .selectedTextStyle({
                color: '#262626',
                font: {
                  size: '20fp',
                  weight: FontWeight.Regular,
                  family: "HarmonyOS Sans",
                  style: FontStyle.Normal
                }
              })
              .onDateChange((value: Date) => {
                this.selectedDate = this.formatDate(value.toString())
                console.info('select current date is: ' + this.selectedDate)
              })
          }
          .width('100%')
          // .height('50%')
          .backgroundColor('#FFFFFF')
          .padding({ bottom: 20 })
          .position({ bottom: 0 })
          .transition({ type: TransitionType.All, opacity: 1 })
        }
        .width('100%')
        .height('100%')
        .position({
          x: 0, y: 0
        })
        .zIndex(999)
      }
    }
    .height('100%')
    .width('100%')
  }

  @Builder
  selectBirthdayButStyle() {
    Row() {
      Text(String(this.selectedDate))
        .fontColor("#757575")
        .fontSize(16)
      Image($r("app.media.icon_arrow_down_filling"))
        .width(18)
    }
    .width("100%")
    .justifyContent(FlexAlign.SpaceBetween)
  }

  @Builder
  sexSelectionButStyle(img: Resource, title: string) {
    Row({ space: 8 }) {
      Image(img)
        .width(25)
      Text(title)
    }
  }
}