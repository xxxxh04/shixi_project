import { showToast } from '../../utils/Toast'
import { router } from '@kit.ArkUI'
import { RouterConstant } from '../../contants/RouterConstant'
import { CommonConstant } from '../../contants/CommonConstant'
import { geoLocationManager } from '@kit.LocationKit'
import { abilityAccessCtrl, common, Permissions } from '@kit.AbilityKit'
import { IBestCalendar } from "@ibestservices/ibest-ui"
import { LoadingComponent } from '../../components/LoadingComponent'
import learnClockApi from '../../api/LearnClockApi'
import { Logger } from '../../utils/Logger'

@Entry
@Component
export struct Clock {
  @State location: string = ''
  @State isClock: boolean = false
  @State clockDate: Array<string> = []
  @State isShow: boolean = false

  async aboutToAppear() {
    await this.getClockData()
    await this.requestPermission()
  }

  async requestPermission() {
    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext
    const permissions: Array<Permissions> = ['ohos.permission.APPROXIMATELY_LOCATION']
    const atManager = abilityAccessCtrl.createAtManager()
    try {
      const data = await atManager.requestPermissionsFromUser(context, permissions)
      if (data.authResults.some(res => res !== 0)) {
        showToast('用户必须授权才能访问定位功能')
        return
      }
      await this.getLocation()
    } catch (error) {
      showToast('用户必须授权才能访问定位功能')
    }
  }

  async getLocation() {
    const request: geoLocationManager.SingleLocationRequest = {
      locatingPriority: geoLocationManager.LocatingPriority.PRIORITY_LOCATING_SPEED,
      locatingTimeoutMs: 10000
    }
    try {
      const result = await geoLocationManager.getCurrentLocation(request)
      Logger.info('current location: ' + JSON.stringify(result))
      if (geoLocationManager.isGeocoderAvailable()) {
        const reverseGeocodeRequest: geoLocationManager.ReverseGeoCodeRequest = {
          latitude: result.latitude,
          longitude: result.longitude,
          maxItems: 1
        }
        geoLocationManager.getAddressesFromLocation(reverseGeocodeRequest, (err, data) => {
          if (!err && data?.length) {
            this.location = (data[0].administrativeArea || '') + (data[0].subAdministrativeArea || '')
          }
        })
      } else {
        showToast('地理编码服务不可用')
      }
    } catch (err) {
      Logger.error("errCode:" + JSON.stringify(err))
      showToast("获取位置失败")
    }
  }

  async getClockData() {
    this.isClock = await learnClockApi.isClock()
    this.clockDate = await learnClockApi.listClockTime()
    this.isShow = true
  }

  async clock() {
    if (!this.location) {
      showToast('打卡失败')
      return
    }
    if (this.isClock) {
      showToast('今日已打过卡')
      return
    }
    await learnClockApi.learnClock({ location: this.location, content: '学习打卡' })
    showToast('打卡成功，已连续打卡200天')
    router.replaceUrl({ url: RouterConstant.VIEWS_LEARN_TOOL })
  }

  build() {
    Navigation() {
      if (this.isShow) {
        Column({ space: 20 }) {
          // 打卡按钮
          Button(this.isClock ? '已打卡' : '未打卡')
            .width($r('app.float.common_width_huge'))
            .height($r('app.float.common_height_huge'))
            .borderRadius(100)
            .backgroundColor('#03A9F4')
            .onClick(() => this.clock())

          // 日历区域（放在容器里自动占宽）
          Column() {
            IBestCalendar({
              clock: true,
              defaultSelectedDate: this.clockDate,
              clockSuccessText: '✔',
              unClockText: '✖'
            })
          }
          .width('100%')
        }
        .padding($r('app.float.common_padding'))
      } else {
        LoadingComponent()
      }
    }
    .height(CommonConstant.HEIGHT_FULL)
    .width(CommonConstant.WIDTH_FULL)
    .title($r('app.string.learn_clock_title'))
    .titleMode(NavigationTitleMode.Mini)
    .mode(NavigationMode.Stack)
    .backgroundColor($r('app.color.background_color_gray'))
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
  }
}
