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

