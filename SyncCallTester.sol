// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@nilfoundation/smart-contracts/contracts/Nil.sol";

contract SyncCallTester {
    using Nil for address;

    receive() external payable {}

    function syncCallTest(address caller, address to) public {
        Nil.Token[] memory tokens = Nil.msgTokens();
        Nil.syncCall(caller, 1_000_000, 0, tokens,abi.encodeWithSignature("call(address)", to));
    }
}
