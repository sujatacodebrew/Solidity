pragma solidity ^0.5.1;
contract Campaign{
    enum campaignState{running ,cancelled , ended}
    campaignState public state;
    address payable public owner;
    uint public targetValue;
    uint public reachedValue;
    constructor(uint value) public{
        targetValue=value;
        state=campaignState.running;
        owner=msg.sender;
    }
    struct Product{
        uint value;
        string desciption;
        bool status;
        address payable vendor;
    }
    Product[] allProduct;
    mapping(address => uint) pendingReturns;
    function cancelCampaign() public{
        require(owner==msg.sender);
        state=campaignState.cancelled;
    }
    function pledge() payable public{
        uint value=msg.value;
        reachedValue=reachedValue+value;
    }
    function createPorduct(uint _value, string memory _desciption) public{
        require(msg.sender==owner);
        Product memory newproduct = Product({value : _value,
        desciption : _desciption,
        status : false,
        vendor : msg.sender});
        allProduct.push(newproduct);
    }
    function withdraw() payable public{
        require(state==campaignState.cancelled);
        uint amount=pendingReturns[msg.sender];
        require(amount>0);
        msg.sender.transfer(amount);
        pendingReturns[msg.sender]=0;
    }
    function productDescription(uint i) public returns(uint,address,string memory){
        require(msg.sender==owner);
        return(allProduct[i].value,allProduct[i].vendor,allProduct[i].desciption);
    }
    function buyProduct(uint i) public{
        require(msg.sender==owner);
        require(allProduct[i].status==false);
        require(allProduct[i].value<address(this).balance);
        allProduct[i].vendor.transfer(allProduct[i].value);
        allProduct[i].status==true;
        
    }
    function closecampaign() public{
        require(reachedValue>=targetValue);
        require(msg.sender==owner);
        state=campaignState.ended;
    }
    function contractMoney() payable public{
        msg.sender.transfer(address(this).balance);
    }
}