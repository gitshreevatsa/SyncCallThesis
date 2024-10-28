// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@nilfoundation/smart-contracts/contracts/Nil.sol";

contract CallerWithRequirePre {
    using Nil for address;
    bool lock = true;
    function call(address dst) public {
        require(!lock, "It is Locked!");
        Nil.asyncCall(
            dst,
            msg.sender,
            msg.sender,
            100000,
            0,
            false,
            0,
            abi.encodeWithSignature("increment()")
        );
    }
}
