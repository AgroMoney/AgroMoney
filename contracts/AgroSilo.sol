// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";


contract AgroSilo is ERC20("AgroSilo", "xAGRO"){
    using SafeMath for uint256;
    IERC20 public agro;

    constructor(IERC20 _agro) public {
        agro = _agro;
    }

    // Enter the bar. Pay some AGROs. Earn some shares.
    function enter(uint256 _amount) public {
        uint256 totalAgro = agro.balanceOf(address(this));
        uint256 totalShares = totalSupply();
        if (totalShares == 0 || totalAgro == 0) {
            _mint(msg.sender, _amount);
        } else {
            uint256 what = _amount.mul(totalShares).div(totalAgro);
            _mint(msg.sender, what);
        }
        agro.transferFrom(msg.sender, address(this), _amount);
    }

    // Leave the bar. Claim back your AGROs.
    function leave(uint256 _share) public {
        uint256 totalShares = totalSupply();
        uint256 what = _share.mul(agro.balanceOf(address(this))).div(totalShares);
        _burn(msg.sender, _share);
        agro.transfer(msg.sender, what);
    }
}