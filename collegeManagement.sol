pragma solidity ^0.5.1;
//pragma experimental ABIEncoderV2;
contract SchoolManagement{
    address public owner;
    constructor() public{
        owner=msg.sender;
    }
    struct Student{
        string name;
        string class;
        uint age;
    }
    //string[] Name;
    // uint[] RollNo;
    // string[] Class;
    // uint[] Age;
    uint public count=1;
    modifier onlyOwner(){
        require(owner==msg.sender);
        _;
    }
    mapping(uint => Student) allStudent;
    
    function addStudent(uint rollNo, string memory name, string memory _sclass, uint _sage) public onlyOwner{
        Student memory newstudent = Student({name : name,
        class : _sclass,
        age : _sage});
        allStudent[rollNo]=newstudent;
        count++;
    }
    // function removeStudent(uint index) public onlyOwner{
    //     delete allStudent[index];
    // }
    function viewStudent(uint rollNo) external view returns (string memory,string memory,uint) {
        require(count>0);
        return (allStudent[rollNo].name,allStudent[rollNo].class,allStudent[rollNo].age);
    }
    
    