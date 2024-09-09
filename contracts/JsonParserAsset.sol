
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// Sample struct which is converted into stringified JSON
struct Asset {
    string  stringData;
    address addressData;
    uint256 uint256Data;
    int256  int256Data;
    bool    boolData;
    bytes32 bytes32Data;
}

library JsonParserAsset {}
