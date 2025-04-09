interface articlesType {
  id: number
  title: string
  wordNum: number
  lexile: number
  typeId: number
  type: string
  // "cover": "https://shiqu-img.qn.zhilehuo.com/advEnglish/classify/0_1724749220965_339.jpg?imageMogr2/gravity/Center/crop/1024x770",
  cover: string
  clickRatio: null
  accuracy: null
  accuracyRatio: null
  color: null
  isRead: number
  readTime: null
  stage: string
  perception: null
}

interface articleTypeListSty {
  id: number
  type: string
}


@Entry
@Component
struct LibraryPage {
  @State selectedDifficulty: number = 5; // 默认选中的难度值
  @State selectedArticleTip: string = "精选阅读"
  @State categories: articleTypeListSty[] = [
    {
      "id": 0,
      "type": "精选阅读"
    },
    {
      "id": 1,
      "type": "人工智能"
    },
    {
      "id": 2,
      "type": "前沿技术"
    },
    {
      "id": 3,
      "type": "太空宇宙"
    },
    {
      "id": 4,
      "type": "生物医疗"
    },
    {
      "id": 5,
      "type": "自然科学"
    },
    {
      "id": 6,
      "type": "环境生态"
    },
    {
      "id": 7,
      "type": "历史文化"
    },
    {
      "id": 8,
      "type": "艺术文学"
    },
    {
      "id": 9,
      "type": "休闲生活"
    },
    {
      "id": 10,
      "type": "社会现象"
    },
    {
      "id": 11,
      "type": "成长教育"
    },
    {
      "id": 12,
      "type": "心理情感"
    },
    {
      "id": 13,
      "type": "动物趣闻"
    },
    {
      "id": 14,
      "type": "传统文化"
    }
  ];
  @State articles: articlesType[] = [{
    "id": 4976,
    "title": " The Principles and Applications of Quantum Computers",
    "wordNum": 337,
    "lexile": 650,
    "typeId": 2,
    "type": "前沿技术",
    "cover": "https://shiqu-img.qn.zhilehuo.com/advEnglish/classify/0_1724749220965_339.jpg?imageMogr2/gravity/Center/crop/1024x770",
    "clickRatio": null,
    "accuracy": null,
    "accuracyRatio": null,
    "color": null,
    "isRead": 0,
    "readTime": null,
    "stage": "18+",
    "perception": null
  },
    {
      "id": 5021,
      "title": " Basic Concepts of Quantum Mechanics",
      "wordNum": 413,
      "lexile": 650,
      "typeId": 2,
      "type": "前沿技术",
      "cover": "https://shiqu-img.qn.zhilehuo.com/advEnglish/classify/0_1724749360513_601.jpg?imageMogr2/gravity/Center/crop/1024x770",
      "clickRatio": null,
      "accuracy": null,
      "accuracyRatio": null,
      "color": null,
      "isRead": 0,
      "readTime": null,
      "stage": "18+",
      "perception": null
    },];
  @State selectList: number[] =
    [5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135,
      140, 145, 150, 155, 160, 165, 170, 175, 180, 185, 190, 195, 200, 205, 210, 215, 220, 225, 230, 235, 240, 245, 250,
      255, 260, 265, 270, 275, 280, 285, 290, 295, 300, 305, 310, 315, 320, 325, 330, 335, 340, 345, 350, 355, 360, 365,
      370, 375, 380, 385, 390, 395, 400, 405, 410, 415, 420, 425, 430, 435, 440, 445, 450, 455, 460, 465, 470, 475, 480,
      485, 490, 495, 500, 505, 510, 515, 520, 525, 530, 535, 540, 545, 550, 555, 560, 565, 570, 575, 580, 585, 590, 595,
      600, 605, 610, 615, 620, 625, 630, 635, 640, 645, 650, 655, 660, 665, 670, 675, 680, 685, 690, 695, 700, 705, 710,
      715, 720, 725, 730, 735, 740, 745, 750, 755, 760, 765, 770, 775, 780, 785, 790, 795, 800]
  private controller: TabsController = new TabsController()
  scroller: Scroller = new Scroller()

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
          center: [140, -50],
          radius: 180,
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
                  this.selectedArticleTip = item.type
                  console.log("itcast_interview_pass+", 'LibraryPage', '106', item.type)
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
                  this.selectedArticleTip = item.type
                  console.log("itcast_interview_pass+", 'LibraryPage', '106', item.type)
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
                      this.selectedDifficulty = item;
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
            List({ space: 20 }) {
              ForEach(this.articles, (item: articlesType) => {
                ListItem() {
                  this.ArticleCardListItem(item.cover, item.title, item.lexile, item.wordNum, item.stage, item.type)
                }
              })
            }
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

        // 文章列表
        //   Column({ space: 16 }) {
        //     ForEach(this.articles, (article: articlesType) => {
        //       Column({ space: 8 }) {
        //         Text(article.title)
        //           .fontSize(16)
        //           .fontWeight(FontWeight.Bold)
        //           .fontColor('#333333')
        //           .width('100%')
        //
        //         Row() {
        //           Text('难度:' + article.difficulty)
        //             .fontSize(12)
        //             .fontColor('#666666')
        //
        //           Text(article.words + '词')
        //             .fontSize(12)
        //             .fontColor('#666666')
        //             .margin({ left: 8 })
        //
        //           Text(article.category)
        //             .fontSize(12)
        //             .fontColor('#666666')
        //             .margin({ left: 8 })
        //         }
        //         .width('100%')
        //       }
        //       .width('100%')
        //       .padding(16)
        //       .backgroundColor('#FFFFFF')
        //       .borderRadius(12)
        //     })
        //   }
        //   .width('90%')
        //   .margin({ bottom: 24 })
        // }
        // .width('100%')
        // .alignItems(HorizontalAlign.Center)
        // .backgroundColor('#F7F8FA')
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  ArticleCardListItem(cardCover: ResourceStr, cardTitle: string, difficulty: number, wordNum: number, stage: string,
    type: string) {
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

      Row() {
        Text(type)
          .fontSize(10)
          .fontColor("#FEF9F3")
      }
      .justifyContent(FlexAlign.Center)
      .backgroundColor("#F38D45")
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