# 开发记录

## 涉及文件

- `Sources/RemoteMic/AppSharing.swift`：使用 `URLComponents` 构造链接，使用 CoreImage 生成二维码，并封装可测试的剪贴板写入。
- `Sources/RemoteMic/SettingsView.swift`：关于页内分享面板、设置项搜索入口和问题反馈入口。
- `Sources/RemoteMic/RemoteMicApp.swift`：移除状态栏旧反馈入口。
- `Resources/*.lproj/Localizable.strings`：中英文分享、复制结果和反馈说明。
- `Tests/RemoteMicTests/*`：URL、二维码输入、剪贴板、反馈迁移、侧边栏与页面结构回归。

## 关键决策

分享只保留在“关于 → 更新与支持”，由 `isAboutShareExpanded` 控制页面内展开。统计页和侧边栏不再重复同一命令；搜索结果可以定位到关于页分享分区。页面内平铺避免 Sheet 或 Popover。

URL 构造会保留已有 query 和 fragment，移除大小写不敏感的旧 `from` 后追加唯一 `from=mac_share`。当前中文 URL 为 `https://sayall.app/?from=mac_share`，英文 URL 为 `https://sayall.app/en/?from=mac_share`。

## 已知限制

- 二维码能否被具体手机相机识别仍需真实扫码验收。
- 系统剪贴板可能被安全软件或系统策略拒绝；页面会显示失败，不影响其他功能。
- App 不跟踪链接打开或分享转化；`from` 参数仅供官网按自身策略识别来源。
