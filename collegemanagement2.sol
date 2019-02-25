pragma solidity ^0.5.1;
pragma experimental ABIEncoderV2;
contract SchoolManagement{
    address public owner;
    constructor() public{
        owner=msg.sender;
    }
    struct Student{
        string name;
        uint rollNo;
        string class;
        uint age;
    }
    string[] Name;
    // uint[] RollNo;
    // string[] Class;
    // uint[] Age;
    uint public count=0;
    modifier onlyOwner(){
        require(owner==msg.sender);
        _;
    }
    mapping(uint => Student) allStudent;
    function addStudent(string memory _sname, uint _srollNo, string memory _sclass, uint _sage) public onlyOwner{
        Student memory newstudent = Student({name : _sname,
        rollNo : _srollNo,
        class : _sclass,
        age : _sage});
        allStudent[count]=newstudent;
        count++;
    }
    // function removeStudent(uint index) public onlyOwner{
    //     delete allStudent[index];
    // }
    function viewStudent(uint index) external view returns(Student memory){
        require(index<=count);
        return(allStudent[index]);
    }
     function viewAllStudent() public view returns (Student memory){
         uint i;
         for(i=0; i<=count; i++){
            viewall(i);
         }
     }
     function viewall(uint index) private view returns(Student memory){
         return(allStudent[index]);
     }
}