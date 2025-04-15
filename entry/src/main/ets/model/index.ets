export interface articlesTypeList {
  id: number;
  title: string;
  wordNum: number;
  lexile: number;
  typeId: number;
  type: string;
  cover: string;
  clickRatio: null;
  accuracy: null;
  accuracyRatio: null;
  color: string;
  isRead: number;
  readTime: null;
  stage: string;
  perception: null;
}

export interface articlesType {
  total: number
  list: articlesTypeList[]
}

export interface articleTypeListSty {
  id: number
  type: string
}


export interface culturalKnowledgeListType {
  title: string
  aid: number
}


export interface SentenceByXFListType {
  word: string;
  wb: number;
  we: number;
}

export interface WordDataType {
  word: string,
  isActive: boolean,
  index: number
}

export interface CulturalKnowledgeDetailContent {
  pageNum: number;
  imgUrl: string;
  audioUrl: string;
  audioDuration: number;
  sentence: string;
  frameType: number;
  sentenceByXFList: SentenceByXFListType[];
}

export interface CulturalKnowledgeDetailQuestionAnswerType {
  answer: string;
  audio: string;
}

export interface CulturalKnowledgeDetailQuestionType {
  question: string;
  questionAudio: string;
  questionImg: string;
  correctAnswer: string;
  answerList: CulturalKnowledgeDetailQuestionAnswerType[];
}

export interface CulturalKnowledgeDetailAllDataType {
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


