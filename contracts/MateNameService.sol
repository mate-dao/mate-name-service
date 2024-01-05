// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract MateNameService {
    address public mate = 0xE47E90C58F8336A2f24Bcd9bCB530e2e02E1E8ae;
    address public emate = 0x2B303fd0082E4B51e5A6C602F45545204bbbB4DC;
    address public bmate = 0xDeDd727ab86bce5D416F9163B2448860BbDE86d4;

    function checkMateHolder(address _addr) public view returns (bool isHolder) {
        return
            IERC721(mate).balanceOf(_addr) > 0 ||
            IERC721(emate).balanceOf(_addr) > 0 ||
            IERC721(bmate).balanceOf(_addr) > 0;
    }

    modifier onlyMateHolder() {
        require(checkMateHolder(msg.sender), "Only Mate Holder");
        _;
    }

    mapping(address => string) private _addressToName;
    mapping(string => address) private _nameToAddress;

    event NameChanged(address indexed _addr, string indexed _name);

    function nameOf(address _addr) public view returns (string memory) {
        if (checkMateHolder(_addr)) {
            return _addressToName[_addr];
        }
        return "";
    }

    function addressOf(string memory _name) public view returns (address) {
        address addr = _nameToAddress[_name];
        if (checkMateHolder(addr)) {
            return addr;
        }
        return address(0);
    }

    function changeName(string memory _name) public onlyMateHolder {
        require(bytes(_name).length > 0, "Empty name");
        require(addressOf(_name) == address(0), "Name already exists");
        string memory oldName = _addressToName[msg.sender];
        if (bytes(oldName).length > 0) {
            _nameToAddress[oldName] = address(0);
        }
        _addressToName[msg.sender] = _name;
        _nameToAddress[_name] = msg.sender;
        emit NameChanged(msg.sender, _name);
    }
}
