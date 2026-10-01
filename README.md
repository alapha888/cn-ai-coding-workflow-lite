# 中文 AI 编程 CLI 工作流包 · 免费 Lite 版

一套装进 Claude Code / Codex CLI 就能用的**中文工作流命令**——不是教程，是开箱即用的中文 AI 编程工作台。

英文 prompt 写不好、配不好，看英文文档吃力？这几个中文命令替你把"怎么跟 AI 结对编程"流程化：每个命令都是一套中文工作流，直接调用就行。

本仓库是**免费 Lite 版**，包含 3 个最通用的命令。完整版（10 个命令 + 3 套项目模板 + 速查表 + 真实演示项目）¥49，早鸟 ¥39（限前 100 份）。

> **购买入口**：完整版即将在爱发电上架，链接：`https://afdian.com/item/8c9c0932bd7711f19eb852540025c377`（占位，上架后替换）

## 包含哪 3 个命令

| 命令 | 干什么 |
|---|---|
| `/review` | 清单式代码评审：按正确性/安全/可读性/性能/测试五个维度给可执行意见，不纠结风格 |
| `/commit` | 规范提交信息：读 diff 自动判断类型、拆分不相关改动，生成 conventional commit 信息 |
| `/test` | 补测试：先给用例清单过目，再动手写，保证可运行 |

每个命令文件包含：适用场景、中文 prompt 正文、输入输出示例、反模式提醒。3 个命令全部在 Claude Code 与 Codex CLI 里真实调用测试过。

## 安装

```bash
# 1. 克隆
git clone https://github.com/alapha888/cn-ai-coding-workflow-lite.git
cd cn-ai-coding-workflow-lite

# 2. 一键安装（同时装到 Claude Code 与 Codex；只装一个可用 --claude-only / --codex-only）
bash scripts/install.sh

# Windows（PowerShell）
.\scripts\install.ps1

# 3. 验证
ls ~/.claude/commands/     # 应看到 review.md、commit.md、test.md
ls ~/.codex/skills/        # 应看到 3 个目录，每个含 SKILL.md
```

然后在你的 CLI 里直接用：`/review`、`/commit`、`/test`。

## ⚠️ 一句话风险提示

Claude Code 对国内地区账号有较严的风控，存在封号可能（公开社区反复出现的情况）。如用国内账号，建议优先用 **Codex CLI** 跑这几个命令（已在 Codex 上实测通过），或把命令当中文 SOP 复制到任何中文 AI 使用。

## 完整版有什么（v1.0）

Lite 版的 3 个命令之外，完整版还有：

- 另外 7 个命令：`/debug` 修 Bug 流程、`/refactor` 安全重构、`/doc` 写文档、`/plan` 任务拆解、`/pr` 写 PR 描述、`/onboard` 接手陌生项目、`/release` 发版检查
- 3 套项目配置模板 CLAUDE.md（web-fullstack / python-scripts / docs-site）
- 中英术语对照 + 5 条工作流组合速查表
- 真实演示项目 todo-cli：全程只用本包命令从 0 写到提交，附过程记录（含修掉的 4 个真实问题和命令不好用的地方，如实记录）

购买后走爱发电私信交付（付款后 12 小时内），7 天无理由退款。

## 反馈

问题、建议走 [GitHub Issues](https://github.com/alapha888/cn-ai-coding-workflow-lite/issues)。不公开邮箱。

---

*MIT License · 3 commands / 双 CLI 实测通过 · 完整版 ¥49（早鸟 ¥39）*
