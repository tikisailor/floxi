// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FraxFerryL1 is Ownable {
    IERC20 private _asset;
    address private _recipient;

    constructor(IERC20 asset_, address recipient_) 
        Ownable(msg.sender)
    {
        _asset = asset_;
        _recipient = recipient_;
    }

    event Disembark(uint start, uint end, bytes32 hash);

    function disembark() external onlyOwner {
        uint256 balance = _asset.balanceOf(address(this));
        require(balance > 0, "No balance to disembark");
        require(_asset.transfer(_recipient, balance), "Disembark transfer failed");

        emit Disembark(0, 0, keccak256(abi.encodePacked(block.number, _recipient, balance)));
    }

    function withdraw(uint amount) external onlyOwner {
        require(_asset.transfer(msg.sender, amount), "Withdrawal failed");
    }
}
