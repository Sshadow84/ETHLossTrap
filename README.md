# ETHLossTrap 🔥  
**ETH Loss Trap — Drosera Trap by Sshadow84**

## 🧠 Objective

Создать рабочую Drosera-ловушку, которая:
- Отслеживает убыль ETH на целевом адресе,
- Использует collect() / shouldRespond() интерфейс,
- Срабатывает при снижении баланса более чем на 1% и более 0.01 ETH,
- Вызывает внешний логгер-обработчик через Drosera.

## 🧩 Trap Logic

Контракт ловушки `ETHLossTrap.sol` сравнивает баланс за два блока. 
Срабатывает только при убытке >= 1% **и** > 0.01 ETH.

## 📣 Обработчик: `LogAlertReceiver.sol`

При срабатывании ловушки вызывается `logAnomaly(string)` и логгирует событие.

## 🚀 Установка

1. `forge build`
2. Деплой обработчика:
```
forge create src/LogAlertReceiver.sol:LogAlertReceiver --rpc-url <RPC> --private-key <KEY>
```
3. Указать путь в `drosera.toml`:
```
path = "out/ETHLossTrap.sol/ETHLossTrap.json"
response_contract = "<адрес контракта>"
response_function = "logAnomaly(string)"
```
4. `DROSERA_PRIVATE_KEY=... drosera apply`
