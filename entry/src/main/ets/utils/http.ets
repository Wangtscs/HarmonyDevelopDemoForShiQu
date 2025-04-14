import axios, { AxiosError, AxiosRequestConfig, AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'
import { promptAction, router } from '@kit.ArkUI'

// axios 二次封装
interface Res<T> {
  success: boolean
  code: number
  message: string
  data: T
}

// 请求跟地址+ 超时时长配置
export const baseURL = "https://test.shiqu.zhilehuo.com/englishgpt/"


export const timeout = 10 * 1000

const instance = axios.create({
  baseURL:baseURL,
  timeout
})

// 拦截器：
// 请求发送到服务器之前的一次拦截 - 设置请求配置信息
// 收到服务器响应结果响应之前的一次拦截 - 数据的处理，异常处理
// 分别有两个回调函数，成功和失败
// 成功： 返回一个config, 表示为请求配置（请求头，地址，参数等）
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  return config
}, (err: Error) => {
  promptAction.showToast({
    message: '请求参数错误'
  })
  return Promise.reject(err)
})

// 响应拦截器
instance.interceptors.response.use((res: AxiosResponse) => {
  if (res.data.code === 0) {
    return res.data.data
  }
  return Promise.reject(res.data)
}, (err: AxiosError) => {
  return Promise.reject(err)
})

// ---------------------- 正式的请求部分 ----------------------
class Http {
  // ResponseData是调用时候传递的类型，他表示返回值的类型
  request<ResponseData, RequestData = Object>(config: AxiosRequestConfig<RequestData>) {
    // 1. 只需要传递响应结果的类型即可
    return instance<null, ResponseData, RequestData>(config)
  }
}

export const http = new Http()