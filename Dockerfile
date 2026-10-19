FROM ghcr.io/getpaseo/paseo:latest

USER root

# 1. 基础依赖环境（Git、Python、编译依赖等）
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    python3 \
    python3-pip \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# 2. 全局安装 Node.js 生态 Agent:
#    - Claude Code
#    - Codex CLI
#    - OpenCode
#    - Pi (pi-coding-agent)
RUN npm install -g --ignore-scripts \
    @anthropic-ai/claude-code \
    @openai/codex \
    opencode-ai \
    @earendil-works/pi-coding-agent

# 3. 安装 Meta Muse Code CLI
# RUN curl -fsSL https://dev.meta.ai/install.sh | sh && \
#     cp /root/.local/bin/muse /usr/local/bin/muse 2>/dev/null || true

# 4. 安装 DeepSeek Harness (dsh) / Paseo 插件支持
#    (Paseo 也支持通过 Pi 或 OpenCode 引擎直接配置 DeepSeek 模型)
# RUN npm install -g paseo-deepseek-harness 2>/dev/null || true

# 切回基础镜像的非 root 用户 paseo
USER paseo
