// SPDX-License-Identifier: none
// Contract Address 0xF32abe0f6BfE98A0520b20F53863B8C52CF7be95
pragma solidity >=0.8.0;

interface IProjectSubmitContractCall {
    function receiveProjectData(string memory, string memory, string memory) external payable;
    function isProjectReceived() external view returns (bool);
}

contract StrikerDaysContract{
    uint16 public solidityStrikeDays;
    uint16 public englishStrikeDays;
    uint16 public fullStackStrikeDays;

    address public owner;

    event DaysIncreased(string subject, uint16 newValue);
    event DaysDecreased(string subject, uint16 newValue);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Fallback function to receive Ether
    receive() external payable {
        // Do something with the received Ether
    }

    // Explicit fallback function
    fallback() external payable {
        // Handle unexpected calls and payments
    }

    function increaseSol() external {
        solidityStrikeDays++;
        emit DaysIncreased("Solidity", solidityStrikeDays);
    }

    function decreaseSol() external {
        require(solidityStrikeDays >= 0, "Minimum is zero");
        solidityStrikeDays--;
        emit DaysDecreased("Solidity", solidityStrikeDays);
    }

    function increaseEng() external {
        englishStrikeDays++;
        emit DaysIncreased("English", englishStrikeDays);
    }

    function decreaseEng() external {
        require(englishStrikeDays >= 0, "Minimum is zero");
        englishStrikeDays--;
        emit DaysDecreased("English", englishStrikeDays);
    }

    function increaseFullStack() external {
        fullStackStrikeDays++;
        emit DaysIncreased("FullStack", fullStackStrikeDays);
    }

    function decreaseFullStack() external {
        require(fullStackStrikeDays > 0, "Minimum is zero");
        fullStackStrikeDays--;
        emit DaysDecreased("FullStack", fullStackStrikeDays);
    }

    function transferEther(address recipient, uint256 amount) external onlyOwner {
        payable(recipient).transfer(amount);
    }

    function sendEther(address payable recipient, uint256 amount) external onlyOwner {
        recipient.transfer(amount);
}

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
contract Math {
    function add(uint x, uint y) internal pure returns (uint z) {
        require((z = x + y) >= x);
    }
    function sub(uint x, uint y) internal pure returns (uint z) {
        require((z = x - y) <= x);
    }
}
contract ERC20 is Math, StrikerDaysContract {
    // --- ERC20 Data ---
    string  public constant name = "StrikerDays";
    string  public constant symbol = "SDT";
    uint8   public decimals = 18;
    uint256 public totalSupply;

    mapping (address => uint) public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

    event Approval(address indexed src, address indexed guy, uint wad);
    event Transfer(address indexed src, address indexed dst, uint wad);

    // --- Init ---
    constructor(uint _totalSupply) public {
        totalSupply = _totalSupply;
        balanceOf[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    // --- Token ---
    function transfer(address dst, uint wad) virtual public returns (bool) {
        return transferFrom(msg.sender, dst, wad);
    }
    function transferFrom(address src, address dst, uint wad) virtual public returns (bool) {
        require(balanceOf[src] >= wad, "insufficient-balance");
        if (src != msg.sender && allowance[src][msg.sender] != type(uint).max) {
            require(allowance[src][msg.sender] >= wad, "insufficient-allowance");
            allowance[src][msg.sender] = sub(allowance[src][msg.sender], wad);
        }
        balanceOf[src] = sub(balanceOf[src], wad);
        balanceOf[dst] = add(balanceOf[dst], wad);
        emit Transfer(src, dst, wad);
        return true;
    }
    function approve(address usr, uint wad) virtual public returns (bool) {
        allowance[msg.sender][usr] = wad;
        emit Approval(msg.sender, usr, wad);
        return true;
    }
     // submit finished project data for remote SC call
    // SC Address: 0x1298aFF3Bf44B87bfF03f864e09F2B86f91BE16F 
    function projectSubmitted(string memory _codeFileHash,string memory _topicName, string memory _authorName, address _sendHashTo) external payable onlyOwner{
        IProjectSubmitContractCall(_sendHashTo).receiveProjectData{value: msg.value, gas: 1000000}(_codeFileHash, _topicName, _authorName);
    }

    // get result if project submited to the remote SC
    function projectReceived()public view onlyOwner returns(bool){
        return  IProjectSubmitContractCall(0x1298aFF3Bf44B87bfF03f864e09F2B86f91BE16F).isProjectReceived();
    }
    
}





