// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.28;

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract TokenManage is ERC20Upgradeable, OwnableUpgradeable {

    mapping(address => bool) blackList;
    mapping (address => bool) whiteList;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(string memory _name, string memory _symbol) public initializer {
        __ERC20_init(_name, _symbol);
        __Ownable_init();
    }

    function setBlackList(address[] memory _addresses) public onlyOwner {
        for (uint i = 0; i < _addresses.length; i++) {
            blackList[_addresses[i]] = true;
        }
    }

    function removeBlackList(address[] memory _addresses) public onlyOwner {
        for (uint i = 0; i < _addresses.length; i++) {
            blackList[_addresses[i]] = false;
        }
    }

    function setWhiteList(address[] memory _addresses) public onlyOwner {
        for (uint i = 0; i < _addresses.length; i++) {
            whiteList[_addresses[i]] = true;
        }
    }

    function removeWhiteList(address[] memory _addresses) public onlyOwner {
        for (uint i = 0; i < _addresses.length; i++) {
            whiteList[_addresses[i]] = false;
        }
    }

    function mint(address _to, uint256 _amount) public onlyOwner {
        _mint(_to, _amount);
    }

    function _transfer(address sender, address recipient, uint256 amount) internal override {
        require(blackList[sender] || blackList[recipient] == false, "Recipient or sender is in black list");
        super._transfer(sender, recipient, amount);
        emit Transfer(sender, recipient, amount);
    }
}