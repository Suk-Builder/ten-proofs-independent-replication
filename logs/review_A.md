# 复查报告 A（重放型）· ten-proofs 独立验证仓库

- 复查人：独立复查 agent（重放型），会话 ses_ed625f910ffeR7oJWtrKgreCGb
- 日期：2026-10-11
- 被验证物：`/mnt/work/ten-proofs`（HEAD 实测 `94bc0feb6a9ff12c7d31d6de640a725c9d43d2b6`，git 输出 `94bc0fe .`）
- 声称方：`~/github/ten-proofs-independent-replication`（README.md + results/results.md）
- 方法：只读 + 重跑仓库脚本 + 手写独立 `#print axioms` 抽查 + 文件系统时间戳交叉核对。**未修改** ten-proofs 与声称仓库任何文件，未删任何 olean。

---

## 1. 可复算声称清单（提取自 README.md / results/results.md）

**S1 静态扫描**：10 个证书文件全部 CLEAN（MulticolorTriangleRamsey, CompactnessAndDegeneracy, Permanent, NonSoficGroup, ConnesRigidity, SpherePacking, EhrhartVolumeInequality, QuantumParallelRepetition, MetricCodes, GapCVP）；模式 `\b(sorry|admit)\b|native_decide|^\s*axiom |unsafe `，声称"zero hits in 548,215 lines"。

**S2 Axiom 审计**：12 条声明全部 OK、`audit exit code: 0`，每条恰为 `[propext, Classical.choice, Quot.sound]`（12 条全名列于 results.md §Full kernel axiom audit）。

**S3 编译**：11/11 目标 rc=0；串行队列各目标耗时（Compactness 3.84s 重验 / Permanent 115.02s / Connes 478.37s / Ehrhart 203.96s / SpherePacking 201.50s / Quantum 705.22s / MetricCodes 685.19s / GapCVP 304.84s；另有 Multicolor 135s、NonSofic 87s）；"ALL DONE 15:14:59"；重建抽查 Permanent 107.08s、Ehrhart 97.98s。

**S4 上游对照**：formalization.yaml 声称 sorry_count: 0 + 标准三元组，声称方称已独立确认。

---

## 2. 实测结果（原始输出）

### 2.1 静态扫描重跑
```
$ bash ~/github/ten-proofs-independent-replication/scripts/static_scan.sh /mnt/work/ten-proofs
CLEAN MulticolorTriangleRamsey
CLEAN CompactnessAndDegeneracy
CLEAN Permanent
CLEAN NonSoficGroup
CLEAN ConnesRigidity
CLEAN SpherePacking
CLEAN EhrhartVolumeInequality
CLEAN QuantumParallelRepetition
CLEAN MetricCodes
CLEAN GapCVP
STATIC_SCAN_EXIT=0
```

### 2.2 行数核对
```
$ wc -l <10 个证书文件>  →  548205 总计
$ wc -l All.lean          →  10
548205 + 10 = 548215 = 声称的 548,215（All.lean 计入）
```

### 2.3 Axiom 审计重跑（`/tmp/opencode/audit_axioms_rerun.log` 全文 13 行）
```
OK   GapCVP.Comparator.gapCVP400IsNPHard
OK   ConnesRigidity.exists_infinite_pairwise_nonisomorphic_propertyT_icc_groups_with_isomorphic_factors
OK   MetricCodes.Spherical.HigherHierarchy.strict_hierarchy
OK   SoficGroups.SourceTopLevelCompressionFinal.exists_finitelyPresented_nonsofic_group
OK   CompactnessConjecture.quantitativeCompactnessCounterexample
OK   Ehrhart.Volume.ehrhart_volume_inequality_for_sets
OK   TwoDegenerateGraphs.twoDegenerateExtremalCounterexample
OK   ErdosProblems.MulticolourTriangleRamsey.erdos_problem_183_explicit
OK   PackingBounds.sharpFullCohnElkiesManuscriptConclusions
OK   PermanentFormulaLowerBound.permanent_rational_formula_logarithmic_lower_bound
OK   MetricCodes.Johnson.binaryRate_lt_mrrw
OK   QuantumParallelRepetition.distributionUniformExponential
AUDIT_EXIT=0
```
12 条与声称集合逐一相等（输出顺序不同＝bash 关联数组随机遍历，非差异）。起止时间戳：scan_test.lean 15:26:10 → 日志落盘 15:26:42，**全程 ≈34 s**。

### 2.4 手写独立抽查（不用仓库脚本，自建 `/tmp/opencode/indp_check{1,2}.lean`）
```
$ lake env lean /tmp/opencode/indp_check1.lean   # import MulticolorTriangleRamsey
'ErdosProblems.MulticolourTriangleRamsey.erdos_problem_183_explicit' depends on axioms: [propext,
 Classical.choice,
 Quot.sound]
real 3.964s

$ lake env lean /tmp/opencode/indp_check2.lean   # import GapCVP
'GapCVP.Comparator.gapCVP400IsNPHard' depends on axioms: [propext, Classical.choice, Quot.sound]
real 3.934s
```

### 2.5 olean mtime 交叉核对声称构建时间线（`stat -c '%y %n' *.olean`）
| olean | 实测 mtime | 声称对应 | 吻合度 |
|---|---|---|---|
| MulticolorTriangleRamsey | 10-11 14:23:58 | 会话1 首批 | ✅ |
| NonSoficGroup | 14:25:51 | 87s（与上一项间隔 113s=87s+开销） | ✅ |
| ConnesRigidity | 14:39:42 | 声称 "END 14:39:59" | ✅ 差 17s |
| SpherePacking | 14:46:24 | Connes 末 + Ehrhart 203.96s + Sphere 201.50s ≈ 14:46:29 | ✅ 差 5s |
| QuantumParallelRepetition | 14:58:04 | 上项 + 705.22s ≈ 14:58:09 | ✅ 差 5s |
| MetricCodes | 15:09:21 | 上项 + 685.19s ≈ 15:09:29 | ✅ 差 8s |
| GapCVP | 15:14:28 | 上项 + 304.84s ≈ 15:14:26；"ALL DONE 15:14:59" | ✅ |
| Permanent | 15:20:54 | 重建 107.08s | ✅ |
| EhrhartVolumeInequality | 15:22:27 | Permanent 重建末 + 97.98s ≈ 15:22:32 | ✅ 差 5s |
| CompactnessAndDegeneracy | 10-10 18:55（旧） | "up-to-date re-verify rc=0 3.84s"（未重编） | ✅ |

连续队列段各间隔与声称 WALL 时间差均 ≤8s。**编译耗时声称由文件系统时间戳独立佐证，无需重跑 45 分钟构建。**

### 2.6 扫描器有效性自测（合成文件，/tmp/opencode/scan_test.lean）
模式对 sorry/admit/native_decide/顶层 axiom/unsafe 全部命中，对正常 theorem 不误报——脚本 grep 模式本身有效。

### 2.7 上游 formalization.yaml 核对
12 条 declaration 名与审计脚本的 12 键逐一对应，均为 `sorry_count: 0` + 标准三元组——脚本审的确实是上游声称的清单。

---

## 3. 逐项比对表

| # | 声称 | 实测 | 判定 |
|---|---|---|---|
| 1 | 10/10 文件静态 CLEAN | 10/10 CLEAN，exit 0 | ✅ 一致 |
| 2 | 548,215 行零命中 | 548,215（10 证书 548,205 + All.lean 10） | ✅ 一致（All.lean 计入才对上，备注①） |
| 3 | 12/12 axiom 审计 OK | 12/12 OK，exit 0，集合逐一相等 | ✅ 一致 |
| 4 | 每条恰为 [propext, Classical.choice, Quot.sound] | 仓库脚本 12/12 匹配；手写抽查 2/2 原文一致（含被抽中最重的 GapCVP） | ✅ 一致 |
| 5 | 11/11 编译 rc=0 | olean 10 个全在（ComparatorChallenges 未计入 11 目标口径）；两目标 import 成功 | ✅ 佐证（未全量重编，超本轮范围） |
| 6 | 串行队列各 WALL 耗时 | mtime 链与声称差 ≤8s（连续段） | ✅ 一致 |
| 7 | 重建 Permanent 107s / Ehrhart 98s | Permanent.olean 15:20:54、Ehrhart 15:22:27，间隔 ≈93s | ✅ 一致 |
| 8 | HEAD 94bc0feb | git rev-parse 一致 | ✅ 一致 |

## 4. 结论

**声称全部可复现。** 静态扫描、12 条 axiom 审计、手写独立抽查 2 条、构建时间线（mtime 佐证）全部与 README/results.md 一致，未发现任何不符项。上游 formalization.yaml 的 sorry_count:0 与标准三元组声称，就 10 个证书文件 + 12 条主声明而言**独立成立**。

**备注（非不符项）**：
1. **行数口径**："548,215 lines" 需把 `All.lean`（10 行 import）计入才与 `wc -l` 的 548,205 吻合；静态扫描脚本本身只扫 10 个证书文件（All.lean 亦无命中，实测）。
2. **范围外事实**：`ComparatorChallenges/` 目录存在大量 `sorry`（J_CompactnessConjecture、I_MulticolorTriangleRamsey 等多文件）。这不与任何声称矛盾——README 已注明该目录是 upstream 的 statement-matching 对照目标、不在验证范围——但"ten-proofs 无 sorry"仅在 10 个证书文件口径下成立，读者不应外推到全仓库。
3. **任务卡预估勘误**：任务卡称 axiom 审计"约 5-8 分钟"，实测 ≈34 秒（每条 `#print axioms` 只加载 olean ≈3-4s，与手写抽查实测一致）。
