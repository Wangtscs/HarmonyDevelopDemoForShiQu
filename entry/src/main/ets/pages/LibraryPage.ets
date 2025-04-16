import { http } from '../utils'
import { promptAction } from '@kit.ArkUI';
import { articlesType, articlesTypeList, articleTypeListSty } from '../model';

@Entry
@Component
struct LibraryPage {
  @State selectedDifficulty: number = 5; // 默认选中的难度值
  @State selectedArticleTip: string = "精选阅读"
  @State selectedArticleTipID: number = 0
  @State currentPage: number = 1;
  @State categories: articleTypeListSty[] = [
    {
      "id": 0,
      "type": "精选阅读"
    }
  ];
  @State articlesList: articlesTypeList[] = []
  @State selectList: number[] = []
  @State articleTotal: number = 0
  scroller: Scroller = new Scroller()
  @State isRefreshing: boolean = false
  // 加载中
  @State isLoading: boolean = false
  // 数据加载完毕
  @State isFinished: boolean = false

  async getArticleTypeList() {
    const res = await http.request<articleTypeListSty[]>({
      url: "library/articleTypeList"
    })
    for (let index = 0; index < res.length; index++) {
      const element = res[index];
      this.categories.push(element)
    }
  }

  async getSelectList() {
    const res = await http.request<number[]>({
      url: "appArticle/selectList"
    })
    this.selectList = res
  }

  async getArticleList() {
    try {
      const res = await http.request<articlesType>({
        url: "library/articleList",
        params: {
          lexile: this.selectedDifficulty,
          typeId: this.categories[this.selectedArticleTipID].id,
          page: this.currentPage,
          size: 10,
        },
        headers: {
          "Cookie": "sid=OFvEbpyl4PyKkc/cSjl2tW3g5Ga/z5DPSQRGQn8mJBs="
        }
      })

      const articles = res
      this.articleTotal = res.total
      for (let index = 0; index < articles.list.length; index++) {
        const element = articles.list[index];
        this.articlesList.push(element)
      }
    } catch (e) {
      console.log("HTTP请求失败:", e, JSON.stringify(e))
    }
  }

  aboutToAppear(): void {
    this.getArticleTypeList()
    this.getSelectList()
    this.getArticleList()
  }

  // 下拉刷新加载
  async onRefresh() {
    this.articlesList = []
    this.currentPage = 0
    this.getArticleList()
    this.isRefreshing = false
    promptAction.showToast({ message: '更新成功' })
  }

  // 文章卡片颜色修改
  cardTypeColor(typeId: number): string {
    switch (typeId) {
      case 1:
        return "#46D8B4";
      case 2:
        return "#01ACA6";
      case 3:
        return "#7C7EE5";
      case 4:
        return "#36C5FD";
      case 5:
        return "#6CD601";
      case 6:
        return "#FE9601";
      case 7:
        return "#D3B17D";
      case 8:
        return "#F6637F";
      case 9:
        return "#7ED3DA";
      case 10:
        return "#CB95D9";
      case 11:
        return "#3BBC83";
      case 12:
        return "#DD49B7";
      case 13:
        return "#A08D40";
      default:
        return "#09744A";
    }
  }

  build() {
    Column() {
      Column() {
        // 标题
        Row() {
          Text('文库')
            .fontSize(16)// .fontWeight(FontWeight.Bold)
            .margin({ top: 20, bottom: 10 })
            .width('100%')
            .textAlign(TextAlign.Center)
        }
        .width("100%")
        .radialGradient({
          center: [140, -100],
          radius: 250,
          colors: [[0xFFE5F3FE, 0.0], [0xFFE8FCFB, 0.4], [0xFFFEFFFF, 1.0]]
        })
        // 将颜色渲染衍生至状态栏
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])


        // 页面内容
        Row({ space: 8 }) {
          // 左侧的主题选择栏
          Column() {
            ForEach(this.categories, (item: articleTypeListSty) => {
              if (item.id == 0) {
                Button({ type: ButtonType.Normal, stateEffect: true }) {
                  Row() {
                    Image($r('app.media.icon_medal'))
                      .width(14)
                    Text(item.type)
                      .fontSize(12)
                  }
                }
                .width('100%')
                .height(40)
                .borderRadius(0)
                .backgroundColor(this.selectedArticleTip == item.type ? "#FFFFFF" : "#F1F0F5")
                .fontColor(this.selectedArticleTip == item.type ? "#1A8BE9" : "#98979C")
                .onClick(() => {
                  this.articlesList = []
                  this.selectedArticleTip = item.type
                  this.selectedArticleTipID = item.id
                  this.getArticleList()
                })
              } else {
                Button({ type: ButtonType.Normal, stateEffect: true }) {
                  Column() {
                    Text(item.type)
                      .fontSize(12)
                  }
                }
                .width('100%')
                .height(40)
                .borderRadius(0)
                .backgroundColor(this.selectedArticleTip == item.type ? "#FFFFFF" : "#F1F0F5")
                .fontColor(this.selectedArticleTip == item.type ? "#1A8BE9" : "#98979C")
                .onClick(() => {
                  this.articlesList = []
                  this.selectedArticleTip = item.type
                  this.selectedArticleTipID = item.id
                  this.getArticleList()
                })
              }

            })
          }
          .justifyContent(FlexAlign.Start)
          .height("100%")
          .width(80)

          // 右侧难度值选择以及文章选择
          Column() {
            // 难度选择
            Row() {
              Text('难度值：')
                .fontSize(14)
                .fontColor('#666666')
              Scroll(this.scroller) {
                Row() {
                  ForEach(this.selectList, (item: number) => {
                    Button({ type: ButtonType.Normal, stateEffect: false }) {
                      Text(item.toString())
                        .fontSize(12)
                    }
                    .padding({
                      left: 4,
                      right: 4,
                      top: 4,
                      bottom: 4
                    })
                    .width(40)
                    .height(25)
                    .backgroundColor(Color.Transparent)
                    .borderWidth(1)
                    .borderColor(this.selectedDifficulty === item ? '#2A86C9' : '#FFFFFF')
                    .fontColor(this.selectedDifficulty === item ? '#288AD1' : '#969799')
                    .borderRadius(25)
                    .onClick(() => {
                      this.articlesList = []
                      this.selectedDifficulty = item;
                      this.getArticleList()
                    })
                  })
                }
              }
              .width("100%")
              .enableScrollInteraction(true)
              .scrollable(ScrollDirection.Horizontal)
              .scrollBar(BarState.Off)
            }
            .width("100%")
            .height(40)
            .padding({ left: 5 })

            // 文章展示
            Refresh({ refreshing: $$this.isRefreshing }) {
              List({ space: 20 }) {
                if (this.articlesList.length <= 0) {
                  ListItem() {
                    Column() {
                      Text("当前难度下没有该类文章，请选择其他难度值")
                        .fontSize(14)
                        .fontColor("#ffc6c6c6")
                    }
                    .height("80%")
                    .justifyContent(FlexAlign.Center)
                    .alignItems(HorizontalAlign.Center)
                  }
                } else {
                  ForEach(this.articlesList, (item: articlesTypeList) => {
                    ListItem() {
                      this.ArticleCardListItem(item.cover, item.title, item.lexile, item.wordNum, item.stage, item.type,
                        item.typeId)
                    }
                  })
                }
              }
              .scrollBarWidth(0)
              .onReachEnd(() => {
                this.currentPage++
                this.getArticleList()
                if (this.articlesList.length >= this.articleTotal) {
                  promptAction.showToast({ message: '已展示所有相关文章' })
                }
              })
              .edgeEffect(EdgeEffect.Spring)
              .width("100%")
            }
            .onRefreshing(() => {
              this.onRefresh()
            })
            .width("75%")
          }
          .alignItems(HorizontalAlign.Start)
          // .justifyContent(FlexAlign.Start)
          .width('100%')
          .height('100%')
          .padding({ bottom: 16, left: 4 })
        }
        .width('100%')
        .height("95%")
        .backgroundColor('#FEFFFF')
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  ArticleCardListItem(cardCover: ResourceStr, cardTitle: string, difficulty: number, wordNum: number, stage: string,
    type: string, typeId: number) {
    Row() {
      // 左侧图片 标题 难度 词汇
      Row() {
        Image(cardCover)
          .width(65)
          .height(60)
          .borderRadius(10)
        Column({ space: 5 }) {
          Row() {
            Text(cardTitle)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxLines(2)
              .fontSize(12)
              .fontWeight(FontWeight.Bolder)
              .width('100%')
          }
          .width(180)

          Row({ space: 5 }) {
            Row({ space: 4 }) {
              Image($r('app.media.icon_start_with_round'))
                .width(12)
              Text(`难度：${difficulty}`)
                .fontSize(12)
                .fontColor("#2288D3")
            }

            Row({ space: 4 }) {
              Image($r('app.media.icon_article'))
                .width(12)
              Text(`${wordNum}词`)
                .fontSize(12)
                .fontColor("#606368")
            }
            // .justifyContent(FlexAlign.S/tart)
            .alignItems(VerticalAlign.Top)
            .width("100%")
          }
        }
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Start)
        .padding({ left: 5, right: 10 })
      }
      .width("100%")
      .padding({
        left: 10,
        right: 20,
        top: 12,
        bottom: 12
      })

      // 右侧阶段标识和类型标识
      if (stage.length > 0) {
        Row() {
          Text(stage)
            .fontSize(10)
            .fontColor("#FEF9F3")
        }
        .justifyContent(FlexAlign.Center)
        .backgroundColor("#F38D45")
        .justifyContent(FlexAlign.Center)
        .width(25)
        .height(20)
        .borderRadius({ topRight: 10 })
        .position({
          right: 0,
          top: 0
        })
        .zIndex(10)
      }
      Row() {
        Text(type)
          .fontSize(10)
          .fontColor("#FEF9F3")
      }
      .justifyContent(FlexAlign.Center)
      // .backgroundColor("#F38D45")
      .backgroundColor(this.cardTypeColor(typeId))
      .width(55)
      .height(14)
      .borderRadius({ topLeft: 10, bottomRight: 10 })
      .position({
        right: 0,
        bottom: 0
      })
      .zIndex(10)
    }
    // .height(100)
    .width("100%")
    .backgroundColor("#F3F6FB")
    .borderRadius(10)
  }
}