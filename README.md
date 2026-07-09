# Keyboard ZN

基于 OpenHarmony 5.0 的自定义拼音输入法（IME Extension），支持中文拼音输入、候选词联想、中英文切换。

## 项目结构

```
├── AppScope/                # 应用级配置（bundleName、版本号）
├── entry/
│   └── src/main/
│       ├── ets/
│       │   ├── entryability/          # EntryAbility
│       │   ├── inputmethodext/
│       │   │   ├── InputMethodService.ets     # IME Extension 入口
│       │   │   ├── model/
│       │   │   │   ├── KeyboardController.ets # 面板控制、输入逻辑
│       │   │   │   └── PinyinEngine.ets       # 拼音引擎
│       │   │   └── pages/
│       │   │       ├── KeyboardPage.ets       # 键盘 UI
│       │   │       └── KeyboardKeyData.ets    # 键盘布局数据
│       │   └── pages/
│       │       └── Index.ets                  # 应用主页
│       └── module.json5                       # 模块配置（权限、Extension）
└── build-profile.json5                        # 编译配置
```

## 功能

- 中文拼音全键盘输入
- 候选词联想（基于本地词库）
- 中/英文切换、大小写切换
- 数字/符号键盘

## 前提条件

- **SDK**: OpenHarmony 5.0+（API 12+）
- **设备**: 已开启开发者模式，`hdc` 已连接
- 签名证书 `material` 路径需与本地一致（见 `build-profile.json5`）

## 全新设备安装

### 1. 编译

在 DevEco Studio 中打开项目，执行 **Build → Build Hap(s)/APP(s)**，产物位于：

```
entry/build/default/outputs/default/entry-default-signed.hap
```

### 2. 推送 HAP 到设备

```bash
HDC=/path/to/hdc

$HDC file send entry/build/default/outputs/default/entry-default-signed.hap /data/local/tmp/keyboard_zn.hap
```

### 3. 禁用系统自带输入法

```bash
# 先查看当前已安装的输入法
$HDC shell bm dump -a | grep -i inputmethod

# 禁用旧输入法（必须做，否则切换不生效）
$HDC shell bm disable -n <旧输入法bundleName>
```

### 4. 安装并启用

```bash
# 安装
$HDC shell bm install -p /data/local/tmp/keyboard_zn.hap

# 设置默认输入法
$HDC shell param set persist.sys.default_ime com.example.keyboard_zn/InputMethodService
```

### 5. 验证

```bash
# 确认默认输入法
$HDC shell param get persist.sys.default_ime
# 应输出: com.example.keyboard_zn/InputMethodService
```

### 一键脚本（macOS，DevEco Studio 默认 SDK 路径）

```bash
#!/bin/bash
HDC=/Applications/DevEco-Studio.app/Contents/sdk/default/openharmony/toolchains/hdc

$HDC file send entry/build/default/outputs/default/entry-default-signed.hap /data/local/tmp/keyboard_zn.hap

# 禁用常见系统输入法
$HDC shell bm disable -n com.example.kikakeyboard 2>/dev/null

$HDC shell bm install -p /data/local/tmp/keyboard_zn.hap
$HDC shell param set persist.sys.default_ime com.example.keyboard_zn/InputMethodService

echo "Done! Tap any text field to try."
```

## 注意事项

- **模拟器无系统输入法切换 UI**，只能通过 `param set` 切换
- 必须在安装后**立刻禁用旧输入法**，否则 `param set` 不生效
- IME Extension 在 `bm install` 时可能被系统预拉起，但 JS 运行时未必就绪。
  代码中已在 `inputStart` 回调做了面板创建的重试逻辑，确保用户真正需要键盘时才初始化 UI
