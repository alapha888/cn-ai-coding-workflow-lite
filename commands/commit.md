---
name: commit
description: 按 Conventional Commits 生成规范提交信息：类型前缀+祈使句主题+可选正文
cli: [claude-code, codex]
---

# /commit 规范提交信息

## 什么时候用

- `git add` 之后，懒得想提交信息怎么写
- 团队要求 conventional commits，自己总写成 `update`、`fix bug`
- 一次提交混了多种改动，想先拆分再写信息

## 调用方式

```
/commit
```
（先 `git add` / `git diff --cached` 看暂存区；不替用户执行 add，只读 diff 生成信息）

## 工作流

1. **读 diff**：看 `git diff --cached`（无暂存时看 `git diff`），理解这次改了什么。
2. **判类型**：`feat`（新功能）/ `fix`（修 bug）/ `docs` / `refactor` / `test` / `chore` / `perf`。一次提交只取一个主类型；如果 diff 里混了两种不相关的改动，先提醒"建议拆成两次提交"，给出拆分建议。相关与否看"是否为同一目的服务"：选型文档是本次 commands 的依据 → 相关，可合；README 顺手改动混进功能提交 → 不相关，建议拆。
3. **写主题**：祈使句、≤50 字符、句首小写、无句号，如 `fix: 订单缺失 level 时不再抛 KeyError`。中文主题允许，但中英混排时保持术语一致。
4. **写正文**（可选）：只在需要时加——解释"为什么"这样改（不是"改了什么"，diff 里已有）。bug 修复注明根因一句话。
5. **输出待确认**：把生成的完整信息展示给用户，问"直接用这条提交吗？"——**不自动执行 `git commit`**，提交动作永远由用户确认。

## 输出格式

```
fix: 订单缺失 level 时给默认值 normal

根因：batch_settle 直接取 o["level"]，上游缺失字段时崩溃。
改用 o.get("level", "normal") 兼容历史数据。
```

## 输入输出示例

输入：暂存区是 orders.py 的两处修改（文件关闭改 with、level 取值加默认值）

输出：`fix: 修复文件句柄泄漏与缺失 level 时的 KeyError` + 正文说明两处根因；若 diff 还混入 README 改动 → 提醒拆分。

## 反模式（什么时候不要用）

- 暂存区是空的——先 add 再来
- 想让它自动提交——这个命令永远只生成信息、不执行提交
- 提交信息想写小作文——主题+三行正文是上限，写多了没人看
- 一次提交包含重构+功能+修 bug 三件套——先拆，拆不动再接受"这次信息会比较长"
