import media from '@ohos.multimedia.media'
import { BusinessError } from '@kit.BasicServicesKit'
import { PlayMode } from '../model/AppMusicPlayerModel'
import { WorksItemWithLabelsModel } from '../bean/AppMusicWorksItemWithLabelsModel'
import { WorksItemModel } from '../bean/AppMusicWorksItemModel'
import { LyricLine, LyricData } from '../model/AppMusicLyricModel'
import { AnyType } from '@mybricks/render-utils/src/main/ets/types/any'

/**
 * 播放监听
 */
export interface PlayListener {
  stateChange: (state: PlayState) => void;
  onPlayPosition: (current: number, totalDuration: number) => void;
  musicChange: (musicInfo: WorksItemWithLabelsModel) => void;
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


class MediaPlayer {
  static TAG: string = "MediaPlayer: ";
  static avPlayer?: media.AVPlayer;
  static playState: PlayState = PlayState.released;
  static listener?: Map<string, (data: ESObject) => void> = new Map();
  static currentUrl: string = '';
  static isJustPrepare: boolean = false;
  static playlist: WorksItemWithLabelsModel[] = []; // 播放列表
  static currentIndex: number = 0;
  static playMode: PlayMode = PlayMode.SEQUENCE; // 播放模式
  static currentSong: WorksItemWithLabelsModel = new WorksItemWithLabelsModel(new WorksItemModel());
  static currentLineIndex: number = 0 // 每句歌词的索引
  static lrcDuration: number = 0 // 歌词持续时间
  static isPlaying: boolean = false
  static currentTime: number = 0
  static currentLyricIndex: number = 0
  static duration: number = 0 // 单位：秒
  static lyrics: LyricLine[] = []
  static sliderValue: number = 0 // 进度条值
  static lyricListScroller: Scroller = new Scroller()
  static isRotating: boolean = false // 控制黑胶是否在旋转
  static rotationAngle: number = 0 // 当前旋转角度
  static needleRotation: number = 0 // 唱针旋转角度

  constructor() {
    MediaPlayer.init();
  }

  static async init() {
    console.info(MediaPlayer.TAG + "init()");
    return new Promise<void>((resolve) => {
      if (!MediaPlayer.avPlayer) {
        console.info(MediaPlayer.TAG + "播放器未初始化，正在初始化...");
        media.createAVPlayer().then((player) => {
          MediaPlayer.avPlayer = player;
          MediaPlayer.setupPlayerCallbacks();
        }).catch((err:BusinessError) => {
          console.error(MediaPlayer.TAG + "Failed to create player:", err);
        }).finally(() => {
          resolve()
        });
      } else {
        resolve()
      }
    })
    media.createAVPlayer().then((player) => {
      MediaPlayer.avPlayer = player;
      MediaPlayer.setupPlayerCallbacks();
    }).catch((err:BusinessError) => {
      console.error(MediaPlayer.TAG + "Failed to create player:", err);
    });
  }

  static setupPlayerCallbacks() {
    if (!MediaPlayer.avPlayer) {
      return;
    }

    // 播放位置更新
    MediaPlayer.avPlayer.on('timeUpdate', (currentTime: number) => {
      if (MediaPlayer.listener) {
        // MediaPlayer.listener.onPlayPosition(currentTime, MediaPlayer.avPlayer?.duration || 0);
        MediaPlayer.listener.get('onPlayPosition')?.({ currentTime, totalDuration: MediaPlayer.avPlayer?.duration || 0 })
      }
    });

    // 状态变化
    MediaPlayer.avPlayer.on('stateChange', async (state: string) => {
      console.info(MediaPlayer.TAG + "State changed to:", state);

      if (!MediaPlayer.avPlayer) {
        return;
      }

      switch (state) {
        case 'idle':
          MediaPlayer.playState = PlayState.idle;
          break;
        case 'initialized':
          MediaPlayer.playState = PlayState.initialized;
          // 自动准备播放
          await MediaPlayer.avPlayer.prepare();
          break;
        case 'prepared':
          MediaPlayer.playState = PlayState.prepared;
          if (!MediaPlayer.isJustPrepare) {
            await MediaPlayer.avPlayer.play();
          }
          break;
        case 'playing':
          MediaPlayer.playState = PlayState.playing;
          break;
        case 'paused':
          MediaPlayer.playState = PlayState.paused;
          break;
        case 'completed':
          MediaPlayer.playState = PlayState.completed;
          break;
        case 'stopped':
          MediaPlayer.playState = PlayState.stopped;
          break;
        case 'released':
          MediaPlayer.playState = PlayState.released;
          break;
        default:
          break;
      }

      if (MediaPlayer.listener) {
        MediaPlayer.listener.get('stateChange')?.(MediaPlayer.playState)
      }
    });

    // 错误处理
    MediaPlayer.avPlayer.on('error', (error: BusinessError) => {
      console.error(MediaPlayer.TAG + "Player error:", error);
      MediaPlayer.playState = PlayState.error;
      if (MediaPlayer.avPlayer) {
        MediaPlayer.avPlayer.reset();
      }
      if (MediaPlayer.listener) {
        MediaPlayer.listener.get('stateChange')?.(MediaPlayer.playState)
      }
    });
  }

  private static  funcsMap : Map<string, Array<(data: AnyType) => void>> = new Map();
  static setPlayListener(eventName: string, func: (data: ESObject) => void) {
    if (!MediaPlayer.listener?.has(eventName)) {
      MediaPlayer.listener?.set(eventName, (params: ESObject) => {
        const funcs : AnyType = MediaPlayer.funcsMap?.get(eventName);
        if (funcs.length) {
          funcs.forEach((fun: AnyType) => {
            fun?.(params)
          })
        }
      })
    }
    if (!Array.isArray(MediaPlayer.funcsMap?.get(eventName))) {
      MediaPlayer.funcsMap?.set(eventName, [func]);
    } else {
      const newFuncs = MediaPlayer.funcsMap?.get(eventName) || []
      newFuncs?.push(func)
      MediaPlayer.funcsMap?.set(eventName, newFuncs);
    }
  }

  public removePlayListener() {
    MediaPlayer.listener = undefined;
  }

  static async play(url: string) {
    console.info(MediaPlayer.TAG + "开始播放, URL:", url);
    const startTime = Date.now();
    MediaPlayer.isJustPrepare = false;

    try {
      await MediaPlayer.init();

      if (!MediaPlayer.avPlayer) {
        return
      }

      // 如果是同一个URL且处于暂停状态
      if (MediaPlayer.currentUrl === url && MediaPlayer.playState === PlayState.paused) {
        console.info(MediaPlayer.TAG + "恢复暂停的播放");
        await MediaPlayer.avPlayer.play();
        console.info(MediaPlayer.TAG + "恢复播放完成，耗时:", Date.now() - startTime, "ms");
        return;
      }

      // 如果是新的URL，重置seekPosition
      if (MediaPlayer.currentUrl !== url) {
        console.info(MediaPlayer.TAG + "新的URL，重置seekPosition");
        MediaPlayer.seekPosition = 0;
      }

      // 保存当前URL
      MediaPlayer.currentUrl = url;

      // 如果是新的URL或者从播放列表选择，总是重置播放器
      console.info(MediaPlayer.TAG + "开始重置播放器");
      await MediaPlayer.avPlayer.reset();

      // 等待一小段时间确保reset完成
      await new Promise<void>((resolve) => setTimeout(resolve, 100));

      // 设置URL前确保状态正确
      if (MediaPlayer.avPlayer.state !== 'idle') {
        console.info(MediaPlayer.TAG + "等待idle状态...");
        await new Promise<void>((resolve) => setTimeout(resolve, 500));
      }

      console.info(MediaPlayer.TAG + "设置URL");
      MediaPlayer.avPlayer.url = url;

      // 等待initialized状态
      await new Promise<void>((resolve) => setTimeout(resolve, 100));

      // prepare前确保状态正确
      if (MediaPlayer.avPlayer.state !== 'initialized') {
        console.info(MediaPlayer.TAG + "等待initialized状态...");
        await new Promise<void>((resolve) => setTimeout(resolve, 500));
      }

      console.info(MediaPlayer.TAG + "准备播放器");
      const prepareStartTime = Date.now();
      await MediaPlayer.avPlayer.prepare();
      console.info(MediaPlayer.TAG + "播放器准备完成，耗时:", Date.now() - prepareStartTime, "ms");

      // 如果有保存的跳转位置，先seek再播放
      if (MediaPlayer.seekPosition > 0) {
        console.info(MediaPlayer.TAG + "跳转到指定位置:", MediaPlayer.seekPosition);
        await MediaPlayer.avPlayer.seek(MediaPlayer.seekPosition);
        MediaPlayer.seekPosition = 0; // 重置跳转位置
      }

      console.info(MediaPlayer.TAG + "开始播放");
      await MediaPlayer.avPlayer.play();
      console.info(MediaPlayer.TAG + "播放开始，总耗时:", Date.now() - startTime, "ms");
    } catch (error) {
      console.error(MediaPlayer.TAG + "Failed to play:", error);
      MediaPlayer.playState = PlayState.error;
      if (MediaPlayer.listener) {
        MediaPlayer.listener.get('stateChange')?.(MediaPlayer.playState)
      }
    }
  }

  static async pause() {
    console.info(MediaPlayer.TAG + "pause");
    if (MediaPlayer.avPlayer && MediaPlayer.playState === PlayState.playing) {
      try {
        await MediaPlayer.avPlayer.pause();
      } catch (error) {
        console.error(MediaPlayer.TAG + "Failed to pause:", error);
      }
    }
  }

  // 获取下一个索引
  static getNextIndex(direction: 'prev' | 'next'): number {
    if (MediaPlayer.playlist.length === 0) return 0

    let nextIndex: number = MediaPlayer.currentIndex
    switch (MediaPlayer.playMode) {
      case PlayMode.SEQUENCE:
        if (direction === 'next') {
          nextIndex = (MediaPlayer.currentIndex + 1) % MediaPlayer.playlist.length
        } else {
          nextIndex = (MediaPlayer.currentIndex - 1 + MediaPlayer.playlist.length) % MediaPlayer.playlist.length
        }
        break
      case PlayMode.SINGLE:
        // 单曲循环模式下也允许手动切换
        if (direction === 'next') {
          nextIndex = (MediaPlayer.currentIndex + 1) % MediaPlayer.playlist.length
        } else {
          nextIndex = (MediaPlayer.currentIndex - 1 + MediaPlayer.playlist.length) % MediaPlayer.playlist.length
        }
        break
      case PlayMode.RANDOM:
        // 随机选择一首，但避免重复
        nextIndex = Math.floor(Math.random() * MediaPlayer.playlist.length)
        if (nextIndex === MediaPlayer.currentIndex && MediaPlayer.playlist.length > 1) {
          nextIndex = (nextIndex + 1) % MediaPlayer.playlist.length
        }
        break
    }
    return nextIndex
  }

  // 切换到指定歌曲
  static async switchToSong(index: number) {
    try {
      console.info('开始切换歌曲，索引:', index);
      const startTime = Date.now();

      // 停止当前播放
      await MediaPlayer.stop();
      MediaPlayer.stopVinylRotation();

      MediaPlayer.currentIndex = index;
      MediaPlayer.currentSong = MediaPlayer.playlist[MediaPlayer.currentIndex];
      console.info('切换到歌曲:', MediaPlayer.currentSong.file.title);
      console.info('歌曲URL:', MediaPlayer.currentSong.file.cloudFileUrl);

      MediaPlayer.lyrics = []; // 清空当前歌词
      MediaPlayer.currentLyricIndex = 0; // 重置歌词索引
      MediaPlayer.currentTime = 0; // 重置当前时间
      MediaPlayer.sliderValue = 0; // 重置进度条
      MediaPlayer.duration = MediaPlayer.currentSong.file.duration; // 更新总时长

      console.info('开始解析歌词');
      const lyricStartTime = Date.now();
      MediaPlayer.parseLyrics(); // 解析新歌词
      console.info('歌词解析完成，耗时:', Date.now() - lyricStartTime, 'ms');

      // 滚动歌词到顶部
      MediaPlayer.lyricListScroller.scrollTo({ xOffset: 0, yOffset: 0 });

      // 播放新歌曲
      if (MediaPlayer.currentSong?.file?.cloudFileUrl) {
        console.info('开始播放新歌曲');
        // 先重置播放器
        await MediaPlayer.stop();
        await MediaPlayer.play(MediaPlayer.currentSong.file.cloudFileUrl);
        if (MediaPlayer.listener) {
          MediaPlayer.listener.get('onChange')?.(index)
        }
        MediaPlayer.isPlaying = true;
        MediaPlayer.startVinylRotation();
        console.info('切换歌曲完成，总耗时:', Date.now() - startTime, 'ms');
      }
    } catch (error) {
      console.error('Failed to switch song:', error);
      MediaPlayer.isPlaying = false;
      MediaPlayer.stopVinylRotation();
    }
  }

  // 播放上一首
  static async playPrevious() {
    if (MediaPlayer.playlist.length === 0) return
    await MediaPlayer.switchToSong(MediaPlayer.getNextIndex('prev'))
  }

  // 播放下一首
  static async playNext() {
    if (MediaPlayer.playlist.length === 0) return
    await MediaPlayer.switchToSong(MediaPlayer.getNextIndex('next'))
  }

  // 自动播放下一首（根据播放模式）
  static async autoPlayNext() {
    if (MediaPlayer.playlist.length === 0) return

    switch (MediaPlayer.playMode) {
      case PlayMode.SEQUENCE:
        await MediaPlayer.playNext()
        break
      case PlayMode.SINGLE:
        // 单曲循环模式下重新播放当前歌曲
        if (MediaPlayer.currentSong?.file?.cloudFileUrl) {
          await MediaPlayer.play(MediaPlayer.currentSong.file.cloudFileUrl)
        }
        break
      case PlayMode.RANDOM:
        await MediaPlayer.playNext() // 使用 playNext 中的随机逻辑
        break
    }
  }

  static setPlayList(playlist: WorksItemWithLabelsModel[]) {
    MediaPlayer.playlist = playlist;
  }

  // 从播放列表选择歌曲
  static async selectSong(index: number) {
    try {
      // 重置UI状态
      MediaPlayer.currentTime = 0;
      MediaPlayer.sliderValue = 0;
      MediaPlayer.currentLyricIndex = 0;

      // 切换到新歌或重新播放当前歌
      if (index === MediaPlayer.currentIndex) {
        // 如果是同一首歌，就seek到开头
        await MediaPlayer.seek(0);
        MediaPlayer.updateLyricIndex();
      } else {
        // 切换到新歌
        await MediaPlayer.switchToSong(index);
      }

      // 关闭播放列表
      // this.showPlaylist = false;
    } catch (error) {
      console.error('Failed to select song:', error);
    }
  }

  // 解析歌词
  static parseLyrics() {
    if (!MediaPlayer.currentSong?.file?.lyricCaptions) {
      return
    }

    try {
      const lyricData: LyricData = JSON.parse(MediaPlayer.currentSong.file.lyricCaptions)
      const utterances = lyricData.utterances || []

      // 转换为歌词行
      const parsedLyrics: LyricLine[] = []
      for (const utterance of utterances) {
        if (!utterance.text.startsWith('[') && !utterance.text.endsWith(']')) {
          parsedLyrics.push({
            time: utterance.start_time / 1000,
            text: utterance.text
          })
        }
      }
      MediaPlayer.lyrics = parsedLyrics.sort((a, b) => a.time - b.time)

    } catch (error) {
      console.error('Failed to parse lyrics:', error)
    }
  }

  // 更新当前歌词索引
  static updateLyricIndex() {
    for (let i = MediaPlayer.lyrics.length - 1; i >= 0; i--) {
      if (MediaPlayer.currentTime >= MediaPlayer.lyrics[i].time) {
        if (MediaPlayer.currentLyricIndex !== i) {
          MediaPlayer.currentLyricIndex = i
          // 滚动到当前歌词
          MediaPlayer.lyricListScroller.scrollToIndex(i)
        }
        break
      }
    }
  }

  // 开始黑胶旋转动画
  static startVinylRotation() {
    MediaPlayer.isRotating = true
    // 启动旋转动画
    MediaPlayer.startRotationAnimation()
    // 唱针放下动画使用更自然的曲线
    animateTo({
      duration: 600,
      curve: Curve.EaseInOut,
      delay: 100 // 添加一点延迟，让动作更自然
    }, () => {
      MediaPlayer.needleRotation = 13
    })
  }

  // 停止黑胶旋转动画
  static stopVinylRotation() {
    MediaPlayer.isRotating = false
    // 唱针抬起动画也使用更自然的曲线
    animateTo({
      duration: 500,
      curve: Curve.EaseInOut
    }, () => {
      MediaPlayer.needleRotation = 0
    })
  }

  // 启动旋转动画
  static startRotationAnimation() {
    if (MediaPlayer.isRotating) {
      animateTo({
        duration: 20,
        curve: Curve.Linear
      }, () => {
        MediaPlayer.rotationAngle = MediaPlayer.rotationAngle + 1
      })
      setTimeout(() => {
        if (MediaPlayer.isRotating) {
          MediaPlayer.startRotationAnimation()
        }
      }, 20)
    }
  }

  public async resume() {
    console.info(MediaPlayer.TAG + "resume");
    if (!MediaPlayer.avPlayer) {
      return;
    }

    try {
      switch (MediaPlayer.playState) {
        case PlayState.paused:
          // 如果在暂停状态下有保存的跳转位置，先执行seek
          if (MediaPlayer.seekPosition > 0) {
            console.info(MediaPlayer.TAG + "从暂停状态恢复，先跳转到:", MediaPlayer.seekPosition);
            await MediaPlayer.avPlayer.seek(MediaPlayer.seekPosition);
            MediaPlayer.seekPosition = 0; // 重置跳转位置
          }
          await MediaPlayer.avPlayer.play();
          break;
        case PlayState.prepared:
        case PlayState.completed:
          await MediaPlayer.avPlayer.play();
          break;
        case PlayState.idle:
          if (MediaPlayer.currentUrl) {
            await MediaPlayer.avPlayer.reset();
            MediaPlayer.avPlayer.url = MediaPlayer.currentUrl;
          }
          break;
        default:
          console.info(MediaPlayer.TAG + "Cannot resume in current state:", MediaPlayer.playState);
          break;
      }
    } catch (error) {
      console.error(MediaPlayer.TAG + "Failed to resume:", error);
    }
  }

  static seekPosition: number = 0;

  static async seek(timeMs: number) {
    console.info(MediaPlayer.TAG + "seek to:", timeMs);
    if (!MediaPlayer.avPlayer) {
      return;
    }

    try {
      // 检查时间是否有效
      if (timeMs < 0 || timeMs > (MediaPlayer.avPlayer.duration || 0)) {
        console.error(MediaPlayer.TAG + "Invalid seek time:", timeMs, "duration:", MediaPlayer.avPlayer.duration);
        return;
      }

      // 保存要跳转的位置
      MediaPlayer.seekPosition = timeMs;

      // 记录当前是否在播放
      const wasPlaying = MediaPlayer.playState === PlayState.playing;

      // 如果播放器不在正确状态，需要先准备
      if (MediaPlayer.playState === PlayState.idle || MediaPlayer.playState === PlayState.initialized) {
        if (!MediaPlayer.currentUrl) {
          console.error(MediaPlayer.TAG + "No URL set");
          return;
        }
        await MediaPlayer.avPlayer.reset();
        MediaPlayer.avPlayer.url = MediaPlayer.currentUrl;
        await MediaPlayer.avPlayer.prepare();
      }

      // 无论什么状态都执行seek
      await MediaPlayer.avPlayer.seek(timeMs, media.SeekMode.SEEK_NEXT_SYNC);

      // 等待一小段时间确保seek完成
      await new Promise<void>((resolve) => setTimeout(resolve, 50));

      // 如果之前在播放，确保继续播放
      if (wasPlaying) {
        await MediaPlayer.avPlayer.play();
      }

      // 通知时间更新，以更新UI显示
      if (MediaPlayer.listener) {
        // MediaPlayer.listener.onPlayPosition(timeMs, MediaPlayer.avPlayer.duration || 0);
        MediaPlayer.listener.get('onPlayPosition')?.({ timeMs, totalDuration: MediaPlayer.avPlayer?.duration || 0 })
      }
    } catch (error) {
      console.error(MediaPlayer.TAG + "Failed to seek:", error);
      // 如果seek失败，尝试重新初始化播放器
      try {
        if (MediaPlayer.currentUrl) {
          await MediaPlayer.avPlayer.reset();
          MediaPlayer.avPlayer.url = MediaPlayer.currentUrl;
          await MediaPlayer.avPlayer.prepare();
          await MediaPlayer.avPlayer.seek(timeMs);
          if (MediaPlayer.playState === PlayState.playing) {
            await MediaPlayer.avPlayer.play();
          } else if (MediaPlayer.playState === PlayState.paused) {
            await MediaPlayer.avPlayer.play();
            await MediaPlayer.avPlayer.pause();
          }
        }
      } catch (retryError) {
        console.error(MediaPlayer.TAG + "Failed to retry seek:", retryError);
      }
    }
  }

  static async stop() {
    console.info(MediaPlayer.TAG + "stop");
    if (MediaPlayer.avPlayer) {
      try {
        await MediaPlayer.avPlayer.stop();
      } catch (error) {
        console.error(MediaPlayer.TAG + "Failed to stop:", error);
      }
    }
  }

  static async release() {
    console.info(MediaPlayer.TAG + "release");
    if (MediaPlayer.avPlayer) {
      try {
        await MediaPlayer.avPlayer.release();
        MediaPlayer.avPlayer = undefined;
        MediaPlayer.currentUrl = '';
      } catch (error) {
        console.error(MediaPlayer.TAG + "Failed to release:", error);
      }
    }
  }

  public getCurrentTime(): number {
    try {
      return MediaPlayer.avPlayer?.currentTime || 0;
    } catch (error) {
      console.error(MediaPlayer.TAG + "Failed to get current time:", error);
      return 0;
    }
  }

  public getDuration(): number {
    try {
      return MediaPlayer.avPlayer?.duration || 0;
    } catch (error) {
      console.error(MediaPlayer.TAG + "Failed to get duration:", error);
      return 0;
    }
  }

  public getPlayState(): PlayState {
    return MediaPlayer.playState;
  }
}

export default MediaPlayer