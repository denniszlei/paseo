FROM ghcr.io/getpaseo/paseo:latest

USER root

# 1. 基础依赖环境（确保有 curl、git、python 等）
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    python3 \
    python3-pip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. 安装 Node.js 生态 Agent
# 关键修复：opencode-ai 必须在允许执行脚本（不带 --ignore-scripts）的情况下安装
RUN npm install -g \
    @anthropic-ai/claude-code \
    @openai/codex \
    opencode-ai \
    paseo-deepseek-harness 2>/dev/null || true

# 单独安装 Pi Agent（Pi 官方建议可带 --ignore-scripts 避免非必要构建）
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# 3. 安装 Meta Muse Code CLI
# RUN curl -fsSL https://dev.meta.ai/install.sh | sh && \
#     (cp /root/.local/bin/muse /usr/local/bin/muse 2>/dev/null || \
#      find /root -name muse -type f -perm /111 -exec cp {} /usr/local/bin/muse \; 2>/dev/null || true)

# 4. 安装 Google Antigravity CLI (agy)
# 脚本默认会装到 ~/.local/bin/agy，我们将其软链接/拷贝到 /usr/local/bin，使 paseo 用户可用
RUN curl -fsSL https://antigravity.google/cli/install.sh | bash && \
    (cp /root/.local/bin/agy /usr/local/bin/agy 2>/dev/null || \
     find /root -name agy -type f -perm /111 -exec cp {} /usr/local/bin/agy \; 2>/dev/null || true) && \
    chmod +x /usr/local/bin/agy 2>/dev/null || true

# 5. 确保 PATH 环境变量覆盖所有常用用户目录
ENV PATH="/home/paseo/.local/bin:/usr/local/bin:$PATH"

# 切回基础镜像的非 root 用户 paseo
USER paseo
WORKDIR /workspace
