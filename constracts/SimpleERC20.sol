// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract SimpleERC20 {

    address owner;
    string public name;
    string public symbol;
    uint256 public totalSupply = 0;

    mapping(address => uint256) public balanceMapping;

    mapping(address => mapping(address => uint256)) public approveMapping;
    
    event  Approval(address from, address spender, uint256 amount) ;

    event  Transfer(address from, address to, uint256 amount) ;

    constructor(uint initNumber, string memory _name, string memory _symbol) {
           owner = msg.sender;
           name = _name;
           symbol = _symbol;

           totalSupply = initNumber;
           balanceMapping[owner] += initNumber;
    }

    // 铸币 only mint by owner of the contract
    function mint(uint256 value)public  returns(bool)  {
        require(msg.sender == owner,"mint must be owner of the contract!");
        totalSupply += value;
        balanceMapping[msg.sender] += value;
        return true;
    }

    // 查询余额
    function balanceOf(address _addr)public view returns(uint256){
        return balanceMapping[_addr];
    }

    // 授权approve
    function approve(address spender, uint256 value)public returns(bool) {
        require(spender != address(0), "spender not is empty");
        require(balanceMapping[msg.sender] >= value, "balance  is not enough!");
        //授权记录
        approveMapping[msg.sender][spender] = value;
        //owner授权还是消息发送者授权?
        emit Approval(msg.sender, spender, value);

        return true;
    }

    // 查看授权余额
    function allowance(address _addr) public view returns(uint256){
        require(_addr != address(0), "the address is error!");
        return approveMapping[msg.sender][_addr];
    }

    // transfer
    function transfer(address to, uint256 value)public returns(bool){
        require(to != address(0), "the address is error!");

        require(balanceMapping[msg.sender] >= value, "the balance is not enough!");

        balanceMapping[msg.sender] -= value;

        balanceMapping[to] += value;

        emit Transfer(msg.sender, to, value);

        return true;
    }

    // 转账
    function transferFrom(address from, address to , uint256 value)public returns(bool){
        require(from != address(0), "the from address is error!");
        require(to != address(0), "the to address is error!");
        //源账户账户余额是否充足
        require(balanceMapping[from] >= value, "the balance is not enough!");

        //授权余额是否充足
        require(approveMapping[from][msg.sender] >= value, "the balance is not enough!");

        balanceMapping[from] -= value;

        balanceMapping[to] += value;
        approveMapping[from][msg.sender] -= value;

        emit Transfer(msg.sender, to, value);

        return true;
    }






}

