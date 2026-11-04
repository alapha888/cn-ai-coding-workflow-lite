# 中文 AI 编程 CLI 工作流包 · 免费 Lite 版

一套装进 Claude Code / Codex CLI 就能用的**中文工作流命令**——不是教程，是开箱即用的中文 AI 编程工作台。

英文 prompt 写不好、配不好，看英文文档吃力？这几个中文命令替你把"怎么跟 AI 结对编程"流程化：每个命令都是一套中文工作流，直接调用就行。

本仓库是**免费 Lite 版**，包含 3 个最通用的命令。完整版（10 个命令 + 3 套项目模板 + 速查表 + 真实演示项目）¥9.90 起。

> **购买入口**：完整版已在爱发电上架：https://afdian.com/item/8c9c0932bd7711f19eb852540025c377（¥9.90 起，付款后 12 小时内经爱发电私信交付，7 天无理由退款）

> **可打印速查表（英文版）**：相关全文已在 GitHub 免费公开；Gumroad 上另有浓缩可打印版速查表包（代码评审＋Git 提交，PDF+PNG），$19：https://alapha888.gumroad.com/l/zjayxe

## 包含哪 3 个命令

| 命令 | 干什么 |
|---|---|
| `/review` | 清单式代码评审：按正确性/安全/可读性/性能/测试五个维度给可执行意见，不纠结风格 |
| `/commit` | 规范提交信息：读 diff 自动判断类型、拆分不相关改动，生成 conventional commit 信息 |
| `/test` | 补测试：先给用例清单过目，再动手写，保证可运行 |

每个命令文件包含：适用场景、中文 prompt 正文、输入输出示例、反模式提醒。3 个命令全部在 Claude Code 与 Codex CLI 里真实调用测试过。

## 看它实际怎么干活

以 `/review` 为例（示例原文取自命令文件 `commands/review.md` 的实测记录）：

输入：`/review /tmp/cmdtest/orders.py，这是订单折扣计算模块`

输出要点：[必须改] 文件未关闭（orders.py:8）、`o["level"]` 缺失 key 时崩溃（orders.py:26）；[建议改] 浮点金额未舍入到分、`summarize` 统计与打印混杂；结论：需修改后合并。

评审按「必须改 / 建议改 / 可忽略」分级，每条给到文件:行号和改法，不纠结风格类问题。

### 完整版命令先睹为快：`/plan` 的一次真实产出（节选）

`/plan` 是完整版独有的命令（Lite 版不含）：给它一个需求，它不急着写代码，先拆出带验收标准和依赖关系的任务清单。下面是完整版演示项目 todo-cli 里一次真实调用的产出节选（原文取自演示项目的 `/plan` 执行记录）：

> 先列 [待确认] 项（数据文件默认放哪、list 是否默认只显示未完成），确认后才拆任务：
> - T1 写 todo.py 实现（add/list/done/remove + JSON 持久化）— 验收：四个子命令手工跑通
> - T2 `/test` 补单测 — 验收：pytest 全绿、用例 ≥8；依赖：T1
> - T3 `/review` 评审并修必须改 — 验收：[必须改] 清零；依赖：T2
> - T4 写过程记录 — 验收：如实记录每步输入输出与修掉的问题；依赖：T3
> - T5 `/commit` 生成信息并真实提交 — 验收：git log 有一条规范提交；依赖：T4
>
> 每个任务都带验收标准、依赖和涉及文件，另附风险与未知项，拆完按 T1→T5 顺序执行。

完整版另外 6 个独有命令（`/debug`、`/refactor`、`/doc`、`/pr`、`/onboard`、`/release`）也是同一路数：先给清单或计划过目，再动手，每一步留可核对的产出。

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

## 正在验证的新想法（尚未开发）

- **MDClip Pro**：网页转 Markdown 工具，意向价 ¥15/月（尚未开发、不收款）。候补登记：https://alapha888.github.io/mdclip-waitlist/ ——2026-10-31 前登记满 30 人才立项开发。
- **SyncMatrix**：面向矩阵/团队运营者的多账号发布管理，意向价 ¥39/月（尚未开发、不收款）。候补登记：https://alapha888.github.io/syncmatrix-waitlist/ ——2026-10-31 前登记满 20 人才立项开发。

## 配套短文合集（免费读）

以下短文均整理自本仓命令实测文本或完整版 README FAQ，非新实测；按需单篇读，不必全读：

- 10 个命令的 5 条硬规则合集索引：https://gist.github.com/alapha888/2c08ee55c283b2f0f76ce0dc0783aaba
- Lite 版 3 分钟上手：[/review 篇](https://gist.github.com/alapha888/202b319cfef310c6a0fb001fc4a93247)、[/commit 篇](https://gist.github.com/alapha888/28901c6a146259f9a0b592296ac9d3a0)、[/test 篇](https://gist.github.com/alapha888/500fa30d3100a56659bfa40d2f965128)
- Lite 3 命令串联：改代码 → /test → /review → /commit，一次走完：https://gist.github.com/alapha888/6b511341f86b5d90b825069037791f3c
- Lite 免费版与完整版对照：https://gist.github.com/alapha888/87ec2f22399fd1995de218c2ed9e8964
- 买前先看：完整版 10 个常见问题：https://gist.github.com/alapha888/2d44005bad9e2f15e022cf6098c6a9e8
- Lite 够用，还是值得升级完整版？一张对照表帮你决定：https://gist.github.com/alapha888/306cd6c7421919b3d8b5d3126697d0a3

dev.to 文章（同一内容，平台版，非新实测）：

- 让 AI 编程助手少返工：10 条命令规则合集（免费读）：https://dev.to/alapha888/rang-ai-bian-cheng-zhu-shou-shao-fan-gong-10-tiao-ming-ling-gui-ze-he-ji-mian-fei-du--7ae
- 改一段代码，用 /test /review /commit 走一遍：一个可复现的收尾链路：https://dev.to/alapha888/gai-duan-dai-ma-yong-test-review-commit-zou-bian-ge-ke-fu-xian-de-shou-wei-lian-lu-47h0
- 买前先看：中文 AI 编程 CLI 工作流包 10 个常见问题：https://dev.to/alapha888/mai-qian-xian-kan-zhong-wen-ai-bian-cheng-cli-gong-zuo-liu-bao-10-ge-chang-jian-wen-ti-1ioo
- Lite 够用，还是值得升级完整版？先看这张对照表：https://dev.to/alapha888/lite-gou-yong-huan-shi-zhi-de-sheng-ji-wan-zheng-ban-xian-kan-zhe-zhang-dui-zhao-biao-7kk
- 只装 3 条命令：Lite 版安装取舍与验证清单：https://dev.to/alapha888/zhi-zhuang-3-tiao-ming-ling-lite-ban-an-zhuang-qu-she-yu-yan-zheng-qing-dan-34k4
- 让 reviewer 3 分钟看懂你的 PR：/pr 的 5 条硬规则（完整版命令，平台版）：https://dev.to/alapha888/rang-reviewer-3-fen-zhong-kan-dong-ni-de-prpr-de-5-tiao-ying-gui-ze-iol
- 报错先别猜：/debug 的 5 步排错法（完整版命令，平台版）：https://dev.to/alapha888/bao-cuo-xian-bie-cai-debug-de-5-bu-pai-cuo-fa-46b4
- 函数超过 50 行自己都不想读了：/refactor 的 5 步安全重构（完整版命令，平台版）：https://dev.to/alapha888/han-shu-chao-guo-50-xing-zi-ji-du-bu-xiang-du-liao-refactor-de-5-bu-an-quan-zhong-gou-294a
- 文档写完没人能跑起来，等于没写：/doc 的注释三原则与 README 五件套（完整版命令，平台版）：https://dev.to/alapha888/wen-dang-xie-wan-mei-ren-neng-pao-qi-lai-deng-yu-mei-xie-doc-de-zhu-shi-san-yuan-ze-yu-readme-wu-jian-tao-i5m
- 需求一来就开写，写到一半才发现想错了：/plan 的 5 步拆解法（完整版命令，平台版）：https://dev.to/alapha888/xu-qiu-lai-jiu-kai-xie-xie-dao-ban-cai-fa-xian-xiang-cuo-liao-plan-de-5-bu-chai-jie-fa-4knh
- 接手一个陌生项目，先别从第一行读起：/onboard 的 5 条硬规则（完整版命令，平台版）：https://dev.to/alapha888/jie-shou-ge-mo-sheng-xiang-mu-xian-bie-cong-di-xing-du-qi-onboard-de-5-tiao-ying-gui-ze-501h
- 发版前先别急着打 tag：/release 的 5 条硬规则（完整版命令，平台版）：https://dev.to/alapha888/fa-ban-qian-xian-bie-ji-zhao-da-tagrelease-de-5-tiao-ying-gui-ze-43ih
- CLAUDE.md 别从空白写起：三套模板按项目类型选（完整版模板，平台版）：https://dev.to/alapha888/claudemd-bie-cong-kong-bai-xie-qi-san-tao-mo-ban-an-xiang-mu-lei-xing-xuan-586o
- 10 条命令记不住？一张速查表 5 条组合链路（完整版速查表，平台版；标题中全角加号经平台规范化为空格）：https://dev.to/alapha888/10-tiao-ming-ling-ji-bu-zhu-zhang-su-cha-biao-5-tiao-zu-he-lian-lu-4k0n
- 一个 todo-cli 从 0 到提交：/plan→/test→/review→/commit 真实走了一遍，修掉 4 个问题（完整版演示，平台版）：https://dev.to/alapha888/ge-todo-cli-cong-0-dao-ti-jiao-plan-test-review-commit-zhen-shi-zou-liao-bian-xiu-diao-4-ge-wen-ti-190e
- 同一套命令，Claude 和 Codex 都能用吗？双兼容实测：10/10 通过，只改 2 处（完整版双兼容，平台版）：https://dev.to/alapha888/tong-tao-ming-ling-claude-he-codex-du-neng-yong-ma-shuang-jian-rong-shi-ce-1010-tong-guo-zhi-gai-2-chu-10kp
- 装完命令调不出来，先别怪命令：安装脚本三系统实测里修掉的 3 个坑（完整版安装脚本，平台版）：https://dev.to/alapha888/zhuang-wan-ming-ling-diao-bu-chu-lai-xian-bie-guai-ming-ling-an-zhuang-jiao-ben-san-xi-tong-shi-ce-li-xiu-diao-de-3-ge-keng-46c1
- 10 条命令写完先别急着卖：初稿实测 3 条零修改、7 条各修 1 处靠猜点（完整版 D1 实测，平台版）：https://dev.to/alapha888/10-tiao-ming-ling-xie-wan-xian-bie-ji-zhao-mai-chu-gao-shi-ce-3-tiao-ling-xiu-gai-7-tiao-ge-xiu-1-chu-kao-cai-dian-2djm
- 补测试先别急着写代码：/test 的 5 条硬规则（Lite 版命令，平台版）：https://dev.to/alapha888/bu-ce-shi-xian-bie-ji-zhao-xie-dai-ma-test-de-5-tiao-ying-gui-ze-2g25
- 评审意见别只写感想：/review 的 5 条硬规则（Lite 版命令，平台版）：https://dev.to/alapha888/ping-shen-yi-jian-bie-zhi-xie-gan-xiang-review-de-5-tiao-ying-gui-ze-2a9p
- 提交信息别再写 update 了：/commit 的 5 条硬规则（Lite 版命令，平台版）：https://dev.to/alapha888/ti-jiao-xin-xi-bie-zai-xie-update-liao-commit-de-5-tiao-ying-gui-ze-21k0
- 无人值守跑工作流，确认门该停还是该走？v1.0 的分法：两处自动继续、两处永远等你（完整版非交互，平台版）：https://dev.to/alapha888/wu-ren-zhi-shou-pao-gong-zuo-liu-que-ren-men-gai-ting-huan-shi-gai-zou-v10-de-fen-fa-liang-chu-zi-dong-ji-xu-liang-chu-yong-yuan-deng-ni-4a7j
- description 里一个冒号，3 条命令直接搜不到：一次 YAML 解析失败的实测（frontmatter 解析，平台版）：https://dev.to/alapha888/description-li-ge-mou-hao-3-tiao-ming-ling-zhi-jie-sou-bu-dao-ci-yaml-jie-xi-shi-bai-de-shi-ce-4gji
- CI 连挂两次，凶手是变量后面的中文：花括号规则（完整版安装脚本，平台版）：https://dev.to/alapha888/ci-lian-gua-liang-ci-xiong-shou-shi-bian-liang-hou-mian-de-zhong-wen-hua-gua-hao-gui-ze-2f5n

## 反馈

问题、建议走 [GitHub Issues](https://github.com/alapha888/cn-ai-coding-workflow-lite/issues)。不公开邮箱。

## 作者其他作品

- **RunnerDriftAudit**：免费 CLI，扫描 GitHub Actions 工作流的 runner 标签与工具漂移（ubuntu-latest 26.04 迁移前自查）；Pro 版（$29 一次性）一次扫描整个本地工作区。https://github.com/alapha888/runner-drift-audit
- **PubAudit**：免费 CLI，批量把 Microsoft Publisher（.pub）文件转 PDF 并逐个校验输出（OK / REVIEW / FAILED）。https://github.com/alapha888/pubaudit
- 免费工具、付费版本与预约中项目索引：https://gist.github.com/alapha888/fe51434e80dbc0ef5610aeab38b025f4

---

*MIT License · 3 commands / 双 CLI 实测通过 · 完整版 ¥9.90 起*
