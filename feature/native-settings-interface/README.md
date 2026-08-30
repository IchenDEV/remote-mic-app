# 原生设置界面

## 用户问题

旧设置窗口同时使用自绘侧栏、手工容器和多套页面布局。页面之间的标题栏、边距、对齐、滚动背景和交互方式不一致，最小窗口下还会出现内容拥挤、说明与控件分离或状态重复。

## 最终行为

- 设置窗口默认 `920 × 700`、最小 `800 × 650`，使用系统统一标题栏；关闭后重新打开会恢复窗口位置。
- 侧栏固定为 232pt，不显示额外侧栏开关。搜索面向具体设置项，结果显示所属页面，并支持键盘选择和跳转。
- 标题栏提供返回、前进和历史；标准菜单与 `⌘F`、`⌘[`、`⌘]`、`⌘M`、`⌘H`、`⌥⌘H` 按当前系统能力启用。
- 各页面统一使用 grouped `Form`、`Section`、`LabeledContent`、`Toggle`、`Picker` 和标准按钮。普通设置使用左标签/右控件，业务内容沿分区左边线，整行筛选占满可用宽度。
- 按键页的设备卡铺满分区，关系图完整容纳 64pt 模块并保留至少 16pt 净间距；统计页使用原生分段 `Picker`；版本历史成为“关于”的窗口内子页面。
- iPhone、Apple Watch 和网页版等待状态使用系统进度指示；音频增益说明、测试音反馈和 TestFlight 辅助操作分别回到所属设置行。
- 分享入口只保留在“关于 → 更新与支持”。更新状态、版本号和唯一更新动作使用同一行层级，不再重复相同命令或说明。
- 遥控器关系图、统计图表、二维码和回眸历史等必要业务可视化继续保留；侧栏、状态胶囊、标题栏背景和普通设置容器不再自绘。

## 范围与兼容边界

本次只重构 Mac 设置窗口的呈现、导航和页面交互，不改变蓝牙、HID、语音键生命周期、音频协议、按键映射格式、移动端协议或跨 App 数据访问边界。中文界面文字保持不低于 12pt。

设置界面以 macOS 14 及以上为主；Intel 发行仍以 macOS 13 为最低目标。本轮文档整理没有重新执行 Intel 构建、真实硬件、系统权限、音频回环、移动端或 VoiceOver 验收。

## 主要实现

- [`SettingsView.swift`](../../Sources/RemoteMic/SettingsView.swift)：原生侧栏、设置项搜索、页面结构、状态层级和统一可选择卡片。
- [`SettingsNavigationCoordinator.swift`](../../Sources/RemoteMic/SettingsNavigationCoordinator.swift)：菜单与窗口内导航命令路由。
- [`RemoteMicApp.swift`](../../Sources/RemoteMic/RemoteMicApp.swift)：统一标题栏、窗口尺寸和位置恢复。
- [`RemoteMappingCanvas.swift`](../../Sources/RemoteMic/RemoteMappingCanvas.swift)：按键关系图的最终画布与间距。
- [`SettingsPageRegressionTests.swift`](../../Tests/RemoteMicTests/SettingsPageRegressionTests.swift)：设置结构、搜索、导航和页面回归门禁。

## 验证状态

候选改动曾完成 32 项设置页定向测试、345 项 Swift 测试、Xcode 27 调试 App 构建、App 完整性与本地化检查，并检查中文浅色、中文深色和英文 `800 × 650` 生产视图及部分真实窗口交互。这些结果不替代 Intel macOS 13、macOS 14/15、辅助功能和真实设备链路验收。

完整人工步骤见 [`Testing/NativeSettingsInterface.md`](../../Testing/NativeSettingsInterface.md)，合并后的问题证据见 [`Bugs/2026-08-24-native-settings-interface-regressions.md`](../../Bugs/2026-08-24-native-settings-interface-regressions.md)。
