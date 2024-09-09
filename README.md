# struct-to-json

An attempt to convert struct into string as stringified JSON data in Solidity

## Dependencies

- Solidity (v0.8.20 or more)
- Strings.sol from OpenZeppelin library (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol)


## Motivation

When calling a Solidity function which returns sturuct in JavaScript/TypeScript, the results are recognised as Array(s) without their key names - e.g., the following Solidity code stores a struct `User` which contains three elements (`string name`, `uint256 age` and `address id`), and implements a function `getUser()` which fetches `User` content:

``` solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// Sample struct
struct User {
    string  name;
    uint256 age;
    address id;
}

// Define one user
User exampleUser = User(
    "Freddie",
    25,
    0x8601b9EEAf50E142bf93C63a125eC279610665a5,
);

Constructor() {}

// Function which returns the struct User
function getUser() public view returns ( User memory ) {
    return exampleUser;
}
// => The expected result type: tuple( string, uint256, address )
```

Following example Typescript code with Ethers.js library is supposed to call the `getUser()` function in order to fetch the User struct as `tuple( string, uint256, address )`:

``` typescript
// Define concract ABI
const contractAbi = [ 'function getUser() returns ( tuple( string, uint256, address ) )' ];

/*
 * Do several things to call a smart contract which is deployed on an Ethereum blockchain
 * such as defining provider, getting signer and creating a contract.
 * And then getUser() function is available as follows:
*/

try {
  // Call getUser() function
  const callGetUser = await contract[ 'getUser' ]();
  if ( !callGetUser ) {
    throw new Error( 'Failed to call getUser() function!' );
  }

  console.log( 'callGetUser:', callGetUser );
  // => The expected result type: tuple( string, uint256, address )

} catch ( error ) {
  console.error( error );
}
```

However, it actually receives the result data as Array without key names of struct defined in Solidity.

Creating an another function to stringify the result struct as JSON might be a solution as follows:

``` solidity
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// Import Strings.sol from OpenZeppelin library via GitHub URL
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

// Sample struct
struct User {
    string  name;
    uint256 age;
    address id;
}

// Define one user
User exampleUser = User(
    "Freddie",
    25,
    0x8601b9EEAf50E142bf93C63a125eC279610665a5,
);

Constructor() {}

// Function which returns the struct User
function getUser() public view returns ( User memory ) {
    return exampleUser;
}

// Function which returns the struct User as stringified JSON data
function getUserAsJson() public view returns ( string memory ) {
    string memory result;
    result = string( abi.encodePacked(    "{", "\"name\":\"",    exampleUser.name,                           "\"," ) );
    result = string( abi.encodePacked( result, "\"age\":",       Strings.toString( exampleUser.age ),          "," ) );
    result = string( abi.encodePacked( result, "\"address\":\"", Strings.toHexString( exampleUser.address ), "\"}" ) );

    return result;
}
```

The Typescript code then be able to receive the result as stringified JSON data:

``` typescript
// Define concract ABI
const contractAbi = [ 'function getUserAsJson() returns ( string )' ];

/*
 * Do several things to call a smart contract which is deployed on an Ethereum blockchain
 * such as defining provider, getting signer and creating a contract.
 * And then getUserAsJson() function is available as follows:
*/

try {
  // Call getUserAsJson() function
  const callGetUserAsJson = await contract[ 'getUserAsJson' ]();
  if ( !callGetUserAsJson ) {
    throw new Error( 'Failed to call getUserAsJson() function!' );
  }

  // Parse the result as JSON data
  const resultJson = JSON.parse( callGetUserAsJson );

  console.log( 'resultJson:', resultJson );

} catch ( error ) {
  console.error( error );
}
```

The example Solidity contract script `JsonParser.sol` demonstrates that it converts a struct to stringified JSON, which contains following data types:

1. `string`
2. `address`
3. `uint256`
4. `int256`
5. `bool`
6. `bytes32`
