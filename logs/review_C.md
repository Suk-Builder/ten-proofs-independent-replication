# 红队复查 C — ten-proofs-independent-replication（对抗性审读）

复查对象：`/home/baihua/github/ten-proofs-independent-replication` @ HEAD `6169a38`（2026-10-11 15:23:51）。
复查方法：通读 README.md / results/results.md / docs/METHOD.md / PROVENANCE.md / logs/ 全部 5 个日志 / scripts/ 全部 4 个脚本；对可重跑的声明**独立重跑**（不采信仓库叙述）；对 `/mnt/work/ten-proofs`（被验证对象）实测 olean 时间戳、文件行数、formalization.yaml、manifest、clone 时间。

## 红队独立重跑记录（先说哪些顶住了）

| 重跑项 | 结果 |
|---|---|
| `scripts/static_scan.sh /mnt/work/ten-proofs` | 10/10 CLEAN，rc=0，与声称一致 ✅ |
| `#print axioms GapCVP.Comparator.gapCVP400IsNPHard` | `[propext, Classical.choice, Quot.sound]` ✅（该声明在仓库内**无** verbatim 记录，本次重跑补上） |
| `#print axioms CompactnessConjecture.quantitativeCompactnessCounterexample` / `TwoDegenerateGraphs.twoDegenerateExtremalCounterexample`（基于 10-10 18:55 预编译 olean） | 三元组均成立 ✅ |
| `#print axioms …exists_finitelyPresented_nonsofic_group`（NonSoficGroup） | 三元组成立，输出格式与 results.md:17-19 verbatim 一致 ✅ |
| MetricCodes 两个声明 | 本次未能重跑：复查期间共享 checkout 被并发改动（见 M2），`SpherePacking.olean` 被并发 rebuild 短暂移除导致 import 失败——非仓库缺陷，但恰好演示了 M2 的链条风险 |
| 数字核对：README 表格 11 行耗时 vs results.md vs build_rest/monitor 日志 | 135/87/3.8(115+107)/478/204(203.96+97.98)/201.50/705.22/685.19/304.84 全部三方一致；队列总和 2697.94s = 44m58s 与起止时刻吻合 ✅；548,215 行总数与实测 `wc -l` 一致 ✅ |

**实质结论（11 个结果的构建产物 + 12 个主声明的 axiom 三元组）在我能重跑的范围内全部成立。** 以下问题全部是**声称口径、证据完备性、溯源链条**层面的问题，不动摇内核级结论本身。

---

## 严重（必须改）

### S1. "11/11 builds" 是错误计数，且掩盖了 CompactnessAndDegeneracy 从未由验证会话编译的事实

**证据：**
- README.md:3 "**Independent compilation** and axiom-audit"；README.md:26 "Final: **11/11 builds**"；results.md:139 "**11/11 targets compile**"；commit 6169a38 同句。
- 实际 build target 只有 **10 个**（10 个证书文件；`lakefile.toml` defaultTargets = 10 证书 + ComparatorChallenges，共 11 个——而 **ComparatorChallenges 从未被 build**，见 scripts/build_all.sh:7-9 只有 10 个目标）。"11/11" 无论按"文件"还是按"lakefile 目标"数都对不上：11 是 README 表格的行数（#3/#4 两行共用一个文件）。
- `ls -la /mnt/work/ten-proofs/.lake/build/lib/lean/CompactnessAndDegeneracy.olean` → **2026-10-10 18:55**，早于验证会话（10-11 14:30 起）约 20 小时。仓库自己的 logs/monitor_report.md:10 写明："10-10 18:55（**缓存命中，本轮为 no-op 重建**）"。
- 即：验证会话对 10 个文件中的这 1 个**只做了 up-to-date 确认（3.84s），从未自己编译**；且 rebuild-from-scratch spot check 只删了 Permanent 与 Ehrhart 的 olean（results.md:129），**CompactnessAndDegeneracy 不在其中**——它是 10 个文件里唯一一个没有任何"由验证方从源码编译"记录的文件。
- PROVENANCE.md:30 "certificates built **2026-10-11**" 与 10-10 18:55 的 olean **直接矛盾**。
- README.md:16 "3.8 s (re-verify)" 技术上算披露，但读者无法从 README得知该 olean 是**环境准备方在验证前一天**编的；git 历史 fa10545（14:37:22 "5/11 builds"）还把当时仍在编译中的 ConnesRigidity 计入了"已构建"。

**修改建议：**
1. 全仓统一改为："10/10 targets compile — **9 compiled by this verification session** (2026-10-11); **CompactnessAndDegeneracy verified up-to-date against a pre-existing olean built 2026-10-10 18:55 by the environment preparer** (see logs/monitor_report.md); not covered by the rebuild spot-check."
2. 把 rebuild spot check 扩到 CompactnessAndDegeneracy（删 olean 重建一次，~分钟级），或在 README/PROVENANCE 明说该文件缺这一层证据。
3. PROVENANCE.md:30 的 Dates 行改为如实："mathlib prebuilt 10-10 18:20；CompactnessAndDegeneracy olean prebuilt 10-10 18:55（环境准备方）；其余 9 个证书由验证会话于 10-11 编译"。
4. 修正 commit message / results.md 的 "11/11 builds"→"10/10 targets"。

### S2. "独立"的适用范围被夸大：环境准备与验证同属一方，monitor 与 reviewer 的"独立"未成立

**证据：**
- README.md:72-74 自己承认 owner 提供 "hardware, **environment setup**, and problem selection"；实测：ten-proofs clone 发生于 2026-10-10 18:18:28（.git/HEAD mtime），mathlib 预编译 10-10 18:20，Compactness olean 10-10 18:55——**验证开始前的整个环境（clone、toolchain、mathlib、1 个证书 olean）都是同一方准备的**，验证 agent 在其中作业。
- "Independent" 在本仓库只站得住"独立于 OpenAI/上游作者"这一个意思；对环境准备方、对监督者都不成立。README 标题与首句（README.md:1-3）未做任何限定。
- results.md:87 "watched by an **independent** monitor agent"——monitor 与验证 agent 是**同一操作者的同一 harness 派生的两个 AI 会话**（monitor_report.md:1 自称"看护 agent"），不构成独立方；results.md:144 "Independent re-review by separate agents: see results/independent_review.md"——该文件在已提交 HEAD 中**不存在**（results/ 只有 results.md）。

**修改建议：**
1. 标题/首句限定："Independent of the upstream authors (OpenAI)；environment prepared by the repository owner"。
2. Status 表加一列或脚注，逐行写明编译执行者（verifier / env-preparer / both）。
3. "independent monitor" 改为 "a second agent from the same operator (not an independent party)"，或删去 independent 字样。
4. results.md:144 的引用等复查文件真正入库后再提交。

---

## 中（应该改）

### M1. 12 个主声明中 6 个的 axiom 审计没有 verbatim 证据，只有脚本自评 "OK"

**证据：**
- logs/audit_all.log 全文仅 12 行 "OK <decl>"（我已通读，全文 12 行）：无 `#print axioms` 原始输出、无时间戳、无命令行、无退出码行——results.md:120 声称 "audit exit code: 0"，日志里**没有**这一行。
- results.md 只给出 6 个声明的 verbatim 输出（session 1 五个 + session 2 Connes 一个）；GapCVP、MetricCodes×2、Ehrhart、SpherePacking、QuantumParallelRepetition 共 **6 个声明只有 OK 行**。
- 根因在 scripts/audit_axioms.sh:25-27：成功时原始输出被丢弃（`out` 只在 FAIL 分支 echo）。

**修改建议：** 脚本改为无论成败都打印 `decl → out`（`echo "$out"`）；log 头部记录命令行、cwd、日期、`lean --version`，尾部记录 `exit $rc`。重跑一次重新入库。

### M2. 被验证内容无指纹，溯源链条靠"环境准备者的一次 clone + TLS"，且未与任何社区存档交叉比对

**证据：**
- PROVENANCE.md:8-9 自己写明上游是 parentless root commit、无历史；README.md:62-66 指出存档存在（chcaru/ten-proofs-archive 等）——但**仅列举，未比对**：本仓库 clone 与存档的内容一致性没有记录。
- README.md:65 "(clone of 2026-10-10)" 未写明 clone 由谁执行；实测 clone 时刻为 10-10 18:18:28，属环境准备动作（README.md:72-74 归于 owner）。
- 全仓无任何被验证源文件的 sha256——"验证的到底是不是这几个字节"完全靠口头。
- 现实演示（本次复查亲历）：复查期间 `/mnt/work/ten-proofs` 被并发进程改动（ps 实测：`lake update`（toolchain **v4.34.1**，与验证用的 v4.32.0 不同）与 `lake build SpherePacking` 同时在跑，`SpherePacking.olean` 一度从盘中消失，使我的 MetricCodes 审计重跑失败）。无指纹时，验证对象可被事后置换而仓库无法自证。

**修改建议：**
1. PROVENANCE 增补：10 个证书 .lean + All.lean 的 sha256（我已代算，可直接抄：见附录）；manifest 各依赖完整 rev 哈希；toolchain 二进制来源与哈希。
2. 对 chcaru/ten-proofs-archive 做一次内容比对（diff 或按文件 sha256），把结果写进 PROVENANCE——这是把"无历史"链条补实最便宜的一步。
3. 写明 clone 执行者与时刻。

### M3. "static-clean" 口径：仓库 23 个 .lean 只扫了 10 个，且 ComparatorChallenges 12 个文件全部含 sorry

**证据：**
- scripts/static_scan.sh:5-7 硬编码 10 个文件名；仓库实际还有 `All.lean`（10 行 import，未扫、未 build）与 `ComparatorChallenges/*.lean` 12 个。
- 实测：**12 个 ComparatorChallenges .lean 每个都含 1–8 处 `sorry`**（A:4, B_Binary:6, B_Spherical:4, C:2, D:1, E:2, F:4, G:2, H:8, I:4, J:3, J_TwoDegenerate:2）。这些是上游自带的挑战桩、不在 formalization.yaml 的 sorry_count:0 声明范围内，但 README.md:35-36 "no `sorry`, `admit`, … in the source" 与 results.md:50 "zero hits in 548,215 lines" 都没有把口径限定到"10 个证书文件"。

**修改建议：** README/RESULTS 写明："Static scan covers the 10 certificate files only; `All.lean` and the 12 `ComparatorChallenges/*.lean` files (which contain upstream's own `sorry` stubs) are outside both the scan and the audited claims."

### M4. monitor 的监视窗口只覆盖队列的后 28 分钟，results.md 的表述暗示全程

**证据：**
- results.md:87 "Full serial build queue (watched by an independent monitor agent, 2-min polling)"；但 monitor_report.md:3 自述监视窗口 **14:46:52 → 15:15:24**，而队列 **14:30:01** 已开始——前 17 分钟（Compactness、Permanent、ConnesRigidity、Ehrhart 前段）无人监视；"dmesg 无 OOM"（results.md:101）也只实测了监视窗口。
- MTR/NSG 两次构建（README 表 135s/87s）在仓库内的直接证据只有两段 **2 行、无时间戳无命令头**的片段（logs/lean_smoke_mtr.log、lean_nsg.log）；"这两个构建发生在 10-11 14:23/14:25"仅由 monitor 对 olean mtime 的 ls 旁证（monitor_report.md:26，且 monitor 自己写明"本 agent 未运行验证编译"）。

**修改建议：** results.md 写明监视窗口实际为 14:46:52–15:15:24；给两个烟测日志补时间戳/命令头，或注明"时刻依据 monitor 的 ls 实测"。

### M5. METHOD 的 TCB 清单不完备：工具链与依赖的完整性完全未讨论

**证据：** METHOD.md:19-34 列了四条"不证明"（statement fidelity、metaprogramming、kernel、openai/math），但漏了三条同样真实且未验证的前提：
1. **axiom 审计自称 authoritative（METHOD.md:15-17），但它运行在同一个未经完整性验证的工具链二进制里**——若该二进制被篡改，build 与 `#print axioms` 会一起说谎。这是本仓库威胁模型（"上游是否夹带 unsoundness"）下最承重的一条假设。
2. **mathlib 81a5d25 的真实性**只靠 HTTPS clone（mathlib 无签名 tag）；manifest 其余 10 个依赖同理。
3. **elan/Lean release 二进制**无哈希固定。

**修改建议：** METHOD 增加 "TCB beyond the kernel" 一节，列明 toolchain 二进制、elan、mathlib/依赖获取渠道，说明"与社区共享同一信任假设"或加缓解（比对官方 release 哈希）；可选加强：manifest 里现成有 Lean4Checker（`b73981992455`），可对全部目标做一次独立 kernel 重检，把"12 个声明"升级为"全量重检"。

### M6. README 复现配方与已验证环境有偏差：`lake update` 重解析依赖

**证据：** README.md:53 `lake update # pins mathlib 81a5d25`。lakefile.toml 对 mathlib 只 pin 到 **tag `v4.32.0`**；`lake update` 会重解析全部传递依赖（batteries/aesop/proofwidgets/Qq…），可能得到与上游提交的 lake-manifest.json 不同的解析结果。已验证环境的 manifest 恰好与上游一致（我核对：mathlib `81a5d257c8e4`、Comparator `07bc4ea40f22` ✅），但配方本身不忠实——更忠实的做法是**不跑** `lake update`，直接 `lake build`（用上游已提交的 manifest）。

**修改建议：** Reproduce 块改为 `lake build <Target>`（用上游 manifest），`lake update` 标注为可选并注明差异风险。

---

## 轻（可改可不改）

### L1. PROVENANCE.md:34 "max RSS ≈ 7.5 GB" 与实测不符
Permanent 实测 7,685,672 KB = **7.33 GiB**（≈7.87 GB 十进制）；"≈7.5 GB"两头不靠。results.md/monitor 用 7.33 GB（GiB）。统一为 GiB 并写明单位。

### L2. PROVENANCE.md:35 "(incl. dependency warm-up)" 无出处
MTR 构建时 mathlib 前一日已建好，8656 jobs 里未变的均为 no-op；"dependency warm-up" 是推测。删去或改为 "incl. lake scanning all 8656 products"。

### L3. METHOD.md:23 "ComparatorChallenges (A–J)" 实为 12 个配置
B 与 J 各有两个（B_BinaryCodes/B_SphericalCodes、J_CompactnessConjecture/J_TwoDegenerateGraphs，实测 ls）。另 PROVENANCE.md:19 把 Comparator 列入 Toolchain 表，易被读成"comparator 检查跑过"——加一句 "not run in this verification"（ComparatorChallenges 还需要 landrun/lean4export/nanoda_bin，见上游 ComparatorChallenges/README.md）。

### L4. audit_axioms.sh 硬编码 12 个声明而非解析 formalization.yaml
当前与 upstream `main_results` 的 12 项**一一对应**（我逐条核对 ✅），但上游 yaml 更新时会静默失配。加注释"对应 formalization.yaml v0.3 main_results（2026-10-11 核对）"或加条目数校验。

### L5. results.md:144 悬空引用 `results/independent_review.md`
已提交 HEAD（6169a38）中不存在该文件。要么先入库复查文件再提交该行，要么改 "pending"。

### L6. 静态扫描模式的小漏
`^\s*axiom `、`unsafe ` 依赖尾随空格——`axiom\tfoo`、`unsafe\t` 会漏；建议 ` ` 换 `\s`。`\b(sorry|admit)\b` 大小写敏感（Lean 关键字小写，实际风险低）。另 results.md:123 "Every declaration depends only on…" 的 "Every" 实指 12 个主声明（其余数千定理只经 grep 与 12 声明的传递闭包间接覆盖——这已足够支撑 headline 声明，但措辞宜写明 "every audited declaration"）。

### L7. 日志证据头部缺失
logs/ 共 5 个文件，其中 2 个是 2 行片段、1 个（audit_all.log）无任何头部（命令/日期/退出码）。README.md:27 称 "Raw logs in logs/"——补齐头部或把措辞降为 "log excerpts"。

---

## 附：本次复查代算的源文件 sha256（供 M2 修复直接采用）

```
a87bd60efe16dab00ba07ea4069f22b8dbc991b3f3ba34ae5088b1f8b1987cd3  MulticolorTriangleRamsey.lean
f39b61646df1206d0b592f57c77c47cc41aea4761e12d99141bdae4776095534  NonSoficGroup.lean
17637d0697b9657f221dc1aa734cb1d19765b50edbfdda1dc3446874735fbd81  CompactnessAndDegeneracy.lean
bdd53fe0b026c9b9e369db67b3c040e5d3eeffd04d13f00e041d23eb33603111  Permanent.lean
31f6c419f341ee6aa5b03bc15800a9d8ee2c654c344aab90bdef0639353ccc91  ConnesRigidity.lean
e16493429e7afaa3d12daf568ec23eddeaf02afeca414992c066f55f3251a4a5  EhrhartVolumeInequality.lean
5e8a4d4ffa0c3b8c488f99ecedc43943dff63513d65bd5bd70d5e33beccc2c0f  SpherePacking.lean
c6632bba9908e2d7148f28c110e166277425040330d5feef3a417461214d1445  QuantumParallelRepetition.lean
f8b2b1b59f094005f37f34a746f30a2aa3afb6341d63151ee4f602758731eb32  MetricCodes.lean
625d84181085b04f9214bab855880d96c0657414509976cf47fb4e5ef1cc541a  GapCVP.lean
27dacf454d00fbceb7cd0774d0266119c5f962d942b898e22e11ae34c854395a  All.lean
```
（2026-10-11 实测于 /mnt/work/ten-proofs @ 94bc0feb，.lean 文件 mtime 均为 10-10 18:18，未被后续会话改动。）

## 结论

主要矛盾：**仓库的实质验证结果是真实的（重跑全部吻合），但其对外声称层把"10 个文件中的 9 个由验证方编译 + 1 个靠环境方预编译 olean"表述成"11/11 builds / independent compilation"，并把同源 AI 会话表述成 independent monitor/reviewer。** 修改 S1/S2 后，本仓库的声称与证据即可对齐；M 级各项是把"可复跑"升级为"可自证"的廉价补强。
