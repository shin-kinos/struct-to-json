# struct-to-json

An attempt to convert struct into string as stringified JSON data in Solidity

## Dependencies

```
* Solidity (v0.8.20 or more)
* Strings.sol from OpenZeppelin library (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol)
```

## Motivation

When calling a Solidity function which returns sturuct in JavaScript/TypeScript, the results are recognised as Array(s) without their property names - for example, the following Solidity code stores a struct `User` which contains several elements (`string name`, `uint256 age` and `address id`), and implements a function `getUser()` which fetch `User` content:

``` solidity
// Sample struct which is converted into stringified JSON
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
// => The expected result: tuple( string, uint256, address )
```

The following example Typescript code with Ethers.js library is supposed to call the `getUser()` function in order to fetch the User struct as `tuple( string, uint256, address )`:

``` typescript
// Define concract ABI
const contractAbi = [ 'function getUser() returns ( tuple( string, uint256, address ) )' ];

/*
 * Do several things to call a smart contract which is on an Ethereum blockchain
 * such as defining provider, getting signer and creating a contract.
 * And then getUser() function is available as follows:
*/

const callGetUser = await contract[ 'getUser' ]();
if ( !callGetUser ) { throw new Error( 'Failed to call getUser() function!' ); }
// => The expected result type: tuple( string, uint256, address )
```

Yet actually it receives the result data as Array in the latest  
