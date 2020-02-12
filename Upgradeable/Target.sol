pragma solidity >=0.4.22 <0.7.0;

contract Target {

uint public _value;
address public user;

function getValue() public view returns (uint) {
    return _value;
}

function setValue(uint value) public {
    _value = value;
    user = msg.sender;
}

}