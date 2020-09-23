pragma solidity 0.6.6;
pragma experimental ABIEncoderV2;

import "./user.sol";

/*
library helpers contains modifiers to enhance function power and readability
*/
library helpers{
    
    modifier validateId(uint id) {
        require(id >= 0, "Invalid Id");
        _;
    }
    /*
    modifier checkExists(bytes32 check) {   //modifier is redundant
        for(uint i = 0; i < newsCatalog.length; i++) {
            require(newsCatalog[i].title == check || newsCatalog[i].authName == check, "Item could not be found.");
        }
        _;
    }
    */
    modifier validateUser(address user) {
        require(users[user].permissions == 1, "Invalid Credentials.");
        _;
    }
}
