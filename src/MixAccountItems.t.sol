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

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
