pragma solidity ^0.5.1;
contract lottery{
    string name;
    address public owner;
    constructor() public{
        owner=msg.sender;
    }
    mapping(address=>uint256) winnings;
    address payable[] tickets;
    uint256 maxTickets=10;
    uint256 public remainingTickets=10;
    uint256 public ticketcount=0;
    uint256 randomNum=0;
    address payable public winner;
    
    function buy() public payable{
        require(ticketcount<maxTickets,"1");
        require(msg.value==1 ether,"2");
        //require(msg.sender.balance>=msg.value,"3");
        //require(remainingTickets-1<remainingTickets,"4");
        //msg.sender.transfer(msg.value);
        remainingTickets-=1;
        tickets.push(msg.sender);
        ticketcount++;
    }
    function getwinner() public payable{
        require(ticketcount>0,"5");
        randomNum=uint(blockhash(block.number-1))%ticketcount;
        winner=tickets[randomNum];
        winnings[winner]=ticketcount; 
        address(winner).transfer(address(this).balance);
        ticketcount=0;
        remainingTickets = maxTickets;
        delete tickets;
        
        
    }
}