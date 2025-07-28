# ETHLossTrap 🔥  
**ETH Loss Trap — Drosera Trap by Sshadow84**

---

## 🧠 Objective

Создать рабочую Drosera-ловушку, которая:

- Отслеживает убыль ETH на целевом адресе,
- Использует стандартный интерфейс `collect()` / `shouldRespond()`,
- Срабатывает только при реальной потере ETH: когда уменьшение баланса превышает порог в процентах и абсолютной величине,
- Вызывает внешний контракт-обработчик с логом/оповещением.

---

## ⚠️ Problem

Многие DeFi-протоколы, DAO-кошельки и приватные сейфы могут быть подвержены взломам, ошибкам или неожиданным тратам. Простое изменение баланса — не всегда проблема, но падение баланса, особенно резкое, требует внимания.

**Решение**: Мониторим баланс по блокам, реагируем только если он уменьшился более чем на **1%** и минимум на **0.01 ETH**.

---

## 🧩 Trap Logic Summary

**Trap Contract**: `ETHLossTrap.sol`

```solidity
address public constant target = 0x6493...7498;
uint256 public constant thresholdPercent = 1;             // 1%
uint256 public constant minDiffWei = 0.01 ether;          // 0.01 ETH
```

📌 Ловушка сравнивает два значения баланса (`latest` и `previous`), и **реагирует только если**:
- Баланс уменьшился,
- Убыль составляет минимум 1%,
- И одновременно превышает 0.01 ETH в абсолюте.

---

## 📣 Response Contract: `LogAlertReceiver.sol`

```solidity
event AnomalyDetected(address indexed origin, string reason);
```

Контракт просто логгирует событие, содержащее сообщение с описанием аномалии, которое формирует ловушка (`"ETH loss: 25000000000000000 wei (2%)"`).

---

## ✅ What It Solves

- Игнорирует шум и колебания < 1%,
- Исключает срабатывание на первом запуске (`previous == 0`),
- Не реагирует на рост баланса или незначительные движения,
- Позволяет встроить в автоматические оповещения/реакции в DAO.

---

## 🚀 Deployment & Setup Instructions

### 1. Скомпилировать ловушку и обработчик

```bash
forge build
```

---

### 2. Задеплоить внешний обработчик `LogAlertReceiver`

```bash
forge create src/LogAlertReceiver.sol:LogAlertReceiver \
  --rpc-url https://ethereum-hoodi-rpc.publicnode.com \
  --private-key 0x...
```

Сохрани адрес из `Deployed to: 0x...` — он нужен далее.

---

### 3. Обновить `drosera.toml`

```toml
[traps.ethlosstrap]
path = "out/ETHLossTrap.sol/ETHLossTrap.json"
response_contract = "0xВаш_адрес_LogAlertReceiver"
response_function = "logAnomaly(string)"
block_sample_size = 10
private_trap = true
whitelist = ["0x6493...7498"]
address = "0xАдрес_ловушки_на_hoodi"
```

---

### 4. Применить изменения

```bash
DROSERA_PRIVATE_KEY=0x... drosera apply
```

---

### 5. Наблюдать за логами

```bash
journalctl -u drosera.service -f
```

---

## 🧪 How to Test the Trap

1. Отправь ETH с кошелька `0x6493...7498` → уменьшится баланс.
2. Убыль должна быть >0.01 ETH и >1% одновременно.
3. Жди 1–2 блока → ловушка сработает → будет вызван `logAnomaly(...)`.
4. В логах Drosera появится строка `shouldRespond=true`, и вызов response-функции.

---

## 🛠️ Extensions & Ideas

- Параметры `minDiffWei` и `thresholdPercent` через setter,
- Поддержка multi-token мониторинга (ERC-20),
- Возможность отправки уведомлений в Telegram/Discord/Webhook через внешнюю реакцию.

---

## 📅 Date & Author
🗓️ **First created**: July 28, 2025  
👤 **Author**: Sshadow84  
📬 **Telegram**: [@rudija](https://t.me/rudija)  
💬 **Discord**: sahamiess  
📦 **GitHub**: [github.com/Sshadow84](https://github.com/Sshadow84)
