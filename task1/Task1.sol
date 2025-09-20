// SPDX-Lisence-Identifier: MIT
pragma solidity ^0.8.0;

contract Task1 {
    //1.1一个mapping来存储候选人的得票数
    mapping(address => uint256) public voteMapping;
    //投票地址数组
    address[] public keys;

    // 罗马数字到整数的映射表
    mapping(bytes1 => uint256) private romanValues;

    // 整数到罗马数字的结构体
    struct RomanNumeral {
        uint256 value;
        string symbol;
    }
    // 整数到罗马数字的结构体
    RomanNumeral[] private numerals;

//构造函数
    constructor(){

        // 初始化罗马数字对应值
        romanValues['I'] = 1;
        romanValues['V'] = 5;
        romanValues['X'] = 10;
        romanValues['L'] = 50;
        romanValues['C'] = 100;
        romanValues['D'] = 500;
        romanValues['M'] = 1000;

        
        // 按数值降序初始化罗马数字符号表
        numerals.push(RomanNumeral(1000, "M"));
        numerals.push(RomanNumeral(900, "CM"));
        numerals.push(RomanNumeral(500, "D"));
        numerals.push(RomanNumeral(400, "CD"));
        numerals.push(RomanNumeral(100, "C"));
        numerals.push(RomanNumeral(90, "XC"));
        numerals.push(RomanNumeral(50, "L"));
        numerals.push(RomanNumeral(40, "XL"));
        numerals.push(RomanNumeral(10, "X"));
        numerals.push(RomanNumeral(9, "IX"));
        numerals.push(RomanNumeral(5, "V"));
        numerals.push(RomanNumeral(4, "IV"));
        numerals.push(RomanNumeral(1, "I"));

    }

        //1.2一个vote函数，允许用户投票给某个候选人
        function vote(address _voter) public {
            voteMapping[_voter]++;
        
            keys.push(_voter);
        }
        //1.3一个getVotes函数，返回某个候选人的得票数
        function getVotes(address _voter) public view returns(uint256) {
            return voteMapping[_voter];
        }

    //1.4一个resetVotes函数，重置所有候选人的得票数
        function resetVotes()public  {
        
            for (uint i = 0; i< keys.length; i ++ ){
                delete voteMapping[keys[i]];
            }
        }
    

    // 2.反转一个字符串。输入 "abcde"，输出 "edcba"
    function reverseString(string memory _str) public pure returns(string memory) {
        bytes memory strBytes = bytes(_str);
        
        uint length = strBytes.length;
        bytes memory strNew = new bytes(length);
        for (uint i=0; i < length; i++) {
            strNew[length-i-1] = strBytes[i];
        }
        return string(strNew);
    }

    // 3.罗马数字转整数
    function lmStrToUint(string memory _lmStr) public view   returns(uint256){

            
        //先转为字节    
        bytes memory lmBytes = bytes(_lmStr);
        //总数
        uint256 total = 0;
        // 上一个值
        uint256 preNum = 0;
        for(uint256 i= lmBytes.length; i > 0 ; i-- ){
            //获取当前字符的值
            uint256 currentNum = romanValues[lmBytes[i-1]];

            //如果当前值小于上一个值，则相减，否则相加
            if(currentNum < preNum){
                total -= currentNum;
            }else{
                total += currentNum;
            }
            preNum = currentNum;

        }
        //返回最后总数
        return total;

    }

    // 4.整数转罗马数字
    function uintTolmStr(uint num)public view returns(string memory){
        //校验数字范围
        require(num > 0 && num < 4000, "must be uint type!");
        //临时存放罗马数字字节
        bytes memory romanBbytes ;


        // 遍历罗马结构体数组，判断传参数字是否大于当前这个罗马数字结构体，如果大于等于则减去罗马数字对应的数字，同时拼接罗马数字；否则进入下一轮罗马数字遍历。
        for(uint256 i=0; i< numerals.length; i++){

            while(num >= numerals[i].value){
                romanBbytes = abi.encodePacked(romanBbytes, numerals[i].symbol);
                num -= numerals[i].value;
            }
        
        }

        // 返回最终的罗马数字字符串
        return string(romanBbytes);


    }


    // 5. 将两个有序数组合并为一个有序数组。
    function mergeTwoArrSorted(uint[] memory arr1, uint[] memory arr2)
        public 
        pure 
        returns(uint[] memory){
            //数组1的长度
            uint256 len1 = arr1.length;
            //数组2的长度
            uint256 len2 = arr2.length;
            //合并后的数组
            uint[] memory mergedArr = new uint[](len1+len2);

            //数组1的索引值
            uint256 i = 0;
            //数组2的索引值
            uint256 j = 0;
            //数组1的索引值
            uint256 k = 0;

            //双指针遍历比较，按照顺序排列合并
            while(i<len1 && j<len2){
                //依次拿出两个数组的元素对比，哪个小放哪个到合并数组中。
                if(arr1[i]<arr2[j]){
                    mergedArr[k] = arr1[i];
                    i++;
                }else{
                    mergedArr[k] = arr2[j];
                    j++;
                }
                k++;
            }




            // 处理1数组剩余元素合并
            while(i<len1){
                mergedArr[k] = arr1[i];
                i++;
                k++;
            }
            

            // 处理2数组剩余元素合并
            while(j<len2){
                mergedArr[k] = arr2[j];
                j++;
                k++;
            }

            // 返回合并后的数组
            return mergedArr;

    }

    // 6. 在一个有序数组中查找目标值。
    function searchTargetBySortedArr(uint[] memory arr, uint target)
        public 
        pure 
        returns(uint){
            //左侧索引下标，初始的时候为0，然后比较中位值，如果小于目标值则左侧索引下标右移动到中位缩小一半范围。
            uint256 left = 0;
            //右侧索引下标，初始的时候为数组长度，然后比较中位值，如果大于目标值则右侧索引下标左移动到中位缩小一半范围。
            uint256 right = arr.length;

            require(arr[left]<=target && target<= arr[right],"target not is range!");

            // wihle循环遍历
            while(left<right){
                //中位值
                uint mid = left + (right-left)/2;
                if(arr[mid] == target){
                    return mid;
                }else if(arr[mid] < target){
                    left = mid +1;
                }else{
                    right = mid;
                }
            }
            
            return type(uint).max;

    }


    
}