import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column({ space: 30 }) {
      Text('鸿蒙代码实战')
        .fontSize(20)
      Column({ space: 20 }) {
        Column({ space: 5 }) {
          Text("任务点一:")
            .fontSize(16)
          Text("适趣我爱说 - 编辑信息页面")
            .fontSize(16)
        }
        .width("100%")
        .padding({
          top: 20,
          left: 20,
          bottom: 20,
          right: 20
        })
        .alignItems(HorizontalAlign.Start)
        .backgroundColor("#fff6f4f4")
        .borderRadius(20)
        .border({ width: 1, color: "#ffecdfdf" })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/InformationChangePage'
          })
        })

        Column({ space: 5 }) {
          Text("任务点二:")
            .fontSize(16)
          Text("高阶英语-文库")
            .fontSize(16)
        }
        .width("100%")
        .padding({
          top: 20,
          left: 20,
          bottom: 20,
          right: 20
        })
        .alignItems(HorizontalAlign.Start)
        .backgroundColor("#fff6f4f4")
        .borderRadius(20)
        .border({ width: 1, color: "#ffecdfdf" })
        .onClick(() => {
          router.pushUrl({
            url: 'pages/LibraryPage'
          })
        })
      }
      .width("90%")
    }
    .padding({ top: 20 })
    .height('100%')
    .width('100%')
  }
}