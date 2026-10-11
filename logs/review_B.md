# 复查 B · ten-proofs Lean 证书可复现性（删产物→从零重建→比对）

- 日期：2026-10-11；执行：独立复查 agent（review_B，未读 review_A）
- 仓库：`/mnt/work/ten-proofs`，HEAD `94bc0fe`，`git status` 干净（无未提交改动）
- 工具链：lean v4.32.0（~/.elan），mathlib 依赖预构建于 `.lake/packages/mathlib`
- 本机：Ryzen 5 5600（6C/12T）/ 32G RAM

## 1. 删除前基线（sha256，全部 10 个 olean）

```
055fdb3b3746f91aedf8072af310e7ea65e629d8b0eea1a9db96f2117243db14  CompactnessAndDegeneracy.olean  (37,236,800 B)
8bdce6b12fec586b267399514d627b424f8ad7b8b8ac1737e4a8aff95a7aaea9  ConnesRigidity.olean            (61,174,904 B)
b196a6aa87901ac952f4062615a348377dab488777a34c322335a91378e9d307  EhrhartVolumeInequality.olean   (33,029,048 B)
798245972d554a24598fd2fa3471b9cc0cc29ffdb4346a1e6a98da6212e2b723  GapCVP.olean                   (119,725,488 B)
88c50eff843fc2a05256cdde0f88d7afca617dcbadccf22960f9dc1687e58af7  MetricCodes.olean              (142,083,376 B)
1bd5feb2ab75f9054de880dc01fdb71e415ddd6af0b5bf936f757a488d36279f  MulticolorTriangleRamsey.olean  ( 4,160,152 B)
f68f137ca48a3932a011102e8b55c1561553cd1a645aed185836cd84cc0db497  NonSoficGroup.olean             (39,643,088 B)
60025d23af19a1b0a0743bb23e28cb30f931b30c75b9db8548d8fec16ac1e5c5  Permanent.olean                 (29,898,184 B)
b0414523779909665b0fbcc28e523e20af066f1246aef742fcb89a302f644f5d  QuantumParallelRepetition.olean (65,607,528 B)
9bd5589267363f2296bb44c89bdf81cd57b9d70a1d86d3a977d59b7f6d412f81  SpherePacking.olean             (51,669,352 B)
```
（存档于 `/tmp/opencode/review_B_olean_before.txt`）

## 2. 删除

仅删 `SpherePacking.olean`、`MulticolorTriangleRamsey.olean`（`rm` 两文件，无其他写操作）。删后 `.lean` 目录余 8 个 olean，与预期一致。未改任何源文件、未触碰其他 agent 的产物。

## 3. 重建（`/usr/bin/time -v lake build <target>`）

| 目标 | rc | lake 模块耗时 | wall 总耗时 | user time | CPU 利用率 | 内存峰值 (Max RSS) |
|---|---|---|---|---|---|---|
| `SpherePacking`（55,616 行） | **0**，"Build completed successfully (8656 jobs)" | 146 s | **148.5 s** (2:28.46) | 821.7 s | 562% | **9.54 GB** |
| `MulticolorTriangleRamsey`（3,053 行） | **0**，"Build completed successfully (8656 jobs)" | 9.4 s | **11.9 s** (0:11.89) | 41.4 s | 371% | 6.50 GB |

- SpherePacking 内存峰值 9.54 GB，与任务卡预警"可达 8GB"同量级（略超）。
- 两者 8656 jobs 中除目标模块外均为 up-to-date（输出尾段无其他 Built 行），即依赖未被动，符合"只重建目标"的预期。
- `MulticolorTriangleRamsey.lean` 仅 `import Mathlib`，无本地依赖，重建 = 单模块编译。

## 4. sha256 对比（重建后 vs 删除前）

```
SpherePacking.olean            9bd5589267363f2296bb44c89bdf81cd57b9d70a1d86d3a977d59b7f6d412f81  == 删除前 ✓（逐位一致）
MulticolorTriangleRamsey.olean 1bd5feb2ab75f9054de880dc01fdb71e415ddd6af0b5bf936f757a488d36279f  == 删除前 ✓（逐位一致）
```
全量 `sha256sum -c` 校验删除前基线 10/10 **全部"成功"**——重建的两个逐位一致，其余 8 个未被 lake 触碰。文件大小亦逐一相同（51,669,352 B / 4,160,152 B）。

## 5. 耗时量级比对（vs `~/github/ten-proofs-independent-replication/README.md` 声称值）

README 原文（grep 核实）：
- 行 14：`MulticolorTriangleRamsey.lean … 135 s`
- 行 21：`SpherePacking.lean … 201 s`

| 目标 | 声称 | 本次实测 (wall) | 比值 | 量级判定 |
|---|---|---|---|---|
| SpherePacking | 201 s | 148.5 s | 1.35× | **同量级，吻合**（同机不同负载即可解释） |
| MulticolorTriangleRamsey | 135 s | 11.9 s | **11.3×** | **差一个数量级，超出 3× 阈值，点出** |

**MulticolorTriangleRamsey 的 11× 差异**：本次 user time 41.4 s、单模块 3053 行、仅依赖 Mathlib、无本地模块可搭车——11.9 s 是该模块在本机（预构建 mathlib + 热缓存）的真实编译耗时。135 s 无法由"依赖被连带重建"解释（无本地依赖）。候选解释（均未逐一证实）：声称值在更慢/更高负载状态下测得；或冷文件缓存；或测法不同（如含首轮全链 warm-up）。**该差异不改变可复现性结论**（主判据是产物逐位一致，已达成），但 README 的耗时列对 Multicolor 一项**不能作为本机量级的参考**，偏保守约一个数量级。

## 6. 结论

**可复现：通过。**
1. 删除两个 olean 后 `lake build` 均一次成功（rc=0），无警告阻断、无手工干预。
2. 重建产物与删除前**逐位一致**（sha256 相同），且其余 8 个 olean 未受影响——Lean 编译在本机确定性成立。
3. 耗时：SpherePacking 与声称值同量级（148.5 s vs 201 s）；MulticolorTriangleRamsey 快约 11×（11.9 s vs 声称 135 s），已如实点出；该差异只影响耗时参考值，不影响"证书可由源码确定性重建"这一主结论。

原始证据：`/tmp/opencode/review_B_olean_before.txt`（基线 sha256）；上方两段 `/usr/bin/time -v` 输出为逐字摘录。
