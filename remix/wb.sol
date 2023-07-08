// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IWRC20.sol";


contract WRC20 is IWRC20 {
    uint totalTokens;
    address owner;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowances;
    string _name;
    string _symbol;


    function name() external view returns(string memory) {
        return _name;
    }


    function symbol() external view returns(string memory) {
        return _symbol;
    }


    function decimals() external pure returns(uint) {
        return 18;
    }


    function totalSupply() external view returns(uint) {
        return totalTokens;
    }


    modifier enoughTokens(address _from, uint _amount) {
        require(balanceOf(_from) >= _amount, "not enough tokens!");
        _;
    }


    modifier onlyOwner() {
        require(msg.sender == owner, "not an owner!");
        _;
    }


    constructor(string memory name_, string memory symbol_, uint initialSupply) {
        _name = name_;
        _symbol = symbol_;
        owner = msg.sender;
        mint(initialSupply, msg.sender);
    }


    function balanceOf(address account) public view returns(uint) {
        return balances[account];
    }


    function transfer(address to, uint amount) external enoughTokens(msg.sender, amount) {
        _beforeTokenTransfer(msg.sender, to, amount);
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transfer(msg.sender, to, amount);
    }



    function mint(uint amount, address mint_to) public onlyOwner {
        _beforeTokenTransfer(address(0), mint_to, amount);
        balances[mint_to] += amount;
        totalTokens += amount;
        emit Transfer(address(0), mint_to, amount);
    }


    function burn(address _from, uint amount) public onlyOwner {
        _beforeTokenTransfer(_from, address(0), amount);
        balances[_from] -= amount;
        totalTokens -= amount;
    }



    function allowance(address _owner, address spender) public view returns(uint) {
        return allowances[_owner][spender];
    }



    function approve(address spender, uint amount) public {
        _approve(msg.sender, spender, amount);
    }



    function _approve(address sender, address spender, uint amount) internal virtual {
        allowances[sender][spender] = amount;
        emit Approve(sender, spender, amount);
    }


    function transferFrom(address sender, address recipient, uint amount) public enoughTokens(sender, amount) {
        _beforeTokenTransfer(sender, recipient, amount);


        require(allowances[sender][msg.sender] >= amount, "check allowance!");
        allowances[sender][msg.sender] -= amount;


        balances[sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }


    function _beforeTokenTransfer(
        address from,
        address to,
        uint amount
    ) internal virtual {}
}



contract TestToken is WRC20 {
    constructor(address owner) WRC20("sychonix", "SYNX", 1000000*10**18) {}
}
