pragma solidity ^0.5.10;

import "ds-test/test.sol";
import "mix-item-store/ItemStoreRegistry.sol";
import "mix-item-store/ItemStoreIpfsSha256.sol";

import "./MixAccountItems.sol";
import "./MixAccountItemsProxy.sol";


contract MixAccountItemsTest is DSTest {

    ItemStoreRegistry itemStoreRegistry;
    ItemStoreIpfsSha256 itemStore;
    MixAccountItems mixAccountItems;
    MixAccountItemsProxy mixAccountItemsProxy;

    function setUp() public {
        itemStoreRegistry = new ItemStoreRegistry();
        itemStore = new ItemStoreIpfsSha256(itemStoreRegistry);
        mixAccountItems = new MixAccountItems(itemStoreRegistry);
        mixAccountItemsProxy = new MixAccountItemsProxy(mixAccountItems);
    }

    function testControlAddItemAlreadyAdded() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
    }

    function testFailAddItemAlreadyAdded() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItems.addItem(itemId);
    }

    function testControlAddItemNotOwner() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
    }

    function testFailAddItemNotOwner() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItemsProxy.addItem(itemId);
    }

    function testControlRemoveItemNotAdded() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItems.removeItem(itemId);
    }

    function testFailRemoveItemNotAdded() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItems.removeItem(itemId);
    }

    function testControlRemoveItemNotOwner() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItems.removeItem(itemId);
    }

    function testFailRemoveItemNotOwner() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItemsProxy.removeItem(itemId);
    }

    function testControlGetItemNotExist() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        itemId = itemStore.create(hex"0001", hex"1234");
        mixAccountItems.addItem(itemId);
        itemId = itemStore.create(hex"0002", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItems.getItem(2);
    }

    function testFailGetItemNotExist() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        itemId = itemStore.create(hex"0001", hex"1234");
        mixAccountItems.addItem(itemId);
        itemId = itemStore.create(hex"0002", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItems.getItem(3);
    }

    function testControlGetItemByAccountIdNotExist() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        itemId = itemStore.create(hex"0001", hex"1234");
        mixAccountItems.addItem(itemId);
        itemId = itemStore.create(hex"0002", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItems.getItemByAccount(address(this), 2);
    }

    function testFailGetItemByAccountNotExist() public {
        bytes32 itemId = itemStore.create(hex"00", hex"1234");
        mixAccountItems.addItem(itemId);
        itemId = itemStore.create(hex"0001", hex"1234");
        mixAccountItems.addItem(itemId);
        itemId = itemStore.create(hex"0002", hex"1234");
        mixAccountItems.addItem(itemId);
        mixAccountItems.getItemByAccount(address(this), 3);
    }

    function test() public {
        assertEq(mixAccountItems.getItemCount(), 0);
        bytes32[] memory itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 0);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);

        bytes32 itemId0 = itemStore.create(hex"0000", hex"1234");
        mixAccountItems.addItem(itemId0);
        assertEq(mixAccountItems.getItemCount(), 1);
        assertEq(mixAccountItems.getItem(0), itemId0);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 1);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId0);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);

        bytes32 itemId1 = itemStore.create(hex"0001", hex"1234");
        mixAccountItems.addItem(itemId1);
        assertEq(mixAccountItems.getItemCount(), 2);
        assertEq(mixAccountItems.getItem(0), itemId0);
        assertEq(mixAccountItems.getItem(1), itemId1);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 2);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId0);
        assertEq(mixAccountItems.getItemByAccount(address(this), 1), itemId1);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);

        bytes32 itemId2 = itemStore.create(hex"0002", hex"1234");
        mixAccountItems.addItem(itemId2);
        assertEq(mixAccountItems.getItemCount(), 3);
        assertEq(mixAccountItems.getItem(0), itemId0);
        assertEq(mixAccountItems.getItem(1), itemId1);
        assertEq(mixAccountItems.getItem(2), itemId2);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 3);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId0);
        assertEq(mixAccountItems.getItemByAccount(address(this), 1), itemId1);
        assertEq(mixAccountItems.getItemByAccount(address(this), 2), itemId2);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);

        mixAccountItems.removeItem(itemId0);
        assertEq(mixAccountItems.getItemCount(), 2);
        assertEq(mixAccountItems.getItem(0), itemId2);
        assertEq(mixAccountItems.getItem(1), itemId1);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 2);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId2);
        assertEq(mixAccountItems.getItemByAccount(address(this), 1), itemId1);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        mixAccountItems.addItem(itemId0);
        assertEq(mixAccountItems.getItemCount(), 3);
        assertEq(mixAccountItems.getItem(0), itemId2);
        assertEq(mixAccountItems.getItem(1), itemId1);
        assertEq(mixAccountItems.getItem(2), itemId0);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId0);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 3);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId2);
        assertEq(mixAccountItems.getItemByAccount(address(this), 1), itemId1);
        assertEq(mixAccountItems.getItemByAccount(address(this), 2), itemId0);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId0);

        mixAccountItems.removeItem(itemId0);
        assertEq(mixAccountItems.getItemCount(), 2);
        assertEq(mixAccountItems.getItem(0), itemId2);
        assertEq(mixAccountItems.getItem(1), itemId1);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 2);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId2);
        assertEq(mixAccountItems.getItemByAccount(address(this), 1), itemId1);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        mixAccountItems.removeItem(itemId1);
        assertEq(mixAccountItems.getItemCount(), 1);
        assertEq(mixAccountItems.getItem(0), itemId2);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 1);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId2);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId2);

        mixAccountItems.removeItem(itemId2);
        assertEq(mixAccountItems.getItemCount(), 0);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 0);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);

        mixAccountItems.addItem(itemId0);
        assertEq(mixAccountItems.getItemCount(), 1);
        assertEq(mixAccountItems.getItem(0), itemId0);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 1);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId0);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId0);

        mixAccountItems.addItem(itemId1);
        assertEq(mixAccountItems.getItemCount(), 2);
        assertEq(mixAccountItems.getItem(0), itemId0);
        assertEq(mixAccountItems.getItem(1), itemId1);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 2);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId0);
        assertEq(mixAccountItems.getItemByAccount(address(this), 1), itemId1);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);

        mixAccountItems.addItem(itemId2);
        assertEq(mixAccountItems.getItemCount(), 3);
        assertEq(mixAccountItems.getItem(0), itemId0);
        assertEq(mixAccountItems.getItem(1), itemId1);
        assertEq(mixAccountItems.getItem(2), itemId2);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 3);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId0);
        assertEq(mixAccountItems.getItemByAccount(address(this), 1), itemId1);
        assertEq(mixAccountItems.getItemByAccount(address(this), 2), itemId2);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 3);
        assertEq(itemIds[0], itemId0);
        assertEq(itemIds[1], itemId1);
        assertEq(itemIds[2], itemId2);

        mixAccountItems.removeItem(itemId0);
        assertEq(mixAccountItems.getItemCount(), 2);
        assertEq(mixAccountItems.getItem(0), itemId2);
        assertEq(mixAccountItems.getItem(1), itemId1);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 2);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId2);
        assertEq(mixAccountItems.getItemByAccount(address(this), 1), itemId1);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 2);
        assertEq(itemIds[0], itemId2);
        assertEq(itemIds[1], itemId1);

        mixAccountItems.removeItem(itemId2);
        assertEq(mixAccountItems.getItemCount(), 1);
        assertEq(mixAccountItems.getItem(0), itemId1);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 1);
        assertEq(mixAccountItems.getItemByAccount(address(this), 0), itemId1);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 1);
        assertEq(itemIds[0], itemId1);

        mixAccountItems.removeItem(itemId1);
        assertEq(mixAccountItems.getItemCount(), 0);
        itemIds = mixAccountItems.getAllItems();
        assertEq(itemIds.length, 0);
        assertEq(mixAccountItems.getItemCountByAccount(address(this)), 0);
        itemIds = mixAccountItems.getAllItemsByAccount(address(this));
        assertEq(itemIds.length, 0);
    }

}
