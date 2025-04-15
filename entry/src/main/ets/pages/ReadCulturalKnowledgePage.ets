import { router } from '@kit.ArkUI';
import { culturalKnowledgeListType } from '../model';

@Entry
@Component
struct ReadCulturalKnowledgePage {
  @State message: string = 'Hello World';
  @State CulturalKnowledgeList: culturalKnowledgeListType[] = [
    {
      title: '后羿射日',
      aid: 6
    },
    {
      title: '谁是春秋时期第一个霸主？',
      aid: 7
    }
  ]

  build() {
    Column({ space: 30 }) {
      Row() {
        Image($r('app.media.icon_back_arrow_black'))
          .width(20)
          .onClick(() => {
            router.back()
          })
        Text('文化常识列表')
          .fontSize(20)
        // .fontWeight(FontWeight.Regular)
        Blank()
          .width(20)
      }
      .width("100%")
      .padding({ left: 10, right: 10, top: 15 })
      .justifyContent(FlexAlign.SpaceBetween)

      Column({ space: 20 }) {
        ForEach(this.CulturalKnowledgeList, (item: culturalKnowledgeListType) => {
          Column({ space: 5 }) {
            Text("任务点一:")
              .fontSize(16)
            Text(item.title)
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
              url: 'pages/ReadCulturalKnowledgeDetailPage',
              params: {
                aid: item.aid
              }
            })
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