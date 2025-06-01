// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FixedDepositBank {
    address public owner;
    uint256 public annualInterestRate; // in basis points (e.g., 500 = 5%)

    struct Deposit {
        uint256 amount;
        uint256 startTime;
        uint256 maturityTime;
        bool withdrawn;
    }

    mapping(address => Deposit[]) public deposits;

    event Deposited(address indexed user, uint256 indexed depositId, uint256 amount, uint256 maturity);
    event Withdrawn(address indexed user, uint256 indexed depositId, uint256 payout, bool early);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(uint256 _annualInterestRate) {
        owner = msg.sender;
        annualInterestRate = _annualInterestRate; // 500 = 5%
    }

    function deposit(uint256 durationInDays) external payable {
        require(msg.value > 0, "Must deposit ETH");
        require(durationInDays >= 30, "Minimum term: 30 days");

        uint256 maturity = block.timestamp + (durationInDays * 1 days);

        deposits[msg.sender].push(Deposit({
            amount: msg.value,
            startTime: block.timestamp,
            maturityTime: maturity,
            withdrawn: false
        }));

        emit Deposited(msg.sender, deposits[msg.sender].length - 1, msg.value, maturity);
    }

    function withdraw(uint256 depositId) external {
        require(depositId < deposits[msg.sender].length, "Invalid depositId");

        Deposit storage userDeposit = deposits[msg.sender][depositId];
        require(!userDeposit.withdrawn, "Already withdrawn");

        userDeposit.withdrawn = true;
        uint256 payout;
        bool early = block.timestamp < userDeposit.maturityTime;

        if (early) {
            // 50% of accrued interest is forfeited
            payout = userDeposit.amount + _calculateInterest(userDeposit, true);
        } else {
            payout = userDeposit.amount + _calculateInterest(userDeposit, false);
        }

        payable(msg.sender).transfer(payout);
        emit Withdrawn(msg.sender, depositId, payout, early);
    }

    function _calculateInterest(Deposit memory d, bool early) internal view returns (uint256) {
        uint256 timeElapsed = block.timestamp > d.maturityTime ? d.maturityTime - d.startTime : block.timestamp - d.startTime;
        uint256 interest = (d.amount * annualInterestRate * timeElapsed) / (365 days * 10000); // basis points
        return early ? interest / 2 : interest;
    }

    function getDeposits(address user) external view returns (Deposit[] memory) {
        return deposits[user];
    }

    function updateInterestRate(uint256 newRate) external onlyOwner {
        annualInterestRate = newRate;
    }

    // Fallback to accept ETH
    receive() external payable {}
}
