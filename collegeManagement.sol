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
    uint[] RollNo;
    string[] Class;
    uint[] Age;
    modifier onlyOwner(){
        require(owner==msg.sender);
        _;
    }
    Student[] allStudent;
    function addStudent(string memory _sname, uint _srollNo, string memory _sclass, uint _sage) public onlyOwner{
        Student memory newstudent = Student({name : _sname,
        rollNo : _srollNo,
        class : _sclass,
        age : _sage});
        allStudent.push(newstudent);
    }
    // function removeStudent(uint index) public onlyOwner{
    //     delete allStudent[index];
    // }
    function viewStudent(uint index) external view returns(Student memory){
        require(index<allStudent.length);
        return(allStudent[index]);
    }
    //  function viewAllStudent() public view returns (Name,uint[] memory,string[] memory,uint[] memory){
    //      uint i;
    //      for(i=0; i<allStudent.length; i++){
    //         name.push(allStudent[i].name);
    //      }
    //  }
}