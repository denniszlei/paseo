FROM ghcr.io/getpaseo/paseo:latest

USER root

# 1. 基础系统工具（务必包含 tar、gzip、ca-certificates，用于下载解压二进制）
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    tar \
    gzip \
    ca-certificates \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# 2. 安装 Node.js 生态 Agent（包括修复后的 opencode-ai 与 DeepSeek harness）
RUN npm install -g \
    @anthropic-ai/claude-code \
    @openai/codex \
    opencode-ai \
    paseo-deepseek-harness 2>/dev/null || true

# 安装 Pi Agent
RUN npm install -g --ignore-scripts @earendil-works/pi-coding-agent

# 3. 安装 Meta Muse Code CLI（通过环境变量指定直接安装至 /usr/local/bin）
# RUN export MUSE_INSTALL_DIR=/usr/local/bin && \
#     curl -fsSL https://dev.meta.ai/install.sh | bash

# 4. 安装 Google Antigravity CLI (agy)（显式传入 --dir /usr/local/bin 目标目录）
RUN curl -fsSL https://antigravity.google/cli/install.sh -o /tmp/install-agy.sh && \
    bash /tmp/install-agy.sh --dir /usr/local/bin && \
    rm -f /tmp/install-agy.sh

# 5. 确保全局可执行权限
RUN chmod 755 /usr/local/bin/agy /usr/local/bin/muse 2>/dev/null || true

# 6. 配置全局环境变量
ENV PATH="/usr/local/bin:$PATH"

# 切回基础镜像的非 root 用户 paseo
USER paseo
WORKDIR /workspace
