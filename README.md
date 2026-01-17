# Supervisor Container

Ubuntu 24.04 をベースに、Supervisor で sshd, dbus, cloudflared を管理する Docker イメージです。

## 実行方法

### 基本的な実行

```bash
docker run -d \
  --name supervisor-container \
  -e TUNNEL_TOKEN="<your-tunnel-token>" \
  -p 2222:22 \
  -p 9001:9001 \
  <image-name>
```
