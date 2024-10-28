This is a example repository to test the feature where contract A syncCall contract B on same shard and in the same interation/function contract B asyncCall contract C on different shard.

```Contract A --> syncCall --> Contract B --> asyncCall --> Contract C```

## Contracts
There are no automated tests as of now and hence you have to run all the scripts step by step. There are 5 contracts:
- SyncCallTester.sol : This contract inherits syncCall and tries to call the `call` function in the Caller, CallerWithPreRequire and CallerWithPostRequire contract
- Caller.sol : This is a perfect contract where there is no require statement and once the `call` function is called it valls the Incrementer contract's `increment` function
- CallerWithPreRequire.sol : This is a Caller contract with a `require` statement which is designed to fail written before the `asyncCall`
- CallerWithPostRequire.sol : This is a Caller contract with a `require` statement which is designed to fail written after the `asyncCall`
- Incrementer.sol : This is a increment contract which increments a value by one when called. We will use the `getValue` function to retrieve the value from this contract.

## How to Test?
All the contracts are compiled already. You just need to run the following scripts:

> **Before you proceed:** The contracts are already deployed here if you don't want to redeploy again:
> - SyncCallTester: `0x000119a11a6a923734c1df7c2c252cffa331ebd2`
> - CallerWithRequirePre: `0x000170c23fd7ff6f0289ddf6c545adda27484ab6`
> - Incrementer: `0x0002295082822d06a07a902ad22b3172d00cf4de`
>
> If you are using these contracts directly, proceed to `Interact/Call the SyncCallTester contract:`


- Deploy SyncCallTester contract:
```bash
    nil wallet deploy ./SyncCallTester/SyncCallTester.bin --abi ./SyncCallTester/SyncCallTester.abi --shard-id 1
```

- Deploy CallerWithPreRequire contract:
```bash
    nil wallet deploy ./CallerWithRequirePre/CallerWithRequirePre.bin --abi ./CallerWithRequirePre/CallerWithRequirePre.abi --shard-id 1
```

- Deploy Incrementer contract:
```bash
    nil wallet deploy ./Incrementer/Incrementer.bin --abi ./Incrementer/Incrementer.abi --shard-id 2
```

- Interact/Call the SyncCallTester contract:
```bash
    nil wallet send-message SyncCallTesterAddress syncCallTest CallerWithRequirePreAddress IncrementerAddress --abi ./SyncCallTester/SyncCallTester.abi --fee-credit 2000000
```

- Query the Incrementer contract to see if the value was increased:
```bash
    nil contract call-readonly IncrementerAddress getValue --abi ./Incrementer/Incrementer.abi
```

The result has to be :
```bash
    Success, result:
    uint256: 0
```

---
In the same way, you can deploy `CallerWithRequirePost` contract, replace the address in Interact with SyncCallTester and then query the Incrememter same as above and you would have the same result because the require statement would fail.

In case you deploy the `Caller` contract then the interaction and query will result in in 1 instead of 0.

## Conclusion
This proves that : If you make a synchronous call between two contracts on a single shard, and one of the methods within that call performs an asyncCall, the asyncCall will **not** be sent if the original synchronous message reverts.