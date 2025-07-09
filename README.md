注册交易所欢迎走我的链接（将来一定送VIP会员）
Binance: https://www.binance.com/activity/referral-entry/CPA?ref=CPA_0043HZONXK
Bybit: https://www.bybitglobal.com/invite?ref=YP9ANE0
Bitget: https://partner.niftah.cn/bg/JSSRMT
OKX: https://www.ouxyi.io/ul/6CngT5?channelId=93279825
Gate: https://www.gate.com/signup/VGJBVVKJAW?ref_type=103
Kucoin: https://www.kucoin.com/r/rf/YPXT4P3Q (必须外国身份， 不可以大陆身份证或护照)

#### [Astro产品介绍](./README.md) 
#### [Astro安装教程](./INSTALL.md) 
#### [Astro安全相关-必读](./SECURITY.md) 

套利策略，产品使用群 \
https://t.me/astro_discuss

行情工具 \
https://pulse.astro-btc.xyz/ \
https://astro-btc.github.io/Astro-Perps/?coin=ETH

实时资讯, 上新，费率调整等 \
https://t.me/astro_realtime_news

--------------------------------

# Astro - 产品介绍

Astro 是一款基于多空对冲策略的**中心化交易所（CEX）套利工具**，支持：
-  🟩 🟨 现货-期货，同币种，风险低
-  🟨 🟨 期货-期货，同币种，风险低
-  🟩 🟪 现货-期货，跨币种，例如BTC-BNB， 赌币对汇率变化， 风险大
-  🟨 🟪 期货-期货，跨币种，例如BTC-BNB， 赌币对汇率变化， 风险大

### 已支持交易所清单
| 交易所   | 现货 | 期货（永续） |
|----------|------|--------------|
| Bybit    | ✅   | ✅           |
| Bitget   | ✅   | ✅           |
| Binance  | ✅   | ✅           |
| Kucoin   | ✅   | ✅           |
| Gate     | ✅   | ✅           |
| OKX      | ✅   | ✅           |
| Aster    | ❌   | ✅           |

---

## 套利原理
### 现货-期货对冲案例
假设代币`A`存在价差：
- Binance **现货价**：0.98 USDT
- OKX **合约价**：1.00 USDT

**操作流程**：
1. **开仓**  
   - Binance现货买入 1000个 `A`（成本 980 USDT）
   - OKX开空单 1000个 `A`
   
2. **清仓-价差回归**（假设两边价格收敛至 0.88 USDT）  
   - Binance卖现货：880 USDT → **亏损 100 USDT**  
   - OKX平空单：盈利 (1.00 - 0.88) × 1000 = **120 USDT**  
   - **净盈利：20 USDT**

> **注**：实际需考虑手续费，资金费率、滑点等变量。期货-期货对冲逻辑相同。

---

## 开清价差计算
### 核心公式
价差百分比 = [2 × (Price_A - Price_B)] / (Price_A + Price_B) × 100%

### 案例演算
假设订单簿数据：
| 交易所  | 卖1价 | 买1价 |
|---------|-------|-------|
| Binance | 2256.0 | 2255.9 |
| OKX     | 2255.8 | 2255.7 |

**开仓价差计算**（OKX买1价 vs Binance卖1价）：
开仓差价 = [2 × (2255.7 - 2256.0)] / (2255.7 + 2256.0) × 100% = -0.0133%

**清仓价差计算**（OKX卖1价 vs Binance买1价）：
清仓差价 = [2 × (2255.8 - 2255.9)] / (2255.8 + 2255.9) × 100% = -0.0044%

### 验证规则
> ✅ **开仓价差**（-0.0133%）必须小于**清仓价差**（-0.0044%）  
> ❌ 若出现相反情况则表明计算错误

---

## 关键特性
1. **全自动套利** - 实时监控多交易所价差
2. **风险对冲** - 多空双向持仓规避单边风险
3. **跨平台支持** - 覆盖主流交易所现货/合约市场
4. **智能算法** - 自动计算最优开平仓点位
