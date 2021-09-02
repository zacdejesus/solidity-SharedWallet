pragma solidity ^0.8.0;

import "./Allowance.sol";

contract SharedWallet is Allowance {
    event MoneySent(address indexed _beneficiary, uint _amount);
    event MoneyReceived(address indexed _from, uint _amount);
    
    // The onlyOwner modifier is in the openZeppelin repo.
    function renounceOwnership() public view override(Ownable) onlyOwner {
        revert("can't renounceOwnership here"); //not possible with this smart contract
    }
    
    // Here we get the balance from the smartcontrat
    function getBalace() public view returns(uint) {
        return address(this).balance;
    }
    
    // A function to deposit
    function deposit() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
    
    function withdrawAllFunds(address payable _to) public {
        require(isOwner(), "you are not allowed or not enough funds");
        emit MoneySent(_to, getBalace());
        _to.transfer(getBalace());
    }
    
    function withdrawFunds(address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= getBalace(), "this smartcontrat doesnt have enough balance");
        if (!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }
} 