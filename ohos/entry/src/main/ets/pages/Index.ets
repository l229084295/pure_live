import common from '@ohos.app.ability.common';
import { FlutterPage } from '@ohos/flutter_ohos'

let storage = LocalStorage.getShared()
const EVENT_BACK_PRESS = 'EVENT_BACK_PRESS'

@Entry(storage)
@Component
struct Index {
  private context = getContext(this) as common.UIAbilityContext
  @LocalStorageLink('viewId') viewId: string = "";

  build() {
    Column() {
      FlutterPage({
        viewId: this.viewId,
        showSplashScreen: true,
        splashScreenView: this.splashScreenViewShow
      })
    }
  }

  onBackPress(): boolean {
    this.context.eventHub.emit(EVENT_BACK_PRESS)
    return true
  }

  @Builder
  splashScreenViewShow() {
    Column() {
      // 使用与startWindowBackground相同的背景色
      Image($r('app.media.icon')).width(100).height(100).align(Alignment.Center)
      Text('初始化...')
        .fontSize(20)
        .fontColor(Color.Black)
        .align(Alignment.Center)
    }
    .justifyContent(FlexAlign.Center)
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White) // 需与module.json5中的背景色一致
  }
}
