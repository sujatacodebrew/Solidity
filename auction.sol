pragma solidity ^0.5.1;
contract Auction_product{
    enum AuctionState{running ,cancelled , ended}
    AuctionState public state;
    address payable owner;
    uint public startingPrice=1;
    uint public highestBid;
    address payable highestBidder;
    string public productName="Oppo realme 1";
    string public productDescription="Model = CPH1859, ColorOS Version = v5.2, Android Version = 8.1.0, Processor = Octa Core, RAM = 6.00GB, Device Storage = 128GB";
    
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    mapping(address => uint) pendingReturns;
    
    constructor() public{
        state=AuctionState.running;
        owner=msg.sender;
    }
    
    
    
    function bid() public payable{
        require(state == AuctionState.running, "Auction closed/cancelled");
        require(msg.sender!=owner,"Owner can't buy this product");
        uint temp= pendingReturns[msg.sender]+msg.value;
        require(temp>=startingPrice && temp>highestBid);
        highestBid=temp;
        highestBidder=msg.sender;
        pendingReturns[msg.sender] = temp;
        emit HighestBidIncreased(msg.sender, temp);
    }
    
    
    
    function withdraw() public {
        uint amount = pendingReturns[msg.sender];
        require(amount > 0);
        if (state == AuctionState.cancelled) {
            msg.sender.transfer(amount);
        } else {
            require(msg.sender != highestBidder);
            msg.sender.transfer(amount);
        }
        pendingReturns[msg.sender] = 0;

    }
     function auctionEnd() public {
         require(msg.sender == owner);
         require(state==AuctionState.running);
        address(owner).transfer(highestBid);
        emit AuctionEnded(highestBidder, highestBid);
        state=AuctionState.ended;
    }
    function auctionCancel() public{
        require(msg.sender == owner);
        state=AuctionState.cancelled;
    }
}