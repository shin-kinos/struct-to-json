
// SPDX-License-Identifier: Apache-2.0

// Import Strings.sol from OpenZeppelin library via GitHub URL
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

/*
 * Or install Strings.sol via npm when compiling this script with Hardhat
 * Reference: https://www.npmjs.com/package/@openzeppelin/contracts
*/
//import "@openzeppelin/contracts/utils/Strings.sol";

pragma solidity ^0.8.20;

contract Json {

    // Sample struct which is converted into stringified JSON
    struct Asset {
        string  userName;
        address userAddress;
        uint256 amount;
        int256  score;
        bool    isValid;
        bytes32 assetId;
    }

    // Asset template
    Asset assetTemplate = Asset(
        /* userName    : */ "",
        /* userAddress : */ 0x0000000000000000000000000000000000000000,
        /* amount      : */ 0,
        /* score       : */ 0,
        /* isValue     : */ false,
        /* assetId     : */ 0x0000000000000000000000000000000000000000000000000000000000000000
    );

    mapping( bytes32 => Asset ) wallet; // Asset wallet
    bytes32[] idList;                   // Asset ID list

    constructor() {
        // Asset for Freddie
        Asset memory asset = assetTemplate;
        asset.userName     = "Freddie";
        asset.userAddress  = 0x8601b9EEAf50E142bf93C63a125eC279610665a5;
        asset.amount       = 100;
        asset.score        = 1;
        asset.isValid      = true;
        asset.assetId      = generateAssetId( asset );

        // Push Freddie asset to wallet
        wallet[ asset.assetId ] = asset;
        idList.push( asset.assetId );

        // Asset for Brian
        asset.userName    = "Brian";
        asset.userAddress = 0x4cb11e9C4ce1a9C36Ef95CBCaFc81b40C1B51651;
        asset.amount      = 300;
        asset.score       = -2;
        asset.isValid     = false;
        asset.assetId     = generateAssetId( asset );

        // Push Brian asset to wallet
        wallet[ asset.assetId ] = asset;
        idList.push( asset.assetId );

        // Asset for Roger
        asset.userName    = "Roger";
        asset.userAddress = 0xA9Bd1570CFC2d9d03aB1260aE5fA778e7a89a77E;
        asset.amount      = 500;
        asset.score       = -3;
        asset.isValid     = false;
        asset.assetId     = generateAssetId( asset );

        // Push Roger asset to wallet
        wallet[ asset.assetId ] = asset;
        idList.push( asset.assetId );

        // Asset for John
        asset.userName    = "John";
        asset.userAddress = 0x19ebF3a95F5d6721728b607f1F48a21b044e5C4c;
        asset.amount      = 700;
        asset.score       = 5;
        asset.isValid     = true;
        asset.assetId     = generateAssetId( asset );

        // Push John asset to wallet
        wallet[ asset.assetId ] = asset;
        idList.push( asset.assetId );
    }

    // Function to get all assets' address
    function getAddressList() public view returns ( bytes32[] memory ) {

        return idList;
    }

    // Function to fetch an asset by asset ID
    function getAsset( bytes32 inputId ) public view returns ( Asset memory ) {

        return wallet[ inputId ];
    }

    // Function to fetch an asset in JSON format by asset ID 
    function getAssetAsJson( bytes32 inputId ) public view returns ( string memory ) {

        return stringifyAsset( wallet[ inputId ] );  
    }

    // Function to stringify asset
    function stringifyAsset( Asset memory inputAsset ) private pure returns ( string memory ) {
        string memory result;

        result = string( abi.encodePacked(    "{", "\"nameName\":\"",    inputAsset.userName,                       "\"," ) );
        result = string( abi.encodePacked( result, "\"userAddress\":\"", addressToString( inputAsset.userAddress ), "\"," ) );
        result = string( abi.encodePacked( result, "\"amount\":",        Strings.toString( inputAsset.amount ),       "," ) );
        result = string( abi.encodePacked( result, "\"score\":",         Strings.toStringSigned( inputAsset.score ),  "," ) );
        result = string( abi.encodePacked( result, "\"isValid\":",       boolToString( inputAsset.isValid ),          "," ) );
        result = string( abi.encodePacked( result, "\"assetId\":\"",     keccak256ToString( inputAsset.assetId ),   "\"}" ) );

        return result;
    }

    // Function to generate asset ID
    function generateAssetId( Asset memory asset ) private pure returns ( bytes32 ) {

        return keccak256( bytes( string( abi.encodePacked(
            asset.userName,                        // User name
            addressToString( asset.userAddress ),  // Stringified user address
            Strings.toString( asset.amount ),      // Stringified amount
            Strings.toStringSigned( asset.score ), // Stringified score
            boolToString( asset.isValid )          // Stringified isValid
        ) ) ) );

    }

    // Function to convert address to string 
    function addressToString( address inputAddress ) private pure returns ( string memory ) {

        return Strings.toHexString( inputAddress );
    }

    // Function to convert bool to string
    function boolToString( bool inputBool ) private pure returns ( string memory ) {

        if ( inputBool == true ) { return "true";  }
        else                     { return "false"; }
    }

    // Function to convert bytes32 which is generated by keccak256 to string
    function keccak256ToString( bytes32 inputBytes32 ) private pure returns ( string memory ) {

        return Strings.toHexString( uint256( inputBytes32 ), 32 );
    }
}
