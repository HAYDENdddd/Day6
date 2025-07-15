// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BaseERC20 {
    string public name; 
    string public symbol; 
    uint8 public decimals; 

    uint256 public totalSupply; 

    mapping (address => uint256) balances; 
    mapping (address => mapping (address => uint256)) allowances; 

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        // 设置代币基础信息
        name = "BaseERC20";
        symbol = "BERC20";
        decimals = 18;

        // 设置总供应量为 100,000,000 * (10 ** decimals)
        totalSupply = 100_000_000 * (10 ** uint256(decimals));

        // 将所有 Token 分配给部署者
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balances[msg.sender] >= _value, "ERC20: transfer amount exceeds balance");

        // 扣除发送者余额，增加接收者余额
        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);  
        return true;   
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 currentAllowance = allowances[_from][msg.sender];

        require(balances[_from] >= _value, "ERC20: transfer amount exceeds balance");
        require(currentAllowance >= _value, "ERC20: transfer amount exceeds allowance");

        // 更新余额和授权额度
        balances[_from] -= _value;
        balances[_to] += _value;
        allowances[_from][msg.sender] = currentAllowance - _value;

        emit Transfer(_from, _to, _value); 
        return true; 
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowances[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value); 
        return true; 
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowances[_owner][_spender];
    }
}