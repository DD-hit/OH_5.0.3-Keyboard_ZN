/**
 * 输入法引导页 - 打开应用时显示的页面，指导用户启用输入法
 */
@Entry
@Component
struct Index {
  build() {
    Column({ space: 24 }) {
      // 标题区
      Column({ space: 12 }) {
        Text('⌨️')
          .fontSize(56)

        Text('中文输入法')
          .fontSize(26)
          .fontWeight(FontWeight.Bold)

        Text('支持拼音输入与英文键盘')
          .fontSize(15)
          .fontColor('#888888')
      }
      .margin({ top: 60 })

      // 启用步骤
      Column({ space: 16 }) {
        this.StepCard('1', '打开系统设置', '桌面找到「设置」图标并打开')
        this.StepCard('2', '进入输入法设置', '系统和更新 → 语言和输入法 → 输入法')
        this.StepCard('3', '启用来此输入法', '在列表中找到「中文输入法」，打开开关')
        this.StepCard('4', '设为默认', '点击「默认输入法」，选择「中文输入法」')
      }
      .padding(20)
      .alignItems(HorizontalAlign.Start)

      Blank()

      // 底部说明
      Text('设置完成后，在任意输入框打字即可体验')
        .fontSize(13)
        .fontColor('#AAAAAA')
        .margin({ bottom: 32 })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F5F5F5')
  }

  @Builder
  StepCard(step: string, title: string, desc: string) {
    Row({ space: 14 }) {
      Text(step)
        .fontSize(14)
        .fontColor(Color.White)
        .fontWeight(FontWeight.Bold)
        .width(28)
        .height(28)
        .borderRadius(14)
        .backgroundColor('#007AFF')
        .textAlign(TextAlign.Center)

      Column({ space: 3 }) {
        Text(title)
          .fontSize(16)
          .fontWeight(FontWeight.Medium)
        Text(desc)
          .fontSize(13)
          .fontColor('#888888')
      }
      .alignItems(HorizontalAlign.Start)
    }
    .width('100%')
    .padding(14)
    .borderRadius(12)
    .backgroundColor(Color.White)
  }
}
