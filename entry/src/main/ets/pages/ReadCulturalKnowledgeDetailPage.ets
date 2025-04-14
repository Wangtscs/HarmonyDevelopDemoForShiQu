import { promptAction, router } from '@kit.ArkUI';
import { AVPlayer, http } from '../utils';
import json from '@ohos.util.json';
import { JSON } from '@kit.ArkTS';

interface SentenceByXFListType {
  word: string;
  wb: number;
  we: number;
}

interface WordDataType {
  word: string,
  isActive: boolean,
  index: number
}

interface CulturalKnowledgeDetailContent {
  pageNum: number;
  imgUrl: string;
  audioUrl: string;
  audioDuration: number;
  sentence: string;
  frameType: number;
  sentenceByXFList: SentenceByXFListType[];
}

interface CulturalKnowledgeDetailQuestionAnswerType {
  answer: string;
  audio: string;
}

interface CulturalKnowledgeDetailQuestionType {
  question: string;
  questionAudio: string;
  questionImg: string;
  correctAnswer: string;
  answerList: CulturalKnowledgeDetailQuestionAnswerType[];
}

interface CulturalKnowledgeDetailAllDataType {
  id: number;
  cover: string;
  title: string;
  wordNum: number;
  readCount: number;
  bgmUrl: string;
  typeId: number;
  typeName: string;
  level: number;
  talkItContent: string;
  talkItAudio: string;
  imgList: string[];
  contentList: CulturalKnowledgeDetailContent[];
  questionList: CulturalKnowledgeDetailQuestionType[];
  readReportId: number;
  readId: number;
}

interface culturalKnowledgeListType {
  title: string
  aid: number
}

@Entry
@Component
struct ReadCulturalKnowledgeDetailPage {
  @State currentPage: number = 1
  @State totalPages: number = 0
  @State aid: number = 6
  @State activeWordIndex: number = 0
  @State currentTime: number = 0
  @State currentIndex: number = 0
  @State selectedIndex: number = 0
  @State setTimeId: number = 0
  @State fontsize: number = 18
  @State videoVoiceChange: boolean = true
  @State videoStartChange: boolean = true
  @State relatedFunctionControlComponents: boolean = false
  @State setFontSizeControl: boolean = false
  @State setSpeedControl: boolean = false
  @State pageTitle: string = ''
  @State articleImg: string = ""
  @State speedText: string = "小"
  @State fontText: string = "标准"
  @State speedNumber: number = 1.0
  // 背景音乐url
  @State backgroundMusic: string = ""
  // 文常详细页面所有数据
  @State culturalKnowledgeDetail: CulturalKnowledgeDetailAllDataType = {
    id: 0,
    cover: '',
    title: '',
    wordNum: 0,
    readCount: 0,
    bgmUrl: '',
    typeId: 0,
    typeName: '',
    level: 0,
    talkItContent: '',
    talkItAudio: '',
    imgList: [],
    contentList: [],
    questionList: [],
    readReportId: 0,
    readId: 0
  }
  // 文常详细页面的内容列表（contentList）
  @State culturalKnowledgeDetailContentList: CulturalKnowledgeDetailContent[] = []
  // 所有的文常详细页面的文本音频
  @State culturalKnowledgeContentAllAudioUrl: string[] = []
  // 当前页面的sentenceByXFList
  @State culturalKnowledgeContentSentenceByXFList: SentenceByXFListType[][] = [];
  // 当前页面的所有文字，进行高亮处理
  @State culturalKnowledgeContentWords: WordDataType[][] = [];
  // 添加一个标志来控制音频播放的状态
  @State isAudioPlaying: boolean = false;
  // tab栏控制器
  private controller: TabsController = new TabsController()
  // 背景音乐播放器实例
  private backgroundMusicPlayer: AVPlayer = new AVPlayer();
  // 文本音频播放器实例
  private contentAudioPlayer: AVPlayer = new AVPlayer();

  // 将contentList里面分散的文字整合起来，同时分组
  setCulturalKnowledgeContentSentenceByXFList(culturalKnowledgeDetailContentList: CulturalKnowledgeDetailContent[]) {
    const contentListLength = culturalKnowledgeDetailContentList.length;
    for (let listIndex = 0; listIndex < contentListLength; listIndex++) {
      const sentenceByXFList = culturalKnowledgeDetailContentList[listIndex].sentenceByXFList;
      this.culturalKnowledgeContentSentenceByXFList.push(sentenceByXFList); // 保存处理后的单词数据
    }
    console.log("itcast_interview_pass ReadCulturalKnowledgeDetailPage", '205',
      JSON.stringify(this.culturalKnowledgeContentSentenceByXFList))
  }

  // 将句子按空格拆分并保存处理后的单词数据
  setCulturalKnowledgeContentWords(culturalKnowledgeDetailContentList: CulturalKnowledgeDetailContent[]) {
    const contentListLength = culturalKnowledgeDetailContentList.length;
    for (let listIndex = 0; listIndex < contentListLength; listIndex++) {
      const sentence = culturalKnowledgeDetailContentList[listIndex].sentenceByXFList;
      // 将句子按空格拆分成单词
      const words = sentence.map((sentenceItem) => sentenceItem.word);
      const wordData = words.map((word, index) => ({
        word: word,
        isActive: false, // 默认所有单词不高亮
        index: index
      }) as WordDataType);
      this.culturalKnowledgeContentWords.push(wordData); // 保存处理后的单词数据
      console.log("itcast_interview_pass+", 'ReadCulturalKnowledgeDetailPage', '143',
        this.culturalKnowledgeContentWords);
    }
  }

  // 播放文本音频并同步更新currentTime
  async playContentTextAudio(index: number) {
    if (this.culturalKnowledgeContentAllAudioUrl.length > 0) {
      try {
        this.contentAudioPlayer.stop()
        const audioUrl = this.culturalKnowledgeContentAllAudioUrl[index];
        console.log("准备播放音频:", audioUrl);
        this.contentAudioPlayer.setRelease(false)
        this.contentAudioPlayer.play(audioUrl)

        // 同步更新当前播放时间
        this.syncAudioTime();
        this.isAudioPlaying = true;
      } catch (error) {
        console.error("播放文本音频时出错:", error);
      }
    }
  }

  // 每秒同步一次播放时间
  syncAudioTime() {
    const intervalId = setInterval(() => {
      const currentAudioTime = this.contentAudioPlayer.getTimeUpdate(); // 获取当前音频播放时间
      this.currentTime = Math.floor(currentAudioTime as number); // 更新currentTime为当前音频播放时间的整数部分
      this.highlightCurrentWord(this.currentTime); // 更新高亮显示的单词
      console.log("itcast_interview_pass+", 'ReadCulturalKnowledgeDetailPage', '168', '1');

      // 停止音频播放和定时器的条件
      if (!this.isAudioPlaying ||
        this.activeWordIndex >= this.culturalKnowledgeContentWords[this.currentIndex].length - 1) {
        clearInterval(intervalId); // 停止定时器
        this.onAudioPlayEnd()
        console.log("音频播放结束或已到达边界，停止更新");
      }
    }, 100); // 每100毫秒更新一次
    this.setTimeId = intervalId
  }

  // 当音频播放完毕时，更新状态并停止定时器
  onAudioPlayEnd() {
    this.isAudioPlaying = false; // 标记音频播放已结束
    console.log("音频播放结束，停止更新");
  }

  // 高亮显示当前时间所在的词
  highlightCurrentWord(currentTime: number) {
    const sentenceTimeList = this.culturalKnowledgeContentSentenceByXFList[this.currentIndex];

    // 检查数据是否有效
    if (!sentenceTimeList) {
      console.error("当前索引的时间标记数据无效:", this.currentIndex);
      return; // 如果无效，则直接返回，不进行后续操作
    }

    const words = this.culturalKnowledgeContentWords[this.currentIndex];
    console.log("当前的单词数组:", JSON.stringify(words));

    try {
      if (Array.isArray(words)) {
        // 查找当前时间所在的词
        const activeWordIndex = sentenceTimeList.findIndex(wordData =>
        currentTime >= wordData.wb && currentTime <= wordData.we
        );

        // 如果找到了高亮的词
        if (activeWordIndex !== -1) {
          // 重置所有词为非高亮
          words.forEach(word => word.isActive = false);
          // 高亮当前词
          words[activeWordIndex].isActive = true;
          this.activeWordIndex = activeWordIndex;
        }
      }
      console.log("当前高亮的单词索引:", this.activeWordIndex);
    } catch (e) {
      console.log("高亮单词时出错:", e);
    }
  }

  // 将contentList里面分散的audioUrl整合起来，同时分组
  setCulturalKnowledgeContentAllAudioUrl(culturalKnowledgeDetailContentList: CulturalKnowledgeDetailContent[]) {
    const contentListLength = culturalKnowledgeDetailContentList.length
    for (let listIndex = 0; listIndex < contentListLength; listIndex++) {
      this.culturalKnowledgeContentAllAudioUrl.push(culturalKnowledgeDetailContentList[listIndex].audioUrl)
    }
    this.playContentTextAudio(0)
  }

  // 播放背景音乐
  async playBackgroundMusic() {
    if (this.backgroundMusic) {
      try {
        await this.backgroundMusicPlayer.play(this.backgroundMusic); // 启动背景音乐播放器
        this.backgroundMusicPlayer.setLooping(true); // 启用循环播放
      } catch (error) {
        console.error("itcast_interview_pass+", 'ReadCulturalKnowledgeDetailPage', '243', error)
      }
    }
  }

  // 获取接口数据
  async getCulturalKnowledgeDetail(aid: number) {
    const res = await http.request <Promise<CulturalKnowledgeDetailAllDataType>>({
      baseURL: "https://shiqu.zhilehuo.com/knowledge/article/getArticleDetail",
      params: {
        aid: aid
      },
      headers: {
        'Cookie': 'sid=i5VMMK2c7EEm5qK597kJeDqrel7NKCRqSQRGQn8mJBs='
      }
    })
    this.culturalKnowledgeDetail = res
    this.pageTitle = this.culturalKnowledgeDetail.title
    this.totalPages = this.culturalKnowledgeDetail.contentList.length
    this.culturalKnowledgeDetailContentList = this.culturalKnowledgeDetail.contentList
    this.backgroundMusic = this.culturalKnowledgeDetail.bgmUrl
    this.playBackgroundMusic()
    this.setCulturalKnowledgeContentWords(this.culturalKnowledgeDetailContentList)
    this.setCulturalKnowledgeContentSentenceByXFList(this.culturalKnowledgeDetailContentList)
    this.setCulturalKnowledgeContentAllAudioUrl(this.culturalKnowledgeDetailContentList)
  }

  aboutToAppear(): void {
    const res = router.getParams() as culturalKnowledgeListType
    if (res) {
      const res = router.getParams() as culturalKnowledgeListType
      this.aid = res.aid
      console.log("itcast_interview_pass+", 'ReadCulturalKnowledgeDetailPage', '264', this.aid)
    }
    this.getCulturalKnowledgeDetail(this.aid)
  }

  onPageHide(): void {
    this.backgroundMusicPlayer.pause()
    this.contentAudioPlayer.pause()
    clearInterval(this.setTimeId); // 停止定时器
    this.onAudioPlayEnd()
  }

  onPageShow(): void {
    this.backgroundMusicPlayer.continuePlay()
    this.contentAudioPlayer.continuePlay()
  }

  build() {
    Column() {
      Column({ space: 10 }) {
        // 顶部导航啦
        Row() {
          Image($r('app.media.icon_back_arrow_black'))
            .width(20)
            .onClick(() => {
              router.back()
            })
          Text(this.pageTitle)
            .fontSize(18)
          Blank()
            .width(20)
        }
        .width('100%')
        .justifyContent(FlexAlign.SpaceBetween)
        .padding({
          left: 10,
          right: 10,
          top: 10
        })

        // 进度条
        Row({ space: 10 }) {
          Text(`${this.currentPage}/${this.totalPages}`)
          Progress({ value: this.currentPage, total: this.totalPages, type: ProgressType.Linear })
            .style({ strokeWidth: 4, enableSmoothEffect: true })
            .width("88%")
        }
        .width("90%")

        // 内容展示
        Column() {
          Tabs({ barPosition: BarPosition.Start, index: this.currentIndex, controller: this.controller }) {
            ForEach(this.culturalKnowledgeDetailContentList, (item: CulturalKnowledgeDetailContent, index) => {
              TabContent() {
                Column({ space: 10 }) {
                  Stack({ alignContent: Alignment.Bottom }) {
                    Image(item.imgUrl)
                      .width("100%")
                      .height(200)
                      .borderRadius(20)
                    Row() {
                      // 音量控制按钮
                      Image(this.videoVoiceChange ? $r("app.media.icon_video_voice_normal") :
                      $r('app.media.icon_video_voice_active'))
                        .width(40)
                        .onClick(() => {
                          this.videoVoiceChange = !this.videoVoiceChange
                        })
                      Row({ space: 10 }) {
                        // 重播
                        Image($r('app.media.icon_video_replay'))
                          .width(40)
                          .onClick(() => {
                            this.contentAudioPlayer.rePlay()
                          })
                        // 暂停 or 继续
                        Image(this.videoStartChange ? $r("app.media.icon_video_pause") :
                        $r('app.media.icon_video_continue'))
                          .width(40)
                          .onClick(() => {
                            this.videoStartChange = !this.videoStartChange
                            if (this.videoStartChange) {
                              this.backgroundMusicPlayer.continuePlay()
                              this.contentAudioPlayer.continuePlay()
                            } else {
                              this.backgroundMusicPlayer.pause()
                              this.contentAudioPlayer.pause()
                            }
                          })
                      }
                    }
                    .justifyContent(FlexAlign.SpaceBetween)
                    .padding({
                      bottom: 5
                    })
                    .width("100%")
                  }
                  .width("90%")
                  .height(200)

                  Flex({ direction: FlexDirection.Row, wrap: FlexWrap.Wrap }) {
                    ForEach(this.culturalKnowledgeContentSentenceByXFList[this.currentIndex],
                      (wordData: SentenceByXFListType, index: number) => {
                        Text(wordData.word)
                          .fontColor(index == this.activeWordIndex ? '#F18336' : '#000000')// 高亮单词
                          .fontSize(this.fontsize)
                          .lineHeight(this.fontText == "大" ? 40 : 30)
                          .letterSpacing(12)
                      })
                  }
                  .margin({ left: 20 })
                  .width("95%")
                  .height("100%")
                }
                .alignItems(HorizontalAlign.Center)
                .width('100%')
                .height("100%")
              }
              .width('100%')
              .height('100%')
            })
          }
          .vertical(false)
          .barMode(BarMode.Fixed)
          .barHeight(0)
          .onChange((index: number) => {
            this.currentPage = index + 1
            this.currentIndex = index
            this.contentAudioPlayer.setTabChange(true)
            this.playContentTextAudio(index)
          })
          .fadingEdge(false)
          .width("100%")
          .height('100%')
        }
        .width('100%')
        .height('100%')
      }
      .height('100%')
      .width('100%')
      .onClick(() => {
        this.relatedFunctionControlComponents = !this.relatedFunctionControlComponents
        if (this.setFontSizeControl) {
          this.setFontSizeControl = false
        }
        if (this.setSpeedControl) {
          this.setSpeedControl = false
        }
      })

      // 底部控制组件展示
      if (this.relatedFunctionControlComponents) {
        Row() {
          Column({ space: 10 }) {
            Image($r('app.media.icon_page_turning'))
              .width(30)
            Text('翻页模式')
              .fontSize(14)
          }
          .onClick(() => {
            promptAction.showToast({
              message: '必须完整阅读当前故事后才可开启自动翻页模式'
            })
          })

          Column({ space: 10 }) {
            Stack({ alignContent: Alignment.Center }) {
              Image($r('app.media.icon_speed'))
                .width(30)
              Text("倍速")
                .fontSize(12)
            }

            Text('倍速调整')
              .fontSize(12)
          }
          .onClick(() => {
            this.setSpeedControl = !this.setSpeedControl // 切换倍速控制面板显示状态
          })

          Column({ space: 10 }) {
            Image($r('app.media.icon_font_size'))
              .width(30)
            Text('字体大小')
              .fontSize(14)
          }
          .onClick(() => {
            this.setFontSizeControl = !this.setFontSizeControl // 切换字体大小控制面板显示状态
          })
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor("#F5EEFE")
        .width("90%")
        .borderRadius('40%')
        .padding({
          left: 24,
          right: 24,
          bottom: 16,
          top: 16
        })
        .position({
          left: '50%',
          bottom: 20
        })
        .translate({
          x: "-50%"
        })
        .zIndex(20)
      }

      // 字体大小控制组件展示
      if (this.setFontSizeControl) {
        Row() {
          Column({ space: 10 }) {
            Row({ space: 10 }) {
              Image($r('app.media.icon_font_size'))
                .fillColor('#8371E7')
                .width(14)
              Text("字体大小")
                .fontSize(16)
            }

            Row() {
              Button({ type: ButtonType.Normal }) {
                Text("小")
                  .fontSize(16)
                  .fontColor(this.fontText == "小" ? "#F8FCFF" : "#342F33")
              }
              .onClick(() => {
                this.fontText = "小"
                this.fontsize = 14
              })
              .width(80)
              .height(50)
              .borderRadius(10)
              .backgroundColor(this.fontText == "小" ? "#8371E7" : "#D9CFEA")

              Button({ type: ButtonType.Normal }) {
                Text("标准")
                  .fontSize(16)
                  .fontColor(this.fontText == "标准" ? "#F8FCFF" : "#342F33")
              }
              .onClick(() => {
                this.fontText = "标准"
                this.fontsize = 18
              })
              .width(80)
              .height(50)
              .borderRadius(10)
              .backgroundColor(this.fontText == "标准" ? "#8371E7" : "#D9CFEA")

              Button({ type: ButtonType.Normal }) {
                Text("大")
                  .fontSize(16)
                  .fontColor(this.fontText == "大" ? "#F8FCFF" : "#342F33")
              }
              .onClick(() => {
                this.fontText = "大"
                this.fontsize = 24
              })
              .width(80)
              .height(50)
              .borderRadius(10)
              .backgroundColor(this.fontText == "大" ? "#8371E7" : "#D9CFEA")
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor("#F5EEFE")
        .width("90%")
        .borderRadius('10%')
        .padding({
          left: 24,
          right: 24,
          bottom: 16,
          top: 16
        })
        .position({
          left: '50%',
          bottom: 20
        })
        .translate({
          x: "-50%"
        })
        .zIndex(40)
      }

      // 倍速调整控制组件展示
      if (this.setSpeedControl) {
        Row() {
          Column({ space: 10 }) {
            Row({ space: 10 }) {
              Stack({ alignContent: Alignment.Center }) {
                Image($r('app.media.icon_speed'))
                  .width(24)
                Text(String(this.speedNumber))
                  .fontSize(10)
              }
              Text("倍速调整")
                .fontSize(16)
            }

            Row() {
              Button({ type: ButtonType.Normal }) {
                Text("慢")
                  .fontSize(16)
                  .fontColor(this.speedText == "慢" ? "#F8FCFF" : "#342F33")
              }
              .onClick(() => {
                this.speedText = "慢"
                this.contentAudioPlayer.setSpeed(0)
                this.speedNumber = 0.75
              })
              .width(80)
              .height(50)
              .borderRadius(10)
              .backgroundColor(this.speedText == "慢" ? "#8371E7" : "#D9CFEA")

              Button({ type: ButtonType.Normal }) {
                Text("标准")
                  .fontSize(16)
                  .fontColor(this.speedText == "标准" ? "#F8FCFF" : "#342F33")
              }
              .onClick(() => {
                this.speedText = "标准"
                this.contentAudioPlayer.setSpeed(1)
                this.speedNumber = 1
              })
              .width(80)
              .height(50)
              .borderRadius(10)
              .backgroundColor(this.speedText == "标准" ? "#8371E7" : "#D9CFEA")

              Button({ type: ButtonType.Normal }) {
                Text("快")
                  .fontSize(16)
                  .fontColor(this.speedText == "快" ? "#F8FCFF" : "#342F33")
              }
              .onClick(() => {
                this.speedText = "快"
                this.contentAudioPlayer.setSpeed(2)
                this.speedNumber = 1.25
              })
              .width(80)
              .height(50)
              .borderRadius(10)
              .backgroundColor(this.speedText == "快" ? "#8371E7" : "#D9CFEA")
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .backgroundColor("#F5EEFE")
        .width("90%")
        .borderRadius('10%')
        .padding({
          left: 24,
          right: 24,
          bottom: 16,
          top: 16
        })
        .position({
          left: '50%',
          bottom: 20
        })
        .translate({
          x: "-50%"
        })
        .zIndex(40)
      }

    }
    .height('100%')
    .width('100%')
  }
}