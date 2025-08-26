# Jupiter - Solana 聚合交易协议

## 🌟 服务概述

Jupiter 是 Solana 生态系统中领先的 DEX 聚合器，通过聚合多个 AMM 和 DEX 为用户提供最优交易路径和最佳价格执行。

### 核心信息
- **官网**: [https://jup.ag/](https://jup.ag/)
- **API文档**: [https://dev.jup.ag/docs/apis/swap-api](https://dev.jup.ag/docs/apis/swap-api)
- **聚合协议**: 支持30+个DEX协议
- **日交易量**: 数亿美元级别

## 🚀 V6 Swap API

### API端点架构

#### 免费版API (2024年12月更新)
```typescript
// 免费版端点
const FREE_API = {
  baseUrl: 'https://lite-api.jup.ag/swap/v1',
  rateLimit: '1 RPS',
  platformFee: '0.20%',
  restrictions: {
    swapInstructions: true, // 仅支持swap-instructions
    quote: false,
    swap: false
  }
};

// 原Quote API (仍然免费)
const QUOTE_API = {
  baseUrl: 'https://quote-api.jup.ag/v6',
  endpoints: {
    quote: '/quote',
    tokens: '/tokens',
    price: '/price'
  }
};
```

#### 付费版API
```typescript
// 付费版端点 (需要API Key)
const PAID_API = {
  baseUrl: 'https://api.jup.ag/swap/v1',
  tiers: {
    starter: { rps: 10, price: '$99/month' },
    growth: { rps: 50, price: '$499/month' },
    scale: { rps: 150, price: '$1299/month' },
    enterprise: { rps: 300, price: '$2999/month' }
  }
};
```

### Quote API 详解

#### 获取交易报价
```typescript
interface QuoteRequest {
  inputMint: string;        // 输入代币mint地址
  outputMint: string;       // 输出代币mint地址
  amount: number;           // 交易数量(最小单位)
  slippageBps?: number;     // 滑点基点 (50 = 0.5%)
  platformFeeBps?: number;  // 平台费用基点
  maxAccounts?: number;     // 最大账户数(默认64)
  restrictIntermediateTokens?: boolean; // 限制中间代币
  asLegacyTransaction?: boolean; // 传统交易格式
  dynamicSlippage?: boolean; // 动态滑点
}

// Quote API调用示例
class JupiterQuoteClient {
  private baseUrl = 'https://quote-api.jup.ag/v6';

  async getQuote(params: QuoteRequest): Promise<QuoteResponse> {
    const url = new URL(`${this.baseUrl}/quote`);
    
    // 添加查询参数
    Object.entries(params).forEach(([key, value]) => {
      if (value !== undefined) {
        url.searchParams.append(key, value.toString());
      }
    });

    const response = await fetch(url.toString());
    return response.json();
  }
  
  async getTokenList(): Promise<Token[]> {
    const response = await fetch(`${this.baseUrl}/tokens`);
    return response.json();
  }
  
  async getTokenPrice(mint: string): Promise<PriceData> {
    const response = await fetch(`${this.baseUrl}/price?ids=${mint}`);
    return response.json();
  }
}
```

#### Quote响应格式
```typescript
interface QuoteResponse {
  inputMint: string;
  inAmount: string;
  outputMint: string;
  outAmount: string;
  otherAmountThreshold: string;
  swapMode: string;
  slippageBps: number;
  platformFee?: {
    amount: string;
    feeBps: number;
  };
  priceImpactPct: string;
  routePlan: RouteStep[];
  contextSlot?: number;
  timeTaken?: number;
}

interface RouteStep {
  swapInfo: {
    ammKey: string;
    label: string;
    inputMint: string;
    outputMint: string;
    inAmount: string;
    outAmount: string;
    feeAmount: string;
    feeMint: string;
  };
  percent: number;
}
```

### Swap API 详解

#### 获取交易指令
```typescript
interface SwapRequest {
  quoteResponse: QuoteResponse;  // Quote API响应
  userPublicKey: string;         // 用户公钥
  dynamicComputeUnitLimit?: boolean;  // 动态计算单元限制
  prioritizationFeeLamports?: number; // 优先费用
  feeAccount?: string;           // 费用账户
  trackingAccount?: string;      // 跟踪账户
  computeUnitPriceMicroLamports?: number; // 计算单元价格
  asLegacyTransaction?: boolean; // 传统交易
  useTokenLedger?: boolean;      // 代币账本
}

// Swap API调用示例
class JupiterSwapClient {
  private baseUrl = 'https://api.jup.ag/swap/v1'; // 付费版
  private apiKey: string;

  constructor(apiKey: string) {
    this.apiKey = apiKey;
  }

  async getSwapInstructions(request: SwapRequest): Promise<SwapInstructionsResponse> {
    const response = await fetch(`${this.baseUrl}/swap-instructions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.apiKey}`
      },
      body: JSON.stringify(request)
    });
    
    return response.json();
  }

  async getSwapTransaction(request: SwapRequest): Promise<SwapResponse> {
    const response = await fetch(`${this.baseUrl}/swap`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${this.apiKey}`
      },
      body: JSON.stringify(request)
    });
    
    return response.json();
  }
}
```

#### Swap指令响应格式
```typescript
interface SwapInstructionsResponse {
  tokenLedgerInstruction?: string;     // 代币账本指令
  computeBudgetInstructions: string[]; // 计算预算指令
  setupInstructions: string[];         // 设置指令
  swapInstruction: string;             // 交换指令
  cleanupInstruction?: string;         // 清理指令
  addressLookupTableAddresses: string[]; // 查找表地址
}
```

### 完整Swap集成示例

#### 基础Swap流程
```typescript
import { Connection, Keypair, Transaction, VersionedTransaction } from '@solana/web3.js';

class JupiterSwapIntegration {
  private quoteClient: JupiterQuoteClient;
  private swapClient: JupiterSwapClient;
  private connection: Connection;

  constructor(apiKey: string, rpcUrl: string) {
    this.quoteClient = new JupiterQuoteClient();
    this.swapClient = new JupiterSwapClient(apiKey);
    this.connection = new Connection(rpcUrl);
  }

  async executeSwap(
    inputMint: string,
    outputMint: string,
    amount: number,
    slippageBps: number = 50,
    userKeypair: Keypair
  ): Promise<string> {
    
    // 1. 获取报价
    const quote = await this.quoteClient.getQuote({
      inputMint,
      outputMint,
      amount,
      slippageBps,
      platformFeeBps: 20, // 0.2% 平台费
      dynamicSlippage: true
    });
    
    console.log(`交换路径: ${quote.routePlan.length} 步`);
    console.log(`价格影响: ${quote.priceImpactPct}%`);
    
    // 2. 获取交易指令
    const swapResult = await this.swapClient.getSwapInstructions({
      quoteResponse: quote,
      userPublicKey: userKeypair.publicKey.toString(),
      dynamicComputeUnitLimit: true,
      prioritizationFeeLamports: 10000,
      useTokenLedger: false
    });
    
    // 3. 构建版本化交易
    const transaction = await this.buildVersionedTransaction(
      swapResult,
      userKeypair.publicKey
    );
    
    // 4. 签名并发送交易
    transaction.sign([userKeypair]);
    
    const signature = await this.connection.sendTransaction(transaction);
    
    console.log(`交易签名: ${signature}`);
    return signature;
  }

  private async buildVersionedTransaction(
    swapResult: SwapInstructionsResponse,
    userPublicKey: PublicKey
  ): Promise<VersionedTransaction> {
    
    // 获取最新区块哈希
    const { blockhash } = await this.connection.getLatestBlockhash();
    
    // 构建消息
    const messageV0 = new TransactionMessage({
      payerKey: userPublicKey,
      recentBlockhash: blockhash,
      instructions: [
        // 计算预算指令
        ...swapResult.computeBudgetInstructions.map(ix => 
          this.deserializeInstruction(ix)
        ),
        // 设置指令
        ...swapResult.setupInstructions.map(ix => 
          this.deserializeInstruction(ix)
        ),
        // 交换指令
        this.deserializeInstruction(swapResult.swapInstruction),
        // 清理指令
        ...(swapResult.cleanupInstruction ? 
          [this.deserializeInstruction(swapResult.cleanupInstruction)] : []
        )
      ]
    }).compileToV0Message(
      // 查找表地址
      swapResult.addressLookupTableAddresses.map(addr => 
        new AddressLookupTableAccount({
          key: new PublicKey(addr),
          state: AddressLookupTableState.deactivate() // 需要实际获取状态
        })
      )
    );
    
    return new VersionedTransaction(messageV0);
  }
}
```

### 高级特性

#### 动态滑点计算
```typescript
class DynamicSlippageManager {
  async calculateOptimalSlippage(
    inputMint: string,
    outputMint: string,
    amount: number
  ): Promise<number> {
    
    // 获取初始报价
    const quote = await this.quoteClient.getQuote({
      inputMint,
      outputMint,
      amount,
      slippageBps: 50,
      dynamicSlippage: true
    });
    
    // 如果启用了动态滑点，Jupiter会自动计算
    if (quote.dynamicSlippage) {
      return quote.slippageBps;
    }
    
    // 否则根据流动性和价格影响计算
    const priceImpact = parseFloat(quote.priceImpactPct);
    
    let recommendedSlippage: number;
    
    if (priceImpact < 0.1) {
      recommendedSlippage = 50;  // 0.5%
    } else if (priceImpact < 0.5) {
      recommendedSlippage = 100; // 1%
    } else if (priceImpact < 1.0) {
      recommendedSlippage = 200; // 2%
    } else {
      recommendedSlippage = 500; // 5%
    }
    
    return recommendedSlippage;
  }
}
```

#### 路由分析器
```typescript
class RouteAnalyzer {
  analyzeRoute(quote: QuoteResponse): RouteAnalysis {
    const analysis = {
      totalSteps: quote.routePlan.length,
      dexProtocols: new Set<string>(),
      priceImpact: parseFloat(quote.priceImpactPct),
      isDirectRoute: quote.routePlan.length === 1,
      intermediateTokens: [] as string[],
      complexity: 'low' as 'low' | 'medium' | 'high'
    };
    
    // 分析DEX协议分布
    quote.routePlan.forEach(step => {
      analysis.dexProtocols.add(step.swapInfo.label);
      
      // 收集中间代币
      if (step.swapInfo.outputMint !== quote.outputMint) {
        analysis.intermediateTokens.push(step.swapInfo.outputMint);
      }
    });
    
    // 评估复杂度
    if (quote.routePlan.length === 1) {
      analysis.complexity = 'low';
    } else if (quote.routePlan.length <= 3) {
      analysis.complexity = 'medium';
    } else {
      analysis.complexity = 'high';
    }
    
    return analysis;
  }
  
  findBestRoute(quotes: QuoteResponse[]): QuoteResponse {
    return quotes.reduce((best, current) => {
      const bestOutput = parseFloat(best.outAmount);
      const currentOutput = parseFloat(current.outAmount);
      
      // 优先考虑输出量，然后考虑价格影响
      if (currentOutput > bestOutput) {
        return current;
      } else if (currentOutput === bestOutput) {
        const bestImpact = parseFloat(best.priceImpactPct);
        const currentImpact = parseFloat(current.priceImpactPct);
        return currentImpact < bestImpact ? current : best;
      }
      
      return best;
    });
  }
}
```

### 错误处理和重试

#### 智能重试策略
```typescript
class JupiterErrorHandler {
  private readonly retryableErrors = [
    'AccountNotFound',
    'SlippageToleranceExceeded', 
    'InsufficientFunds',
    'NetworkError'
  ];

  async executeWithRetry<T>(
    operation: () => Promise<T>,
    maxRetries: number = 3
  ): Promise<T> {
    
    let lastError: Error;
    
    for (let attempt = 0; attempt < maxRetries; attempt++) {
      try {
        return await operation();
      } catch (error) {
        lastError = error;
        
        if (!this.isRetryableError(error) || attempt === maxRetries - 1) {
          throw error;
        }
        
        // 根据错误类型调整重试策略
        const delay = this.calculateRetryDelay(error, attempt);
        await this.sleep(delay);
        
        // 对于滑点错误，增加滑点容忍度
        if (error.message.includes('SlippageToleranceExceeded')) {
          await this.adjustSlippageTolerance(error);
        }
      }
    }
    
    throw lastError;
  }

  private isRetryableError(error: Error): boolean {
    return this.retryableErrors.some(retryable => 
      error.message.includes(retryable)
    );
  }
  
  private calculateRetryDelay(error: Error, attempt: number): number {
    const baseDelay = 1000; // 1秒
    const backoffMultiplier = Math.pow(2, attempt);
    
    // 网络错误需要更长的等待时间
    if (error.message.includes('NetworkError')) {
      return baseDelay * backoffMultiplier * 2;
    }
    
    return baseDelay * backoffMultiplier;
  }
}
```

### 费用优化

#### 智能费用管理
```typescript
class JupiterFeeOptimizer {
  async optimizeTransactionFees(
    quote: QuoteResponse,
    urgency: 'low' | 'medium' | 'high'
  ): Promise<FeeConfiguration> {
    
    // 获取当前网络费用状况
    const networkFees = await this.getNetworkFeeStats();
    
    const feeMultipliers = {
      low: 1.1,
      medium: 1.5,
      high: 2.5
    };
    
    // 计算优先费用
    const basePriorityFee = networkFees.median;
    const priorityFee = Math.floor(
      basePriorityFee * feeMultipliers[urgency]
    );
    
    // 计算计算单元价格
    const computeUnitPrice = Math.floor(priorityFee / 200000); // 假设20万计算单元
    
    // 优化平台费用
    const platformFeeBps = this.calculateOptimalPlatformFee(quote);
    
    return {
      prioritizationFeeLamports: Math.min(priorityFee, 50000), // 最大5万lamports
      computeUnitPriceMicroLamports: Math.max(computeUnitPrice, 1),
      platformFeeBps,
      estimatedTotalFee: priorityFee + (parseFloat(quote.inAmount) * platformFeeBps / 10000)
    };
  }
  
  private calculateOptimalPlatformFee(quote: QuoteResponse): number {
    const inAmountSol = parseFloat(quote.inAmount) / LAMPORTS_PER_SOL;
    
    // 小额交易减少平台费用
    if (inAmountSol < 1) {
      return 10; // 0.1%
    } else if (inAmountSol < 10) {
      return 15; // 0.15%
    } else {
      return 20; // 0.2%
    }
  }
}
```

## 📊 监控和分析

### 交易监控
```typescript
class JupiterTransactionMonitor {
  private metrics = {
    totalSwaps: 0,
    successfulSwaps: 0,
    failedSwaps: 0,
    totalVolume: 0,
    avgSlippage: 0,
    avgExecutionTime: 0
  };
  
  async trackSwap(
    quote: QuoteResponse,
    executionResult: ExecutionResult
  ): Promise<void> {
    
    this.metrics.totalSwaps++;
    this.metrics.totalVolume += parseFloat(quote.inAmount);
    
    if (executionResult.success) {
      this.metrics.successfulSwaps++;
      
      // 计算实际滑点
      const actualSlippage = this.calculateActualSlippage(
        quote.outAmount, 
        executionResult.actualOutput
      );
      
      this.updateAverageSlippage(actualSlippage);
      this.updateExecutionTime(executionResult.executionTime);
      
    } else {
      this.metrics.failedSwaps++;
    }
    
    // 记录到监控系统
    await this.sendMetricsToMonitoring();
  }
  
  generateReport(): SwapReport {
    return {
      successRate: (this.metrics.successfulSwaps / this.metrics.totalSwaps * 100).toFixed(2) + '%',
      totalVolume: (this.metrics.totalVolume / LAMPORTS_PER_SOL).toFixed(2) + ' SOL',
      averageSlippage: this.metrics.avgSlippage.toFixed(4) + '%',
      averageExecutionTime: this.metrics.avgExecutionTime.toFixed(0) + 'ms'
    };
  }
}
```

## 🔧 最佳实践

### 集成建议
1. **Quote刷新**: 超过30秒的quote应重新获取
2. **滑点设置**: 根据市场波动性动态调整
3. **费用优化**: 根据交易紧急程度设置合理的优先费用
4. **错误处理**: 实现完善的错误处理和重试机制
5. **监控报警**: 建立交易成功率和滑点监控

### 安全考虑
- 验证所有quote参数的合理性
- 设置最大滑点限制保护用户
- 监控异常的价格影响
- 实施交易限额控制
- 定期审计交易路径的安全性

## 🔮 未来发展

### 技术路线图
- **跨链聚合**: 支持多链DEX聚合
- **AI路由**: 机器学习优化路由选择
- **流动性预测**: 预测性流动性分析
- **MEV保护**: 增强的MEV保护机制

### 生态系统扩展
- **更多协议**: 集成更多DEX和AMM
- **衍生品**: 支持期货和期权交易
- **机构服务**: 面向机构的大额交易解决方案
- **开发者工具**: 更完善的SDK和工具链