# telegram-bot-api-server

通过 `source` submodule 固定 [tdlib/telegram-bot-api](https://github.com/tdlib/telegram-bot-api) 上游版本，并在每日同步发现新提交后构建镜像推送到 `ghcr.io`。

## 功能

- 每天同步一次上游 submodule
- 上游 submodule 更新提交后自动触发构建
- `main` 分支 push 和手动运行均可触发构建
- 推送 `linux/amd64` 镜像
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
