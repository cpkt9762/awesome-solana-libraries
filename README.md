# Awesome Solana Libraries

一个全面的Solana生态系统知识库，收集和整理Solana开发中的各种资源、工具和最佳实践。

## 📚 项目简介

这个仓库致力于成为Solana开发者的一站式资源中心，包含：

- 🏗️ **依赖库与工具** - Solana开发中常用的库和依赖
- 🔧 **MCP服务** - Model Context Protocol相关工具和服务
- 🌐 **RPC节点** - Solana网络RPC端点和服务商
- 🚀 **交易发送服务** - 第三方交易发送服务商和MEV服务
- 🔄 **DEX做市商** - 各个去中心化交易所做市商工具和GitHub
- 📖 **知识链接** - Solana学习资源和文档
- 🛠️ **开发工具** - 提升开发效率的各种工具

## 📁 内容结构

### 依赖库管理
- [Solana依赖库清单](/dependencies/solana-dependencies.md) - 常用Rust crates和JavaScript包
- [版本兼容性指南](/dependencies/compatibility.md) - 不同版本间的兼容性说明

### MCP服务
- [MCP工具集合](/mcp/tools.md) - 可用的MCP服务和配置
- [自定义MCP开发](/mcp/development.md) - 如何创建自己的MCP服务

### RPC服务
- [公共RPC节点](/rpc/public-endpoints.md) - 免费和付费RPC服务商
- [私有节点配置](/rpc/private-setup.md) - 自建节点的配置指南

### 交易发送服务
- [MEV服务商](/transaction-services/mev-services.md) - Jito Labs、Bloxroute等
- [交易中继服务](/transaction-services/relayers.md) - 第三方交易中继和优化服务
- [优先费用服务](/transaction-services/priority-fee.md) - 动态优先费用API和工具

### DEX做市商
- [Raydium生态](/dex-market-makers/raydium.md) - Raydium相关做市工具
- [Orca生态](/dex-market-makers/orca.md) - Orca AMM做市商资源
- [Phoenix生态](/dex-market-makers/phoenix.md) - Phoenix订单簿做市商
- [OpenBook生态](/dex-market-makers/openbook.md) - OpenBook DEX做市工具
- [Jupiter生态](/dex-market-makers/jupiter.md) - Jupiter聚合器相关工具

### 知识资源
- [官方文档](/resources/official.md) - Solana官方资源链接
- [社区资源](/resources/community.md) - 社区教程和文章
- [视频教程](/resources/videos.md) - YouTube频道和在线课程
- [示例项目](/resources/examples.md) - 开源项目和代码示例

## 🔗 快速链接

### 主要交易服务商
- [Jito Labs](https://www.jito.wtf/) - MEV保护和提取服务
- [Bloxroute](https://bloxroute.com/) - 区块链基础设施和MEV服务
- [Triton One](https://triton.one/) - 高性能RPC和交易服务
- [Helius](https://www.helius.dev/) - RPC服务和开发者工具

### 主要DEX做市商GitHub
- [Raydium SDK](https://github.com/raydium-io/raydium-sdk) - Raydium官方SDK
- [Orca SDK](https://github.com/orca-so/orca-sdk) - Orca Whirlpools SDK
- [Phoenix SDK](https://github.com/Ellipsis-Labs/phoenix-sdk) - Phoenix订单簿SDK
- [OpenBook SDK](https://github.com/openbook-dex/openbook-v2) - OpenBook V2 SDK

## 🚀 快速开始

1. 浏览 [依赖库清单](/dependencies/solana-dependencies.md) 了解推荐的开发工具
2. 选择合适的 [RPC节点](/rpc/public-endpoints.md) 进行开发
3. 了解 [交易发送服务](/transaction-services/) 优化交易执行
4. 参考 [DEX做市商](/dex-market-makers/) 学习自动化交易
5. 查看 [知识资源](/resources/) 深入学习Solana开发

## 🚧 待搜集内容

### 高优先级待搜集
- ⏳ **MCP服务** - 各种Solana相关的MCP (Model Context Protocol) 服务和配置
- ⏳ **优先费用服务** - 动态优先费用API服务商列表和对比
- ⏳ **交易中继服务** - 第三方交易中继和优化服务详细信息
- ⏳ **DEX做市商工具** - 各个DEX的做市商GitHub仓库和工具集合

### 中优先级待搜集
- ⏳ **私有RPC配置** - 自建Solana节点的详细配置指南
- ⏳ **版本兼容性** - 不同Solana版本间的兼容性问题和解决方案
- ⏳ **社区资源** - 优质的社区教程、文章和讨论
- ⏳ **视频教程** - YouTube频道和在线课程推荐

### 低优先级待搜集
- ⏳ **示例项目** - 高质量的开源Solana项目案例
- ⏳ **开发工具** - 提升开发效率的工具和插件
- ⏳ **测试资源** - 测试网资源和开发工具

### 已完成内容
- ✅ **Solana依赖库清单** - 完整的Rust crates和依赖管理策略

## 🤝 贡献指南

欢迎提交Pull Request来丰富这个知识库：

- 添加新的依赖库和工具
- 分享有用的RPC服务和MEV服务商
- 推荐优质的学习资源
- 提交DEX做市商工具和GitHub仓库
- 修正错误或过时信息

### 提交格式
- 依赖库：包含名称、用途、版本兼容性
- 服务商：包含名称、功能、定价模式、文档链接
- GitHub项目：包含描述、维护状态、使用示例

## 📝 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

---

⭐ 如果这个项目对你有帮助，请给个Star支持！

## 🏷️ 标签

`solana` `blockchain` `defi` `dex` `market-making` `mev` `rpc` `sdk` `trading` `crypto`