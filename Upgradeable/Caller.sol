pragma solidity >=0.4.22 <0.7.0;
import "./Target.sol";

contract Caller {
    
    uint public _value;
    
    address public user;
    
    function setValue(address addr) public returns(uint) {
        Target c = Target(addr);
        c.setValue(100);
    }
    
    function getValue(address addr) public returns(uint) {
        Target c = Target(addr);
        return c.getValue();
    }
    
    function someUnsafeAction(address addr) {
        addr.call(bytes4(keccak256("setValue(uint256)")), 100);
    }
    
    function someActionDelegate(address addr) {
        addr.delegatecall(bytes4(keccak256("setValue(uint256)")), 100);
    }
    
}