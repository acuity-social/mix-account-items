pragma solidity ^0.5.0;

import "ds-test/test.sol";

import "./MixAccountItems.sol";

contract MixAccountItemsTest is DSTest {
    MixAccountItems items;

    function setUp() public {
        items = new MixAccountItems();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
