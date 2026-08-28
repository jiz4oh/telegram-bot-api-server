# telegram-bot-api-server

自动追踪 [tdlib/telegram-bot-api](https://github.com/tdlib/telegram-bot-api) 上游 `HEAD`，并在发现新提交时构建镜像推送到 `ghcr.io`。

## 功能

- 每 30 分钟检查一次上游 `HEAD`
- 仅在新 `sha` 出现时触发构建
- 推送多架构镜像：`linux/amd64`、`linux/arm64`
- 推送标签：
  - `latest`
  - `sha-<12位提交哈希>`
  - `<UTC日期，YYYYMMDD>`
- 内置 gost 和 iptables 透明 SOCKS5 重定向层，由 `TGSOCKS_PROXY_HOST`、`TGSOCKS_PROXY_PORT` 控制

## 镜像地址

- `ghcr.io/<owner>/telegram-bot-api-server:latest`
- `ghcr.io/<owner>/telegram-bot-api-server:sha-xxxxxxxxxxxx`

## 权限要求

工作流已声明：

- `contents: read`
- `packages: write`

确保仓库 Actions 具备包写入权限。

## 手动触发

进入 GitHub Actions，运行 `Build and Push tdlib telegram-bot-api`。
