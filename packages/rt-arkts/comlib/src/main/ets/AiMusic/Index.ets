import media from '@ohos.multimedia.media'
import { BusinessError } from '@kit.BasicServicesKit'
import { AnyType } from '../types';

/**
 * 播放监听
 */
export interface PlayListener {
  stateChange: (state: PlayState) => void;
  onPlayPosition: (current: number, totalDuration: number) => void;
}

/**
 * 播放状态
 */
export enum PlayState {
  idle,
  initialized,
  prepared,
  playing,
  paused,
  completed,
  stopped,
  released,
  error
}

export class MediaPlayer {
  private TAG: string = "MediaPlayer: ";
  private avPlayer?: media.AVPlayer;
  private playState: PlayState = PlayState.released;
  private listener?: PlayListener;
  private currentUrl: string = '';
  private isJustPrepare: boolean = false;

  private playlist: AnyType[] = []
  public curruntWork: AnyType

  constructor() {
    this.init();
  }

  private init() {
    console.info(this.TAG + "init()");
    media.createAVPlayer().then((player) => {
      this.avPlayer = player;
      this.setupPlayerCallbacks();
    }).catch((err:BusinessError) => {
      console.error(this.TAG + "Failed to create player:", err);
    });
  }


  private setupPlayerCallbacks() {
    if (!this.avPlayer) {
      return;
    }

    // 播放位置更新
    this.avPlayer.on('timeUpdate', (currentTime: number) => {
      if (this.listener) {
        this.listener.onPlayPosition(currentTime, this.avPlayer?.duration || 0);
      }
    });

    // 状态变化
    this.avPlayer.on('stateChange', async (state: string) => {
      console.info(this.TAG + "State changed to:", state);

      if (!this.avPlayer) {
        return;
      }

      this.funcs.forEach(func => {
        func?.(state)
      })

      switch (state) {
        case 'idle':
          this.playState = PlayState.idle;
          break;
        case 'initialized':
          this.playState = PlayState.initialized;
          // 自动准备播放
          await this.avPlayer.prepare();
          break;
        case 'prepared':
          this.playState = PlayState.prepared;
          if (!this.isJustPrepare) {
            await this.avPlayer.play();
          }
          break;
        case 'playing':
          this.playState = PlayState.playing;
          break;
        case 'paused':
          this.playState = PlayState.paused;
          break;
        case 'completed':
          this.playState = PlayState.completed;
          break;
        case 'stopped':
          this.playState = PlayState.stopped;
          break;
        case 'released':
          this.playState = PlayState.released;
          break;
        default:
          break;
      }

      if (this.listener) {
        this.listener.stateChange(this.playState);
      }
    });

    // 错误处理
    this.avPlayer.on('error', (error: BusinessError) => {
      console.error(this.TAG + "Player error:", error);
      this.playState = PlayState.error;
      if (this.avPlayer) {
        this.avPlayer.reset();
      }
      if (this.listener) {
        this.listener.stateChange(this.playState);
      }
    });
  }

  public setPlaylist(list: AnyType[]) {
    if (Array.isArray(list)) {
      this.playlist = list
    }
  }

  public setPlayListener(listener: PlayListener) {
    this.listener = listener;
  }

  public removePlayListener() {
    this.listener = undefined;
  }

  funcs: Set<Function> = new Set()
  onStateChange(func: Function) {
    this.funcs.add(func)
  }

  changefuncs: Set<Function> = new Set()
  onChange(func: Function) {
    this.changefuncs.add(func)
  }

  public async play(work: AnyType) {
    let url: string = ''
    if (work?.file?.cloudFileUrl ?? work?.file?.localFileUrl) {
      url = work?.file?.cloudFileUrl ?? work?.file?.localFileUrl
      this.curruntWork = work
      this.changefuncs.forEach(func => {
        func?.(work)
      })
    }
    console.info(this.TAG + "开始播放, URL:", url);
    const startTime = Date.now();
    this.isJustPrepare = false;

    try {
      if (!this.avPlayer) {
        console.info(this.TAG + "播放器未初始化，正在初始化...");
        this.init();
        return;
      }

      // 如果是同一个URL且处于暂停状态
      if (this.currentUrl === url && this.playState === PlayState.paused) {
        console.info(this.TAG + "恢复暂停的播放");
        await this.avPlayer.play();
        console.info(this.TAG + "恢复播放完成，耗时:", Date.now() - startTime, "ms");
        return;
      }

      // 如果是新的URL，重置seekPosition
      if (this.currentUrl !== url) {
        console.info(this.TAG + "新的URL，重置seekPosition");
        this.seekPosition = 0;
      }

      // 保存当前URL
      this.currentUrl = url;

      // 如果是新的URL或者从播放列表选择，总是重置播放器
      console.info(this.TAG + "开始重置播放器");
      await this.avPlayer.reset();

      // 等待一小段时间确保reset完成
      await new Promise<void>((resolve) => setTimeout(resolve, 100));

      // 设置URL前确保状态正确
      if (this.avPlayer.state !== 'idle') {
        console.info(this.TAG + "等待idle状态...");
        await new Promise<void>((resolve) => setTimeout(resolve, 500));
      }

      console.info(this.TAG + "设置URL");
      this.avPlayer.url = url;

      // 等待initialized状态
      await new Promise<void>((resolve) => setTimeout(resolve, 100));

      // prepare前确保状态正确
      if (this.avPlayer.state !== 'initialized') {
        console.info(this.TAG + "等待initialized状态...");
        await new Promise<void>((resolve) => setTimeout(resolve, 500));
      }

      console.info(this.TAG + "准备播放器");
      const prepareStartTime = Date.now();
      await this.avPlayer.prepare();
      console.info(this.TAG + "播放器准备完成，耗时:", Date.now() - prepareStartTime, "ms");

      // 如果有保存的跳转位置，先seek再播放
      if (this.seekPosition > 0) {
        console.info(this.TAG + "跳转到指定位置:", this.seekPosition);
        await this.avPlayer.seek(this.seekPosition);
        this.seekPosition = 0; // 重置跳转位置
      }

      console.info(this.TAG + "开始播放");
      await this.avPlayer.play();
      console.info(this.TAG + "播放开始，总耗时:", Date.now() - startTime, "ms");
    } catch (error) {
      console.error(this.TAG + "Failed to play:", error);
      this.playState = PlayState.error;
      if (this.listener) {
        this.listener.stateChange(this.playState);
      }
    }
  }

  public async pause() {
    console.info(this.TAG + "pause");
    if (this.avPlayer && this.playState === PlayState.playing) {
      try {
        await this.avPlayer.pause();
      } catch (error) {
        console.error(this.TAG + "Failed to pause:", error);
      }
    }
  }

  public async resume() {
    console.info(this.TAG + "resume");
    if (!this.avPlayer) {
      return;
    }

    try {
      switch (this.playState) {
        case PlayState.paused:
          // 如果在暂停状态下有保存的跳转位置，先执行seek
          if (this.seekPosition > 0) {
            console.info(this.TAG + "从暂停状态恢复，先跳转到:", this.seekPosition);
            await this.avPlayer.seek(this.seekPosition);
            this.seekPosition = 0; // 重置跳转位置
          }
          await this.avPlayer.play();
          break;
        case PlayState.prepared:
        case PlayState.completed:
          await this.avPlayer.play();
          break;
        case PlayState.idle:
          if (this.currentUrl) {
            await this.avPlayer.reset();
            this.avPlayer.url = this.currentUrl;
          }
          break;
        default:
          console.info(this.TAG + "Cannot resume in current state:", this.playState);
          break;
      }
    } catch (error) {
      console.error(this.TAG + "Failed to resume:", error);
    }
  }

  private seekPosition: number = 0;

  public async seek(timeMs: number) {
    console.info(this.TAG + "seek to:", timeMs);
    if (!this.avPlayer) {
      return;
    }

    try {
      // 检查时间是否有效
      if (timeMs < 0 || timeMs > (this.avPlayer.duration || 0)) {
        console.error(this.TAG + "Invalid seek time:", timeMs, "duration:", this.avPlayer.duration);
        return;
      }

      // 保存要跳转的位置
      this.seekPosition = timeMs;

      // 记录当前是否在播放
      const wasPlaying = this.playState === PlayState.playing;

      // 如果播放器不在正确状态，需要先准备
      if (this.playState === PlayState.idle || this.playState === PlayState.initialized) {
        if (!this.currentUrl) {
          console.error(this.TAG + "No URL set");
          return;
        }
        await this.avPlayer.reset();
        this.avPlayer.url = this.currentUrl;
        await this.avPlayer.prepare();
      }

      // 无论什么状态都执行seek
      await this.avPlayer.seek(timeMs, media.SeekMode.SEEK_NEXT_SYNC);

      // 等待一小段时间确保seek完成
      await new Promise<void>((resolve) => setTimeout(resolve, 50));

      // 如果之前在播放，确保继续播放
      if (wasPlaying) {
        await this.avPlayer.play();
      }

      // 通知时间更新，以更新UI显示
      if (this.listener) {
        this.listener.onPlayPosition(timeMs, this.avPlayer.duration || 0);
      }
    } catch (error) {
      console.error(this.TAG + "Failed to seek:", error);
      // 如果seek失败，尝试重新初始化播放器
      try {
        if (this.currentUrl) {
          await this.avPlayer.reset();
          this.avPlayer.url = this.currentUrl;
          await this.avPlayer.prepare();
          await this.avPlayer.seek(timeMs);
          if (this.playState === PlayState.playing) {
            await this.avPlayer.play();
          } else if (this.playState === PlayState.paused) {
            await this.avPlayer.play();
            await this.avPlayer.pause();
          }
        }
      } catch (retryError) {
        console.error(this.TAG + "Failed to retry seek:", retryError);
      }
    }
  }

  public async stop() {
    console.info(this.TAG + "stop");
    if (this.avPlayer) {
      try {
        await this.avPlayer.stop();
      } catch (error) {
        console.error(this.TAG + "Failed to stop:", error);
      }
    }
  }

  public async release() {
    console.info(this.TAG + "release");
    if (this.avPlayer) {
      try {
        await this.avPlayer.release();
        this.avPlayer = undefined;
        this.currentUrl = '';
      } catch (error) {
        console.error(this.TAG + "Failed to release:", error);
      }
    }
  }

  public getCurrentTime(): number {
    try {
      return this.avPlayer?.currentTime || 0;
    } catch (error) {
      console.error(this.TAG + "Failed to get current time:", error);
      return 0;
    }
  }

  public getDuration(): number {
    try {
      return this.avPlayer?.duration || 0;
    } catch (error) {
      console.error(this.TAG + "Failed to get duration:", error);
      return 0;
    }
  }

  public getPlayState(): PlayState {
    return this.playState;
  }
}


export const mediaPlayer = new MediaPlayer()