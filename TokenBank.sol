// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract TokenBank {
    IERC20 public token; // ERC20 Token 合约引用

    // 每个地址的存款余额
    mapping(address => uint256) public balances;

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress); // ✅ 使用传入参数
    }

    function deposit(uint256 amount) external {
        require(amount > 0, "deposit amount must be > 0");

        bool success = token.transferFrom(msg.sender, address(this), amount);
        require(success, "deposit failed");

        balances[msg.sender] += amount;
    }

    function withdraw(uint256 amount) external {
        require(amount > 0, "withdraw amount must be > 0");
        require(balances[msg.sender] >= amount, "insufficient balance");

        balances[msg.sender] -= amount;

        bool success = token.transfer(msg.sender, amount);
        require(success, "withdraw failed");
    }
}