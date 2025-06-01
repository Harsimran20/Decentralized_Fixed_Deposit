# FixedDepositProtocol

A **decentralized smart contract system** that enables users to create fixed-term ETH deposits and earn interest over time. Inspired by traditional banking certificates of deposit (CDs), this protocol allows secure time-locked ETH savings with transparent, on-chain interest accrual and early withdrawal penalties.

---

## 🚀 Features

- 📥 **Fixed-Term Deposits**: Lock ETH for a specified duration and earn interest.
- 💸 **Interest Accrual**: Annual interest rate calculated and compounded in real time.
- 🔓 **Early Withdrawal Option**: Withdraw before maturity with partial interest forfeiture.
- 🔐 **Non-custodial**: Funds are stored in a secure smart contract—no intermediaries.
- 🔄 **Owner-Controlled Rate**: Contract owner can update annual interest rates.

---

## 🧠 Use Case

Ideal for:
- DeFi users seeking low-risk, yield-generating savings.
- DAOs offering on-chain time-locked incentives.
- Developers building decentralized banking services.

---

## 🛠️ Smart Contract Overview

### Contract: `FixedDepositBank.sol`

function deposit(uint256 durationInDays) external payable
Users deposit ETH with a fixed term (minimum: 30 days).

function withdraw(uint256 depositId) external
Users withdraw after maturity or earlier (with reduced interest).

function getDeposits(address user) external view returns (Deposit[] memory)
Returns all deposits for a given user.

function updateInterestRate(uint256 newRate) external onlyOwner
Allows the contract owner to adjust the interest rate (in basis points).

🧪 Requirements
Solidity ^0.8.0
Remix IDE

🔧 Installation & Deployment

git clone \repository
cd FixedDepositProtocol

✅ Test Cases
Test suite covers:

Valid ETH deposit with term

Withdrawal before and after maturity

Interest calculation

Rate updates by contract owner

🔐 Security Notes
No reentrancy: Follows checks-effects-interactions pattern.

Interest calculations use basis points to avoid precision issues.

Owner control limited to interest rate changes only.
