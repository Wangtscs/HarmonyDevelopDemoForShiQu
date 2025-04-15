import { media } from '@kit.MediaKit';
import { audio } from '@kit.AudioKit';

export class AVPlayer {
  private isLooping: boolean = false; // 是否循环播放
  private avplayer: media.AVPlayer | null = null; // 初始为 null
  private isRelease: boolean = true; // 是否在播放完毕后释放资源
  private tabChange: boolean = false;
  private isOver: boolean = false;

  // 异步方法来创建并返回 AVPlayer
  async createPlayer(url: string): Promise<void> {
    try {
      const avPlayer = await media.createAVPlayer(); // 等待 Promise 返回的 AVPlayer
      avPlayer.url = url;
      this.avplayer = avPlayer; // 将返回的 AVPlayer 实例赋值给 avplayer
      this.setAVPlayerCallback(avPlayer, url);
    } catch (error) {
      console.error('创建 AVPlayer 时出错', error);
    }
  }

  // 设置循环播放
  setLooping(loop: boolean) {
    this.isLooping = loop;
  }

  // 设置在播放完毕后释放资源
  setRelease(release: boolean) {
    this.isRelease = release;
  }

  // 设置在播放完毕后释放资源
  setTabChange(tabChange: boolean) {
    this.tabChange = tabChange;
  }

  setAVPlayerCallback(avPlayer: media.AVPlayer, url: string) {
    avPlayer.on('stateChange', async (state: string, reason: media.StateChangeReason) => {
      console.log(`itcast_interview_pass: AVPlayer 状态变化: ${state}，原因: ${reason}`);
      switch (state) {
        case 'idle':
          console.info('itcast_interview_pass: AVPlayer 状态: idle，准备好释放资源');
          avPlayer.release(); // 销毁实例
          break;

        case 'initialized':
          console.info('itcast_interview_pass: AVPlayer 状态: initialized，准备音频播放器');
          // avPlayer.url = url
          // console.log("itcast_interview_pass+", 'AVPlayer', '50', avPlayer.url)
          avPlayer.audioRendererInfo = {
            usage: audio.StreamUsage.STREAM_USAGE_MUSIC, // 设置音频流使用类型
            rendererFlags: 0
          };
          avPlayer.prepare();
          break;

        case 'prepared':
          console.info('itcast_interview_pass: AVPlayer 状态: prepared，播放器准备好');
          this.tabChange = false
          this.isOver = false
          avPlayer.play(); // 开始播放
          break;

        case 'playing':
          console.info('itcast_interview_pass: AVPlayer 状态: playing，音频播放中');
          break;

        case 'paused':
          console.info('itcast_interview_pass: AVPlayer 状态: paused');
          break;

        case 'completed':
          console.info('itcast_interview_pass: AVPlayer 状态: completed，音频播放完成');
          this.isOver = true
          if (this.isLooping) {
            avPlayer.seek(0); // 循环播放时，播放结束后从头开始
            avPlayer.play()
          } else if (!this.isRelease) {
            if (this.tabChange) {
              avPlayer.pause()
              avPlayer.url = url
              console.log("itcast_interview_pass+", 'AVPlayer', '81', '改变tab栏后，播放新的音频：' + avPlayer.url)
              avPlayer.play()
            } else {
              avPlayer.pause()
            }
          } else {
            avPlayer.stop(); // 正常结束播放
          }
          break;

        case 'stopped':
          console.info('itcast_interview_pass: AVPlayer 状态: stopped，音频停止播放');
          avPlayer.reset(); // 停止后重置
          break;

        case 'released':
          console.info('itcast_interview_pass: AVPlayer 状态: released，音频资源已释放');
          console.log("itcast_interview_pass+", 'AVPlayer', '84', this.isRelease)
          if (this.isRelease) {
            console.info('itcast_interview_pass: AVPlayer 状态: released，音频资源已释放');
            avPlayer.release()
          } else {
            console.info('itcast_interview_pass: AVPlayer 状态: released，音频资源播放完毕但暂停');
            avPlayer.prepare()
          }
          break;

        default:
          console.info('itcast_interview_pass: AVPlayer 状态未知');
          break;
      }
    });
  }

  getTimeUpdate(): number | undefined {
    if (this.avplayer && this.avplayer.currentTime !== undefined) {
      return this.avplayer.currentTime as number; // 假设 currentTime 是 number 类型
    }
    return undefined; // 如果 avplayer 不存在或 currentTime 未定义，返回 undefined
  }


  // 停止播放
  async stop() {
    if (this.avplayer) {
      await this.avplayer.stop();
    }
  }

  // 播放
  async play(url: string) {
    if (this.avplayer) {
      await this.avplayer.stop();
    }
    await this.createPlayer(url); // 在播放前确保 AVPlayer 已创建
    if (this.avplayer) {
      await this.avplayer.play();
    }
    if (!this.isRelease) {
      this.reset()
    }
  }

  // 暂停后继续播放
  async continuePlay() {
    if (this.avplayer) {
      await this.avplayer.play();
    }
  }

  // 暂停
  async pause() {
    if (this.avplayer) {
      await this.avplayer.pause();
    }
  }

  // 释放资源
  async reset() {
    if (this.avplayer) {
      await this.avplayer.reset();
    }
  }

  // 从头开始播放
  rePlay() {
    if (this.avplayer) {
      this.avplayer.seek(0)
      this.isOver = false
      this.avplayer.play()
    }
  }

  // 设置播放速度
  setSpeed(speed: media.PlaybackSpeed) {
    if (this.avplayer) {
      this.avplayer.setSpeed(speed)
    }
  }

  // 获取当前音频是否播放完毕
  getVideoStateIsOver(){
    return this.isOver
  }
}
