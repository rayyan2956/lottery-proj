pragma solidity ^0.8.0;
contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor () {
        manager=msg.sender;
    }

    receive() external payable { 
        participants.push(payable(msg.sender));
    }

    function getBalance() public view returns (uint){
        require(msg.sender==manager);
        return address(this).balance;
    }
    function random() public view returns (uint){
        return uint(keccak256(abi.encodePacked(block.prevrandao, block.timestamp, participants.length)));

    }

    function selectWinner() public {
        require(msg.sender==manager);
        require(participants.length>=3);

        uint r = random();
        uint index = r%participants.length;
        address payable winner = participants[index];
        uint balance = getBalance();

        uint managerFee = balance / 10; // 10% commission
        uint winnerPrize = balance - managerFee;

        winner.transfer(winnerPrize);

        payable(manager).transfer(managerFee);
        participants= new address payable[](0);
      
    }
}