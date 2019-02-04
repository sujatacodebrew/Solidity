pragma solidity ^0.5.1;
contract Bank{
    
    address owner;
    uint count;
    mapping(address => uint) customers;
    
    constructor() payable public{
        require(msg.value>=0.3 ether);
        owner=msg.sender;
    }
     
    function enroll() public{
        require(owner!=msg.sender,"Owner is not eligible for this");
        if(count<3) {
            count++;
            customers[msg.sender] = 0.1 ether;
        }
    }
    
    function withdraw(uint _value) public{
        uint value = _value;
        require(value < address(this).balance && customers[msg.sender] >= value && value > 0);
        customers[msg.sender] -=  value;
        msg.sender.transfer(value);
    }
    
    function deposit() payable public{
        customers[msg.sender]=customers[msg.sender] + msg.value;
    }
    
    function balance() view public returns(uint){
        return customers[msg.sender];
    }
    
    function bankBalance() view public returns(uint){
        require(msg.sender==owner);
        return address(this).balance;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
    
    function etherContractToOwner() public onlyOwner{
        msg.sender.transfer(address(this).balance);
    }
}
