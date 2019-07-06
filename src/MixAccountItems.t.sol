pragma solidity ^0.5.7;

import "ds-test/test.sol";
import "mix-item-store/ItemStoreRegistry.sol";
import "mix-item-store/ItemStoreIpfsSha256.sol";

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

    function testControlGetItemNotExist() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItems.addItem(itemId);
        itemId = itemStore.create(hex"0001", hex"1234");
        accountItems.addItem(itemId);
        itemId = itemStore.create(hex"0002", hex"1234");
        accountItems.addItem(itemId);
        accountItems.getItem(2);
    }

    function testFailGetItemNotExist() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItems.addItem(itemId);
        itemId = itemStore.create(hex"0001", hex"1234");
        accountItems.addItem(itemId);
        itemId = itemStore.create(hex"0002", hex"1234");
        accountItems.addItem(itemId);
        accountItems.getItem(3);
    }

    function testControlGetItemByAccountIdNotExist() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItems.addItem(itemId);
        itemId = itemStore.create(hex"0001", hex"1234");
        accountItems.addItem(itemId);
        itemId = itemStore.create(hex"0002", hex"1234");
        accountItems.addItem(itemId);
        accountItems.getItemByAccount(address(this), 2);
    }

    function testFailGetItemByAccountNotExist() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        accountItems.addItem(itemId);
        itemId = itemStore.create(hex"0001", hex"1234");
        accountItems.addItem(itemId);
        itemId = itemStore.create(hex"0002", hex"1234");
        accountItems.addItem(itemId);
        accountItems.getItemByAccount(address(this), 3);
    }

    function test() public {
        assertEq(accountItems.getItemCount(), 0);
        bytes32[] memory itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertEq(accountItems.getItemCountByAccount(address(this)), 0);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);

        bytes32 itemId0 = itemStore.create(hex"0000", hex"1234");
        accountItems.addItem(itemId0);
        assertEq(accountItems.getItemCount(), 1);
        assertEq(accountItems.getItem(0), itemId0);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(accountItems.getItemCountByAccount(address(this)), 1);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId0);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);

        bytes32 itemId1 = itemStore.create(hex"0001", hex"1234");
        accountItems.addItem(itemId1);
        assertEq(accountItems.getItemCount(), 2);
        assertEq(accountItems.getItem(0), itemId0);
        assertEq(accountItems.getItem(1), itemId1);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(accountItems.getItemCountByAccount(address(this)), 2);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId0);
        assertEq(accountItems.getItemByAccount(address(this), 1), itemId1);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);

        bytes32 itemId2 = itemStore.create(hex"0002", hex"1234");
        accountItems.addItem(itemId2);
        assertEq(accountItems.getItemCount(), 3);
        assertEq(accountItems.getItem(0), itemId0);
        assertEq(accountItems.getItem(1), itemId1);
        assertEq(accountItems.getItem(2), itemId2);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(accountItems.getItemCountByAccount(address(this)), 3);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId0);
        assertEq(accountItems.getItemByAccount(address(this), 1), itemId1);
        assertEq(accountItems.getItemByAccount(address(this), 2), itemId2);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);

        accountItems.removeItem(itemId0);
        assertEq(accountItems.getItemCount(), 2);
        assertEq(accountItems.getItem(0), itemId2);
        assertEq(accountItems.getItem(1), itemId1);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(accountItems.getItemCountByAccount(address(this)), 2);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId2);
        assertEq(accountItems.getItemByAccount(address(this), 1), itemId1);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        accountItems.addItem(itemId0);
        assertEq(accountItems.getItemCount(), 3);
        assertEq(accountItems.getItem(0), itemId2);
        assertEq(accountItems.getItem(1), itemId1);
        assertEq(accountItems.getItem(2), itemId0);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId0);
        assertEq(accountItems.getItemCountByAccount(address(this)), 3);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId2);
        assertEq(accountItems.getItemByAccount(address(this), 1), itemId1);
        assertEq(accountItems.getItemByAccount(address(this), 2), itemId0);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId0);

        accountItems.removeItem(itemId0);
        assertEq(accountItems.getItemCount(), 2);
        assertEq(accountItems.getItem(0), itemId2);
        assertEq(accountItems.getItem(1), itemId1);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(accountItems.getItemCountByAccount(address(this)), 2);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId2);
        assertEq(accountItems.getItemByAccount(address(this), 1), itemId1);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        accountItems.removeItem(itemId1);
        assertEq(accountItems.getItemCount(), 1);
        assertEq(accountItems.getItem(0), itemId2);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);
        assertEq(accountItems.getItemCountByAccount(address(this)), 1);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId2);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);

        accountItems.removeItem(itemId2);
        assertEq(accountItems.getItemCount(), 0);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertEq(accountItems.getItemCountByAccount(address(this)), 0);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);

        accountItems.addItem(itemId0);
        assertEq(accountItems.getItemCount(), 1);
        assertEq(accountItems.getItem(0), itemId0);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(accountItems.getItemCountByAccount(address(this)), 1);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId0);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);

        accountItems.addItem(itemId1);
        assertEq(accountItems.getItemCount(), 2);
        assertEq(accountItems.getItem(0), itemId0);
        assertEq(accountItems.getItem(1), itemId1);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(accountItems.getItemCountByAccount(address(this)), 2);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId0);
        assertEq(accountItems.getItemByAccount(address(this), 1), itemId1);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);

        accountItems.addItem(itemId2);
        assertEq(accountItems.getItemCount(), 3);
        assertEq(accountItems.getItem(0), itemId0);
        assertEq(accountItems.getItem(1), itemId1);
        assertEq(accountItems.getItem(2), itemId2);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(accountItems.getItemCountByAccount(address(this)), 3);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId0);
        assertEq(accountItems.getItemByAccount(address(this), 1), itemId1);
        assertEq(accountItems.getItemByAccount(address(this), 2), itemId2);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);

        accountItems.removeItem(itemId0);
        assertEq(accountItems.getItemCount(), 2);
        assertEq(accountItems.getItem(0), itemId2);
        assertEq(accountItems.getItem(1), itemId1);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(accountItems.getItemCountByAccount(address(this)), 2);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId2);
        assertEq(accountItems.getItemByAccount(address(this), 1), itemId1);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        accountItems.removeItem(itemId2);
        assertEq(accountItems.getItemCount(), 1);
        assertEq(accountItems.getItem(0), itemId1);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);
        assertEq(accountItems.getItemCountByAccount(address(this)), 1);
        assertEq(accountItems.getItemByAccount(address(this), 0), itemId1);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);

        accountItems.removeItem(itemId1);
        assertEq(accountItems.getItemCount(), 0);
        itemIds = accountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertEq(accountItems.getItemCountByAccount(address(this)), 0);
        itemIds = accountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);
    }

}
