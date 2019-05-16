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

    function getItemId(uint i) external view returns (bytes32) {
        return mixAccountItems.getItemId(i);
    }

    function getAllItems() external view returns (bytes32[] memory) {
        return mixAccountItems.getAllItems();
    }

    function getItemsCountByAccount(address account) external view returns (uint) {
        return mixAccountItems.getItemsCountByAccount(account);
    }

    function getItemIdByAccount(address account, uint i) external view returns (bytes32) {
        return mixAccountItems.getItemIdByAccount(account, i);
    }

    function getAllItemsByAccount(address account) external view returns (bytes32[] memory) {
        return mixAccountItems.getAllItemsByAccount(account);
    }

}
