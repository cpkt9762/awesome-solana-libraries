# GitHub 开源套利项目汇总

## 🚀 DEX 套利机器人

### 🥇 Jito Labs 官方 MEV 机器人
**仓库**: [jito-labs/mev-bot](https://github.com/jito-labs/mev-bot)

专为 Solana 设计的官方 MEV 机器人，专注于 SOL 和 USDC 的回跑套利。

**核心特性**:
- 监控 mempool 中的待处理交易
- 利用 Jito bundles 执行回跑交易
- 支持多平台: Raydium、Raydium CLMM、Orca Whirlpools、Orca AMM
- 集成 Solend 闪电贷功能
- 使用 Jupiter 进行多跳交易

**技术栈**: Rust, Anchor Framework
**适用场景**: 专业 MEV 套利，需要高性能和低延迟

---

### 🏆 ARB Protocol V2
**仓库**: [ARBProtocol/ARB-V2](https://github.com/ARBProtocol/ARB-V2)

高级开源套利机器人，在 Solana 区块链上运行，监控多个 DEX 以识别和执行盈利的套利机会。

**核心特性**:
- 跟踪主要 Solana DEX 价格差异 (Meteora, Raydium, Orca)
- HARBR 链上程序双重检查交易防损失
- 本地运行增强安全性和控制
- 自动风险管理和滑点保护

**技术栈**: Rust, TypeScript
**社区评价**: ⭐ 高度活跃的开源社区

**配套项目**: [ARBProtocol/solana-jupiter-bot](https://github.com/ARBProtocol/solana-jupiter-bot)
- 使用 Jupiter 的自动化套利机器人
- 处理 USDC/USDT 等主流交易对的滑点问题
- JavaScript 实现，易于定制

---

### 🔥 高性能多 DEX 套利机器人
**仓库**: [0xNineteen/solana-arbitrage-bot](https://github.com/0xNineteen/solana-arbitrage-bot)

跨多个现货 DEX 的 Solana 套利机器人，由独立搜索者开源。

**独特之处**:
- 不计算最优交易输入量，而是通过多个递减数额并发执行
- 暴力搜索方法比负循环算法更快
- "孤独搜索者"的开源贡献精神

**技术栈**: 主要使用 Rust
**设计理念**: 速度优于精确度，适合高频套利

---

### 📊 链上套利程序样本
**仓库**: [buffalojoec/arb-program](https://github.com/buffalojoec/arb-program)

Solana 链上套利机器人样本，评估所有可能的资产配对并确定套利机会。

**核心特性**:
- 使用模拟交易确保盈利性后再支付交易费用
- 实现地址查找表(ALTs)提高并发性和账户打包
- 双交换池间的自动交易执行
- 完整的链上执行逻辑

**技术栈**: Rust, Anchor Framework
**适用场景**: 学习链上程序开发的最佳起点

---

## 🌊 跨链和 CEX-DEX 套利

### 💎 综合套利解决方案
**仓库**: [vj013il/solana-arbitragebot-dca](https://github.com/vj013il/solana-arbitragebot-dca)

Solana 网络中的自主安全交易工具，集成多种策略。

**功能集合**:
- 通过 Jupiter API 自动化 DCA (定投)
- CEX/DEX 套利 (Raydium, Orca, Binance 等)
- MEV 保护机制
- 巨鲸交易复制功能
- Turbo/安全模式切换

**技术栈**: Python/JavaScript
**独特价值**: 多策略集成，适合综合交易需求

---

### 🔄 多 DEX 跨链套利
**仓库**: [ChangeYourself0613/Solana-Arbitrage-Bot](https://github.com/ChangeYourself0613/Solana-Arbitrage-Bot)
**镜像仓库**: [OnlyForward0613/Solana-Arbitrage-Bot](https://github.com/OnlyForward0613/Solana-Arbitrage-Bot)

实现跨 DEX 的高级套利策略，支持 Raydium、Orca、Meteora 交换程序。

**技术特性**:
- Rust 语言架构 + Anchor 框架
- 2025 年新增 solana-program 功能
- 可选 Jito-MEV 集成
- 多跳交易策略支持

**更新状态**: 🔄 持续维护中

---

### ⚡ Jupiter V6 优化版本
**仓库**: [ChainBuff/sol-arb-bot](https://github.com/ChainBuff/sol-arb-bot)

基于 Jupiter v6 的 Solana DEX 套利机器人。

**环境要求**:
- Solana RPC 节点
- 自托管 Jupiter v6 节点
- 高性能网络连接

**优势**: 基于最新 Jupiter 版本，路由优化效果更佳

---

## 🎯 Pump.fun 狙击机器人

### 🏹 专业级开源狙击工具
**仓库**: [TreeCityWes/Pump-Fun-Trading-Bot-Solana](https://github.com/TreeCityWes/Pump-Fun-Trading-Bot-Solana)

免费开源的 Solana/Pump.fun 狙击和交易机器人。

**智能策略**:
- 抓取 pump.fun 识别新代币对
- 监控有利的绑定曲线
- 市值变化监控
- 25% 利润点自动获利 (首次卖出 50%，后续卖出 75%)

**技术栈**: TypeScript, Node.js
**社区状态**: 📈 活跃维护

---

### 🎪 高级狙击脚本
**仓库**: [AmirAgassi/dump.fun](https://github.com/AmirAgassi/dump.fun)

高级开源 memecoin 发射狙击脚本。

**核心特性**:
- 逆向工程的 pump.fun 程序 IDL
- 本地 RPC 节点支持最低延迟
- 自动检测、购买、销售新发射的 memecoin
- 使用 versioned transactions 和 ALTs 优化

**性能优化**: 🚀 为本地 Solana RPC 节点设计，实现最佳延迟

---

### 🎨 TypeScript 实现狙击器
**仓库**: [carson2222/pumpfun-bot](https://github.com/carson2222/pumpfun-bot)

用于新创建 memecoin 的 Pump.Fun 狙击机器人。

**特点**:
- TypeScript + Anchor 框架
- 与 Pump.Fun 绑定曲线合约交互
- 免费 Quicknode RPC 支持
- 自动模式下 5-15 秒购买时间

---

### ⚡ Go 语言高性能版本
**仓库**: [1fge/pump-fun-sniper-bot](https://github.com/1fge/pump-fun-sniper-bot)

Go 语言实现的 Pump-Fun 狙击机器人。

**技术优势**:
- 复制 orcACR 策略
- Gagliardetto 的 Solana Go 包
- weeaa 的 Jito Go SDK
- 与 Jito 集成处理交互

**性能特点**: 🏃‍♂️ Go 语言天然高并发优势

---

### 🎁 多功能狙击套件
**仓库**: [wajahat414/solana-sniper-bot-pump-fun](https://github.com/wajahat414/solana-sniper-bot-pump-fun)

专为 Pump.fun 平台设计的 Solana 狙击机器人。

**核心功能**:
- 新代币发射实时检测
- 价格飙升前自动快速购买
- Helius API 集成
- 避免第三方费用的直接交易

**技术栈**: TypeScript, Node.js, Web3 库

---

### 🎬 综合 MEV 狙击机器人
**仓库**: [hanshaze/solana-sniper-copy-mev-trading-bot](https://github.com/hanshaze/solana-sniper-copy-mev-trading-bot)

💊 功能全面的 Solana 交易机器人集合。

**功能矩阵**:
- Raydium/Pump.fun/Pumpswap DEX 狙击
- 复制交易 MEV
- 夹层套利和交易量策略
- HFT/LFT 做市商策略
- 闪电贷策略集成
- gRPC, shred stream, shredstream 支持
- 前跑 (frontrunning) 功能

**特殊支持**: Pump.fun, bonk.fun, letsbonk 等 meme 平台
**技术特点**: 使用 0slot/0block 复制狙击技术

---

## ⚡ 闪电贷实现

### 🌊 Flash Loan Mastery
**仓库**: [moshthepitt/flash-loan-mastery](https://github.com/moshthepitt/flash-loan-mastery)

简单且优秀的 Solana 闪电贷程序。

**组件包含**:
- 智能合约启用 Solana 闪电贷
- JavaScript SDK
- CLI 工具
- Jupiter 套利交易能力

**特点**: 📚 优秀的学习资源和完整文档

---

### ♾️ 无限制闪电贷设施
**仓库**: [jordan-public/flash-loan-unlimited-solana](https://github.com/jordan-public/flash-loan-unlimited-solana)

Solana 上的新颖通用闪电贷设施原型。

**创新特性**:
- 多协议闪电贷支持
- 单笔交易中的无限不存在资金借贷
- 通用化设计理念

---

### 🌞 Solaris 协议
**仓库**: [kmadorin/solaris](https://github.com/kmadorin/solaris)

将闪电贷带入 Solana 区块链的借贷协议。

**设计灵感**: Aave 和 Compound
**核心价值**: 🔄 成熟 DeFi 协议在 Solana 上的实现

---

## 🧹 清算机器人

### 💰 Solend 官方清算器
**仓库**: [solendprotocol/liquidator](https://github.com/solendprotocol/liquidator)

Solend 协议开源版本清算机器人。

**奖励机制**:
- 识别和清算过度曝光债务
- Solend 为每次清算提供 5-20% 奖金
- 社区构建清算机器人的起点

**适用对象**: 🏪 Solend 生态系统参与者

---

### 🌞 Solaris 清算机器人
**仓库**: [solaris-protocol/solaris-liquidation-bot](https://github.com/solaris-protocol/solaris-liquidation-bot)

Solaris 协议不健康债务清算 Python 机器人。

**工作原理**:
- 获取协议内所有债务账户
- 寻找不健康账户 (borrowed_value < unhealthy_borrow_value)
- 检查清算盈利性 (liquidation_reward > flashloan_fee)

**技术栈**: Python
**盈利模式**: 闪电贷 + 清算奖励

---

### 📈 Drift 协议清算机器人
**仓库**: [lmvdz/drift-liquidation-bot](https://github.com/lmvdz/drift-liquidation-bot)

TypeScript 实现的 Drift 协议清算机器人。

**智能策略**:
- 基于保证金比率的用户优先级分桶
- 前跑清算尝试防止延迟
- TpuClient.ts 直接发送交易至 TPU Leaders

**技术优势**: 🎯 TypeScript 生态系统丰富

---

## 🤖 通用 MEV 机器人

### 🔧 优化版 Solana MEV 机器人
**仓库**: [BitFancy/Solana-MEV-Bot-Optimized](https://github.com/BitFancy/Solana-MEV-Bot-Optimized)

Rust 实现的 Solana MEV 套利机器人。

**核心特性**:
- 使用 Jito 和私有 RPC 实现闪电贷
- 多个 DEX 支持
- 闪电贷套利交易机器人

---

### 🎯 简单 MEV 模板
**仓库**: [Nicolopez603/mev-bot-solana](https://github.com/Nicolopez603/mev-bot-solana)

Solana 网络上简单的 MEV 机器人模板。

**价值**: 📖 初学者友好的模板和学习资源

---

### 🧠 高级 MEV 实现
**仓库**: [i3visio/solana-mev-bot](https://github.com/i3visio/solana-mev-bot)

集成多种策略的 Solana MEV 机器人。

**功能特性**:
- 配置加载 (config.toml)
- 多 RPC 端点支持
- 使用 Versioned Transactions 和 ALTs 优化
- 闪电贷集成
- 前跑、夹层、套利策略

**联系方式**: https://t.me/i3visio

---

## 🔗 其他相关项目

### 📊 MEV 数据收集
**仓库**: [0xMisaka/MEV-data-solana](https://github.com/0xMisaka/MEV-data-solana)

Solana MEV 数据收集和分析项目。

**价值**: 📈 历史数据显示 90 天内套利利润达 $20M

---

### 🌐 多链套利引擎
**仓库**: [slycompiler/pump.fun-bot](https://github.com/hardworking-toptal-dev/pump.fun-bot)

轻量级跨链 Solana 套利引擎。

**特色**:
- 利用以太坊 L2 的最小 gas 费用
- 通过跨链桥对 Solana 区块链执行夹层攻击
- 受益于 pump.fun 高交易量

---

### 📚 Solana Season 创意集合
**仓库**: [solana-labs/solana-season Ideas](https://github.com/solana-labs/solana-season/blob/master/ideas.md)

Solana Labs 官方创意收集，包含多个套利相关项目提案。

---

## 🏷️ 项目标签分类

### 按技术栈分类
- **Rust**: jito-labs/mev-bot, buffalojoec/arb-program, ARBProtocol/ARB-V2
- **TypeScript/JavaScript**: TreeCityWes/Pump-Fun-Trading-Bot-Solana, carson2222/pumpfun-bot
- **Python**: solaris-protocol/solaris-liquidation-bot, vj013il/solana-arbitragebot-dca
- **Go**: 1fge/pump-fun-sniper-bot

### 按策略类型分类
- **DEX 套利**: 0xNineteen/solana-arbitrage-bot, ChainBuff/sol-arb-bot
- **三角套利**: jito-labs/mev-bot, ARBProtocol/ARB-V2
- **清算套利**: solendprotocol/liquidator, drift-liquidation-bot
- **Memecoin 狙击**: dump.fun, TreeCityWes/Pump-Fun-Trading-Bot
- **MEV 策略**: BitFancy/Solana-MEV-Bot-Optimized, i3visio/solana-mev-bot

### 按维护状态分类
- **活跃维护** ✅: jito-labs/mev-bot, ARBProtocol/ARB-V2, TreeCityWes/Pump-Fun-Trading-Bot
- **定期更新** 🔄: ChangeYourself0613/Solana-Arbitrage-Bot, AmirAgassi/dump.fun
- **教育用途** 📚: buffalojoec/arb-program, moshthepitt/flash-loan-mastery

---

**⚠️ 重要提醒**: 所有项目都强调使用风险自负，建议使用临时钱包进行测试，不保证盈利。套利交易如配置或监控不当可能导致重大损失。

**最后更新**: 2025年1月