pragma solidity 0.4.24;

interface ERC20Interface {
    
    function totalSupply() public view returns (uint);
    function balanceOf(address tokenOwner) public view returns (uint balance);
    function transfer(address to, uint tokens) public returns (bool success);
    
    function allowance(address tokenOwner, address spender) public view returns (uint);
    function approve(address spender, uint tokens) public returns (bool success);
    function transferFrom(address from, address to, uint tokens) public returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}


contract PareToken is ERC20Interface{
    
    string public name ="Pare";
    string public symbol = "PRT";
    uint public decimal = 0;
    
    uint public supply;
    address public founder;
    
    mapping(address => uint) public balances;
    mapping(address => mapping( address => uint)) allowed;
    //allowed[owner][sepender]= 100;
    
    constructor() public {
        supply = 1000;
        founder = msg.sender;
        balances[founder] = supply;
    }
    
    
    function totalSupply() public view returns (uint){
        return supply;
    }
    
     function balanceOf(address tokenOwner) public view returns (uint ){
         return balances[tokenOwner];
     }
     
     function transfer(address to, uint tokens) public returns (bool ){
         require(balances[msg.sender] >= tokens);
         
         balances[msg.sender] -= tokens;
         balances[to] += tokens;
         
          emit Transfer(msg.sender, to , tokens);
          
          return true;
     }
    
    function allowance(address tokenOwner, address spender) public view returns (uint){
        return allowed[tokenOwner][spender];
    }
    
    function approve(address spender, uint tokens) public returns (bool success){
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);
        
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
    }
    
    function transferFrom(address from, address to, uint tokens) public returns (bool success){
        require(allowed[from][to] >= tokens);
        require(balances[from] >= tokens);
        
        balances[from] -= tokens;
        balances[to] += tokens;
        
        allowed[from][to] -= tokens;
        
    }
    
}


//////////////////////////////////////////////////
//////////////////////////////////////////////////

contract PareICO is PareToken{
    address public admin;
    address public deposit;
    
    //token price in wei: 1PRT = 0.01 ETHER, 1 ETHER = 100 PRT
    uint tokenPrice = 1000000000000000;
    
    //500 Ether 
    uint public hardCap = 500000000000000000000;
    
    uint public raisedAmount;
    
    uint public saleStart = now;
    uint public saleEnd = now + 604800; 
    uint public coinTradeStart = saleEnd + 604800; 
    
    uint public maxInvestment = 5000000000000000000;
    uint public minInvestment = 10000000000000000;
    
    enum State { beforeStart, running, afterEnd, halted}
    State public icoState;
    
    
    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }
    
    event Invest(address investor, uint value, uint tokens);
    
    constructor(address _deposit) public{
        deposit = _deposit;
        admin = msg.sender;
        icoState = State.beforeStart;
    }
    
   
    function halt() public onlyAdmin{
        icoState = State.halted;
    }
    
    
    function unhalt() public onlyAdmin{
        icoState = State.running;
    }
    
    
    function getCurrentState() public view returns(State){
        if(icoState == State.halted){
            return State.halted;
        }else if(block.timestamp < saleStart){
            return State.beforeStart;
        }else if(block.timestamp >= saleStart && block.timestamp <= saleEnd){
            return State.running;
        }else{
            return State.afterEnd;
        }
    }
    
     
    function changeDepositAddress(address newDeposit) public onlyAdmin{
        deposit = newDeposit;
    }
    
    function invest() payable public returns(bool){
       
        icoState = getCurrentState();
        require(icoState == State.running);
        
        require(msg.value >= minInvestment && msg.value <= maxInvestment);
        
        uint tokens = msg.value / tokenPrice;
        
     
        require(raisedAmount + msg.value <= hardCap);
        
        raisedAmount += msg.value;
        
        
        balances[msg.sender] += tokens;
        balances[founder] -= tokens;
        
        deposit.transfer(msg.value);
        
       
        emit Invest(msg.sender, msg.value, tokens);
        
        return true;
        

    }
    
    
    function () payable public{
        invest();
    }
    
    
    function transfer(address to, uint value) public returns(bool){
        require(block.timestamp > coinTradeStart);
        super.transfer(to, value);
    }
    
    function transferFrom(address _from, address _to, uint _value) public returns(bool){
        require(block.timestamp > coinTradeStart);
        super.transferFrom(_from, _to, _value);
    }
    
    
    function burn() public returns(bool){
        icoState = getCurrentState();
        require(icoState == State.afterEnd);
        balances[founder] = 0;
        
    }
    
    
    
    
}
