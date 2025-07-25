💰 支持的交易所 & 返佣比例：\
  •  Binance（币安）\
✅ 永久次月返现：现货30%，合约30%\
🎁 新人福利：注册后合约首月返佣提升到 40%！\
🔗 注册链接：\
https://www.binance.com/register?ref=HAOGEGE 

  •  OKX（欧易）\
✅ 永久次月返现：手续费30%\
🔗 注册链接：\
https://okx.com/join/48790398 

  •  Bitget\
✅ 永久自动返现：手续费40%（注册后请提供 UID + 邮箱）\
🔗 注册链接：\
https://partner.bitget.com/bg/kk999 

•  Gate（芝麻开门）\
✅ 永久自动返现：手续费60%（注册后请提供 UID + 邮箱）\
🔗 注册链接：\
https://www.gateweb.xyz/share/YAYAGEGE

•  Bybit \
✅ 永久次月返现：手续费45% \
🔗 注册链接：\
https://partner.bybit.com/b/GEGE

  •  BackPack（红背包）\
✅ 全额自动返现：手续费10% \
https://backpack.exchange/join/ea253c99-dfd1-4fa3-ac28-ff6e1eafaf0b

--- 正在与商务对接中 --\
Kucoin: https://www.kucoin.com/r/rf/YPXT4P3Q (必须外国身份， 例如帕劳ID， 不可以大陆身份证或护照) 




### [Astro产品介绍](./README.md) 
### [Astro安装教程](./INSTALL.md) 
### [Astro安全相关-必读](./SECURITY.md) 

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
| Backpack | ✅   | ✅           |

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
1. **实时监控** - 实时监控多交易所全币种价差
2. **风险对冲** - 多空双向持仓规避单边风险
3. **跨平台支持** - 覆盖主流交易所现货/合约市场
