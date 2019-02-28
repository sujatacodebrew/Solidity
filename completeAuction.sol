pragma solidity ^0.5.1; 

contract Auction_product{
    enum AuctionState{running ,cancelled , ended}
    AuctionState public state;
    
    address payable owner;
    uint public startingPrice=1 wei;
    uint public highestBid;
    address payable highestBidder;
    uint8 countOfProduct;
    mapping(address => uint) pendingReturns;
    
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);
    uint public count;
    
    
    struct Product{
        uint8 id;
        string name;
        address payable vendor;
        uint price;
        bool complete;
        uint approvalCount;
    }
    Product[] allProduct;
    
    constructor() public{
        state=AuctionState.running;
        owner=msg.sender;
    }
    
    modifier onlyOwner(){
        require(msg.sender== owner);
        _;
    }
    
     function addProduct(string memory _name, uint _price,address payable _vendor) public onlyOwner{
        Product memory newproduct = Product({
            id : countOfProduct,
            name : _name,
            vendor : _vendor,
            price : _price,
            complete: true,
            approvalCount: 0
        });
        allProduct.push(newproduct);
        countOfProduct++;
    }
    
    mapping(address => bool) bidders;
    
    function bid() public payable{
        require(state == AuctionState.running, "Auction closed/cancelled");
        require(msg.sender!=owner,"Owner can't buy this product");
        uint temp= pendingReturns[msg.sender]+msg.value;
        require(temp>=startingPrice && temp>highestBid);
        highestBid=temp;
        highestBidder=msg.sender;
        pendingReturns[msg.sender] = temp;
        emit HighestBidIncreased(msg.sender, temp);
        bidders[msg.sender]=true;
        count++;
    }
    
    function withdraw() external {
        uint returnAmount = pendingReturns[msg.sender];
        require(returnAmount > 0);
        if (state == AuctionState.cancelled || msg.sender != highestBidder) {
            safeWithdraw();
        }
        // else {
        //     require(msg.sender != highestBidder);
        //     safeWithdraw();
        // }
        pendingReturns[msg.sender] = 0;
    }
    
    function safeWithdraw() internal {
        uint returnAmount = pendingReturns[msg.sender];
        msg.sender.transfer(returnAmount);
    }
    
    function auctionEnd() public {
        require(msg.sender == owner);
        require(state==AuctionState.running);
        safeauctionEnd();
        emit AuctionEnded(highestBidder, highestBid);
        state=AuctionState.ended;
    }
    
    function safeauctionEnd() internal{
        address(owner).transfer(highestBid);
    }
    
    function auctionCancel() public{
        require(msg.sender == owner);
        state=AuctionState.cancelled;
    }
    mapping(address => mapping(uint8 => bool)) checkBidder;
    
    function approve( uint8 id) public{
        require(bidders[msg.sender]==true);
        require(checkBidder[msg.sender][id]==false);
        allProduct[id].approvalCount++;
        allProduct[id].complete = true;
        checkBidder[msg.sender][id] = true;
    }
    
    modifier approveBuy(uint8 id){
        require(msg.sender==owner);
        require(allProduct[id].approvalCount > (count/2));
        require(msg.value >= allProduct[id].price);
        _;
    }
    
    function buy(uint8 id) public payable approveBuy(id){
        address(allProduct[id].vendor).transfer(msg.value);
    }
    
    // function approveBuy(uint8 id) public onlyOwner{
    //     require(allProduct[id].approvalCount > (count/2));
    //     buy(id);
    // }
    
}