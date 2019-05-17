pragma solidity ^0.5.7;

import "./MixAccountItems.sol";


contract MixAccountItemsProxy {


    MixAccountItems mixAccountItems;

    /**
     * @param _mixAccountItems Real MixAccountItems contract to proxy to.
     */
    constructor (MixAccountItems _mixAccountItems) public {
        mixAccountItems = _mixAccountItems;
    }

    function addItem(bytes32 itemId) external {
        mixAccountItems.addItem(itemId);
    }

    function removeItem(bytes32 itemId) external {
        mixAccountItems.removeItem(itemId);
    }

    function getItemCount() external view returns (uint) {
        return mixAccountItems.getItemCount();
    }

    function getItem(uint i) external view returns (bytes32) {
        return mixAccountItems.getItem(i);
    }

    function getAllItems() external view returns (bytes32[] memory) {
        return mixAccountItems.getAllItems();
    }

    function getItemCountByAccount(address account) external view returns (uint) {
        return mixAccountItems.getItemCountByAccount(account);
    }

    function getItemByAccount(address account, uint i) external view returns (bytes32) {
        return mixAccountItems.getItemByAccount(account, i);
    }

    function getAllItemsByAccount(address account) external view returns (bytes32[] memory) {
        return mixAccountItems.getAllItemsByAccount(account);
    }

}
