# MCP 开发指南

## 🚀 入门指南

### MCP 简介
Model Context Protocol (MCP) 是2024年11月由Anthropic发布的标准化接口，用于AI模型与工具和资源的交互。它解决了AI系统集成中的通用适配器问题，使开发者能够构建跨多个AI系统工作的标准化接口。

### 核心概念
- **服务器**: 提供资源和工具的MCP服务端
- **客户端**: 消费MCP服务的AI应用
- **资源**: 可读取的数据源（如文件、API响应等）
- **工具**: 可执行的操作（如API调用、命令执行等）

## 🏗️ 开发环境设置

### 基础要求
```bash
# Node.js环境
node --version  # >= 18.0.0
npm --version   # >= 8.0.0

# 或者使用其他语言
python --version  # >= 3.8
rust --version    # >= 1.70
```

### 安装MCP SDK
```bash
# TypeScript/JavaScript
npm install @modelcontextprotocol/sdk

# Python
pip install mcp

# Rust
cargo add mcp-sdk
```

## 📝 创建基础MCP服务器

### TypeScript实现
```typescript
import { Server } from '@modelcontextprotocol/sdk/server/index.js';
import { StdioServerTransport } from '@modelcontextprotocol/sdk/server/stdio.js';

class SolanaMCPServer {
  private server: Server;

  constructor() {
    this.server = new Server(
      {
        name: "solana-mcp-server",
        version: "1.0.0",
      },
      {
        capabilities: {
          resources: {},
          tools: {},
        },
      }
    );

    this.setupHandlers();
  }

  private setupHandlers() {
    // 添加资源处理器
    this.server.setRequestHandler('resources/list', async () => {
      return {
        resources: [
          {
            uri: "solana://balance",
            name: "Wallet Balance",
            description: "Get wallet balance information"
          }
        ]
      };
    });

    // 添加工具处理器
    this.server.setRequestHandler('tools/list', async () => {
      return {
        tools: [
          {
            name: "get_balance",
            description: "Get SOL balance for a wallet address",
            inputSchema: {
              type: "object",
              properties: {
                address: {
                  type: "string",
                  description: "Wallet address to check"
                }
              },
              required: ["address"]
            }
          }
        ]
      };
    });

    // 实现工具调用
    this.server.setRequestHandler('tools/call', async (request) => {
      if (request.params.name === "get_balance") {
        const address = request.params.arguments?.address;
        // 实际的余额查询逻辑
        const balance = await this.getWalletBalance(address);
        return {
          content: [
            {
              type: "text",
              text: `Balance: ${balance} SOL`
            }
          ]
        };
      }
    });
  }

  private async getWalletBalance(address: string): Promise<number> {
    // 实现Solana RPC调用
    // 返回余额信息
    return 0;
  }

  async run() {
    const transport = new StdioServerTransport();
    await this.server.connect(transport);
  }
}

// 启动服务器
const server = new SolanaMCPServer();
server.run();
```

### Python实现
```python
import asyncio
from mcp.server import Server, NotificationOptions
from mcp.server.models import InitializationOptions
import mcp.server.stdio
import mcp.types as types

server = Server("solana-mcp-server")

@server.list_resources()
async def handle_list_resources() -> list[types.Resource]:
    return [
        types.Resource(
            uri="solana://balance",
            name="Wallet Balance",
            description="Get wallet balance information"
        )
    ]

@server.list_tools()
async def handle_list_tools() -> list[types.Tool]:
    return [
        types.Tool(
            name="get_balance",
            description="Get SOL balance for a wallet address",
            inputSchema={
                "type": "object",
                "properties": {
                    "address": {
                        "type": "string",
                        "description": "Wallet address to check"
                    }
                },
                "required": ["address"]
            }
        )
    ]

@server.call_tool()
async def handle_call_tool(
    name: str, arguments: dict | None
) -> list[types.TextContent]:
    if name == "get_balance":
        address = arguments.get("address") if arguments else None
        if not address:
            raise ValueError("Address is required")
        
        # 实现余额查询逻辑
        balance = await get_wallet_balance(address)
        return [
            types.TextContent(
                type="text",
                text=f"Balance: {balance} SOL"
            )
        ]

async def get_wallet_balance(address: str) -> float:
    # 实现Solana RPC调用
    return 0.0

async def main():
    # 运行服务器
    async with mcp.server.stdio.stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            InitializationOptions(
                server_name="solana-mcp-server",
                server_version="1.0.0",
                capabilities=server.get_capabilities(
                    notification_options=NotificationOptions(),
                    experimental_capabilities={},
                ),
            ),
        )

if __name__ == "__main__":
    asyncio.run(main())
```

## 🔧 高级功能开发

### Solana集成
```typescript
import { Connection, PublicKey, LAMPORTS_PER_SOL } from '@solana/web3.js';

class SolanaIntegration {
  private connection: Connection;

  constructor(rpcUrl: string) {
    this.connection = new Connection(rpcUrl);
  }

  async getBalance(address: string): Promise<number> {
    try {
      const publicKey = new PublicKey(address);
      const balance = await this.connection.getBalance(publicKey);
      return balance / LAMPORTS_PER_SOL;
    } catch (error) {
      throw new Error(`Failed to get balance: ${error.message}`);
    }
  }

  async getTokenAccounts(address: string) {
    const publicKey = new PublicKey(address);
    const tokenAccounts = await this.connection.getParsedTokenAccountsByOwner(
      publicKey,
      { programId: new PublicKey('TokenkegQfeZyiNwAJbNbGKPFXCWuBvf9Ss623VQ5DA') }
    );
    
    return tokenAccounts.value.map(account => ({
      mint: account.account.data.parsed.info.mint,
      balance: account.account.data.parsed.info.tokenAmount.uiAmount,
      decimals: account.account.data.parsed.info.tokenAmount.decimals
    }));
  }
}
```

### 错误处理和验证
```typescript
import { z } from 'zod';

// 输入验证模式
const GetBalanceSchema = z.object({
  address: z.string().min(32).max(44), // Solana地址长度
  network: z.enum(['mainnet-beta', 'testnet', 'devnet']).optional()
});

class ValidationError extends Error {
  constructor(message: string) {
    super(message);
    this.name = 'ValidationError';
  }
}

// 在工具调用中使用验证
this.server.setRequestHandler('tools/call', async (request) => {
  try {
    if (request.params.name === "get_balance") {
      // 验证输入
      const validated = GetBalanceSchema.parse(request.params.arguments);
      
      const balance = await this.getWalletBalance(
        validated.address,
        validated.network || 'mainnet-beta'
      );
      
      return {
        content: [
          {
            type: "text",
            text: `Balance: ${balance} SOL`
          }
        ]
      };
    }
  } catch (error) {
    if (error instanceof z.ZodError) {
      throw new ValidationError(`Invalid input: ${error.message}`);
    }
    throw error;
  }
});
```

### 异步操作和并发控制
```typescript
class ConcurrencyManager {
  private activeRequests = new Map<string, Promise<any>>();
  private maxConcurrent = 10;
  private currentCount = 0;

  async execute<T>(key: string, operation: () => Promise<T>): Promise<T> {
    // 检查是否已有相同操作正在进行
    if (this.activeRequests.has(key)) {
      return this.activeRequests.get(key);
    }

    // 等待可用槽位
    while (this.currentCount >= this.maxConcurrent) {
      await new Promise(resolve => setTimeout(resolve, 100));
    }

    this.currentCount++;
    const promise = operation().finally(() => {
      this.currentCount--;
      this.activeRequests.delete(key);
    });

    this.activeRequests.set(key, promise);
    return promise;
  }
}
```

## 📊 监控和日志

### 结构化日志
```typescript
import { createLogger, format, transports } from 'winston';

const logger = createLogger({
  level: 'info',
  format: format.combine(
    format.timestamp(),
    format.errors({ stack: true }),
    format.json()
  ),
  transports: [
    new transports.File({ filename: 'error.log', level: 'error' }),
    new transports.File({ filename: 'combined.log' }),
    new transports.Console({
      format: format.combine(
        format.colorize(),
        format.simple()
      )
    })
  ]
});

// 在MCP服务器中使用
class LoggingMCPServer extends SolanaMCPServer {
  async run() {
    logger.info('Starting Solana MCP Server');
    
    this.server.onerror = (error) => {
      logger.error('MCP Server Error', { error: error.message, stack: error.stack });
    };
    
    await super.run();
  }
}
```

### 性能监控
```typescript
class PerformanceMonitor {
  private metrics = new Map<string, { count: number, totalTime: number }>();

  async measure<T>(operation: string, fn: () => Promise<T>): Promise<T> {
    const start = Date.now();
    try {
      const result = await fn();
      this.recordSuccess(operation, Date.now() - start);
      return result;
    } catch (error) {
      this.recordError(operation, Date.now() - start);
      throw error;
    }
  }

  private recordSuccess(operation: string, duration: number) {
    const current = this.metrics.get(operation) || { count: 0, totalTime: 0 };
    this.metrics.set(operation, {
      count: current.count + 1,
      totalTime: current.totalTime + duration
    });
  }

  private recordError(operation: string, duration: number) {
    logger.warn(`Operation ${operation} failed after ${duration}ms`);
  }

  getStats() {
    const stats = {};
    for (const [operation, data] of this.metrics) {
      stats[operation] = {
        count: data.count,
        avgTime: data.totalTime / data.count
      };
    }
    return stats;
  }
}
```

## 🔒 安全最佳实践

### 输入清理和验证
```typescript
import DOMPurify from 'dompurify';
import validator from 'validator';

class SecurityUtils {
  static sanitizeInput(input: string): string {
    // 移除潜在的恶意内容
    return DOMPurify.sanitize(input);
  }

  static validateSolanaAddress(address: string): boolean {
    // 验证Solana地址格式
    if (!address || typeof address !== 'string') return false;
    if (address.length < 32 || address.length > 44) return false;
    return /^[1-9A-HJ-NP-Za-km-z]{32,44}$/.test(address);
  }

  static validateAmount(amount: any): number {
    if (typeof amount === 'string') {
      amount = parseFloat(amount);
    }
    
    if (!Number.isFinite(amount) || amount < 0) {
      throw new ValidationError('Invalid amount');
    }
    
    if (amount > Number.MAX_SAFE_INTEGER / LAMPORTS_PER_SOL) {
      throw new ValidationError('Amount too large');
    }
    
    return amount;
  }
}
```

### 访问控制
```typescript
class AccessControl {
  private apiKeys = new Set<string>();
  private rateLimits = new Map<string, { count: number, resetTime: number }>();

  authenticate(apiKey: string): boolean {
    return this.apiKeys.has(apiKey);
  }

  checkRateLimit(identifier: string, limit: number = 100): boolean {
    const now = Date.now();
    const hour = 60 * 60 * 1000;
    
    const current = this.rateLimits.get(identifier);
    
    if (!current || now > current.resetTime) {
      this.rateLimits.set(identifier, { count: 1, resetTime: now + hour });
      return true;
    }
    
    if (current.count >= limit) {
      return false;
    }
    
    current.count++;
    return true;
  }
}
```

## 🧪 测试策略

### 单元测试
```typescript
import { jest } from '@jest/globals';
import { SolanaMCPServer } from '../src/server';

describe('SolanaMCPServer', () => {
  let server: SolanaMCPServer;
  
  beforeEach(() => {
    server = new SolanaMCPServer();
  });

  test('should handle balance requests', async () => {
    const mockBalance = 5.25;
    jest.spyOn(server, 'getWalletBalance').mockResolvedValue(mockBalance);
    
    const request = {
      params: {
        name: 'get_balance',
        arguments: { address: 'test-address' }
      }
    };
    
    const response = await server.handleToolCall(request);
    
    expect(response.content[0].text).toContain('5.25 SOL');
  });

  test('should validate input addresses', () => {
    expect(() => {
      SecurityUtils.validateSolanaAddress('invalid');
    }).toThrow(ValidationError);
    
    expect(() => {
      SecurityUtils.validateSolanaAddress('11111111111111111111111111111112');
    }).not.toThrow();
  });
});
```

### 集成测试
```typescript
describe('Solana Integration', () => {
  test('should connect to devnet', async () => {
    const integration = new SolanaIntegration('https://api.devnet.solana.com');
    const balance = await integration.getBalance('11111111111111111111111111111112');
    expect(typeof balance).toBe('number');
  });

  test('should handle invalid addresses gracefully', async () => {
    const integration = new SolanaIntegration('https://api.devnet.solana.com');
    await expect(
      integration.getBalance('invalid-address')
    ).rejects.toThrow();
  });
});
```

## 🚀 部署和运维

### Docker部署
```dockerfile
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci --only=production

COPY src/ ./src/
COPY tsconfig.json ./

RUN npm run build

EXPOSE 3000

USER node

CMD ["node", "dist/server.js"]
```

### 环境配置
```typescript
import dotenv from 'dotenv';

dotenv.config();

export const config = {
  solana: {
    rpcUrl: process.env.SOLANA_RPC_URL || 'https://api.mainnet-beta.solana.com',
    commitment: process.env.SOLANA_COMMITMENT || 'confirmed'
  },
  server: {
    port: parseInt(process.env.PORT || '3000'),
    host: process.env.HOST || 'localhost'
  },
  security: {
    apiKeys: process.env.API_KEYS?.split(',') || [],
    rateLimitRpm: parseInt(process.env.RATE_LIMIT_RPM || '100')
  },
  monitoring: {
    logLevel: process.env.LOG_LEVEL || 'info',
    metricsEnabled: process.env.METRICS_ENABLED === 'true'
  }
};
```

### 健康检查
```typescript
class HealthChecker {
  async checkSolanaConnection(): Promise<boolean> {
    try {
      const connection = new Connection(config.solana.rpcUrl);
      const slot = await connection.getSlot();
      return slot > 0;
    } catch {
      return false;
    }
  }

  async getHealthStatus() {
    return {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      checks: {
        solanaConnection: await this.checkSolanaConnection(),
        memoryUsage: process.memoryUsage(),
        uptime: process.uptime()
      }
    };
  }
}
```

## 📖 文档和示例

### API文档生成
```typescript
// 使用OpenAPI规范描述MCP服务器
const apiDoc = {
  openapi: '3.0.0',
  info: {
    title: 'Solana MCP Server',
    version: '1.0.0',
    description: 'Model Context Protocol server for Solana blockchain interactions'
  },
  paths: {
    '/tools/get_balance': {
      post: {
        summary: 'Get wallet balance',
        requestBody: {
          content: {
            'application/json': {
              schema: {
                type: 'object',
                properties: {
                  address: { type: 'string', description: 'Wallet address' }
                },
                required: ['address']
              }
            }
          }
        }
      }
    }
  }
};
```

### 使用示例
```typescript
// 客户端使用示例
import { McpClient } from '@modelcontextprotocol/client';

async function example() {
  const client = new McpClient('stdio', {
    command: 'node',
    args: ['dist/server.js']
  });

  await client.connect();

  // 列出可用工具
  const tools = await client.listTools();
  console.log('Available tools:', tools);

  // 调用余额查询工具
  const balance = await client.callTool('get_balance', {
    address: 'your-wallet-address'
  });
  
  console.log('Balance:', balance);

  await client.close();
}
```

## ⚠️ 注意事项和限制

### 安全警告
- MCP是新兴标准，安全机制仍在完善中
- 避免在MCP服务器中存储敏感信息
- 实施适当的访问控制和速率限制
- 定期审计和更新依赖项

### 性能考虑
- 实施合理的缓存策略
- 避免长时间阻塞操作
- 监控资源使用情况
- 设置适当的超时机制

### 开发建议
- 遵循MCP标准规范
- 编写充分的测试用例
- 提供清晰的错误消息
- 维护详细的文档
- 考虑向后兼容性