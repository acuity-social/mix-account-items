pragma solidity ^0.5.7;

import "ds-test/test.sol";
import "mix-item-store/item_store_registry.sol";
import "mix-item-store/item_store_ipfs_sha256.sol";

import "./MixAccountItems.sol";
import "./MixAccountItemsProxy.sol";


contract MixAccountItemsTest is DSTest {

    ItemStoreRegistry itemStoreRegistry;
    ItemStoreIpfsSha256 itemStore;
    MixAccountItems accountItems;
    MixAccountItemsProxy accountItemsProxy;

    function setUp() public {
        itemStoreRegistry = new ItemStoreRegistry();
        itemStore = new ItemStoreIpfsSha256(itemStoreRegistry);
        accountItems = new MixAccountItems(itemStoreRegistry);
        accountItemsProxy = new MixAccountItemsProxy(accountItems);
    }

    function testControlAddItemAlreadyAdded() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItems.addItem(itemId);
    }

    function testFailAddItemAlreadyAdded() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItems.addItem(itemId);
        accountItems.addItem(itemId);
    }

    function testControlAddItemNotOwner() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItems.addItem(itemId);
    }

    function testFailAddItemNotOwner() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItemsProxy.addItem(itemId);
    }

    function testControlRemoveItemNotAdded() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItems.addItem(itemId);
        accountItems.removeItem(itemId);
    }

    function testFailRemoveItemNotAdded() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItems.removeItem(itemId);
    }

    function testControlRemoveItemNotOwner() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItems.addItem(itemId);
        accountItems.removeItem(itemId);
    }

    function testFailRemoveItemNotOwner() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItems.addItem(itemId);
        accountItemsProxy.removeItem(itemId);
    }

}
