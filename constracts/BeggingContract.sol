// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract BeggingContract {

    address public owner;
    string public name;
    string public symbol;
    uint256 public totalSupply = 0;

    //一个 mapping 来记录每个捐赠者的捐赠金额。
    mapping(address => uint256) public donateMapping;

    //1.捐赠事件：添加 Donation 事件，记录每次捐赠的地址和金额。
    event Donation(address addr, uint256 amount);

    //2.捐赠排行榜：实现一个功能，显示捐赠金额最多的前 3 个地址。
    DonateStruct[3] public donateStructArr;

    struct DonateStruct{
        address addr;
        uint256 amount;
    }

    //3.时间限制：添加一个时间限制，只有在特定时间段内才能捐赠。
    //解析：需要设定一个时间范围，这里使用的是秒，
    uint256 public deployTimestamp;
    uint256 public timeLimit; //时间限制，单位秒


    constructor(uint256 second) {
           owner = msg.sender;
           name = "donateMyToken";
           symbol = "MTK";
           timeLimit = second;
           deployTimestamp = block.timestamp;

          // 初始化排行榜
        for (uint256 i = 0; i < 3; i++) {
            donateStructArr[i] = DonateStruct(address(0), 0);
        }
    }


    //一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
    function donate()public payable returns(bool)  {
        require(msg.value > 0, "the value must greate than zero!");
        // 查看是否在允许捐赠时间内
        require(block.timestamp < (deployTimestamp + timeLimit), "donate time expired");

        totalSupply += msg.value;
        //记录发送金额
        donateMapping[msg.sender] += msg.value;
        //跟新榜三
        updateTopList(msg.sender, donateMapping[msg.sender]);

        //记录捐赠事件
        emit Donation(msg.sender, msg.value);

        return true;
    }

    //一个 withdraw 函数，允许合约所有者提取所有资金。
    function withdraw()public payable returns(bool){
        require(msg.sender == owner, "only withdraw by the owner!");
        // 总数归零
        totalSupply = 0;
        //从合约里面提现
        payable(owner).transfer(address(this).balance);
        return true;
    }

    // 一个 getDonation 函数，允许查询某个地址的捐赠金额
    function getDonation(address _addr)public view returns(uint256){
        return donateMapping[_addr];
    }



    // 更新前三名
    function updateTopList(address _addr, uint256 _amount)public {

        // 如果存在当前地址，先删除
        for (uint256 i = 0; i < 3; i++) {
             if (_addr == donateStructArr[i].addr) {
                delete donateStructArr[i];
             }
        }

        
        // 检查是否应该进入排行榜
        for (uint256 i = 0; i < 3; i++) {
            if (_amount > donateStructArr[i].amount) {
                // 将后面的捐赠者向后移动
                for (uint256 j = 2; j > i; j--) {
                    donateStructArr[j] = donateStructArr[j - 1];
                }
                
                // 插入新的捐赠者
                donateStructArr[i] = DonateStruct({
                    addr: _addr,
                    amount: _amount
                });
                break;
            }
        }

    }

    function getTop3()public view returns(address[3] memory){
            uint256[3] memory amountTop3 ;
            address[3] memory addressTop3;
            for(uint8 i=0; i<3; i++){
                if(donateStructArr[i].amount ==0){
                    continue;
                }
                amountTop3[i] = donateStructArr[i].amount;
                addressTop3[i] = donateStructArr[i].addr;
                
            }
            return addressTop3;
    }



}

