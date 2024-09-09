
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// Import Strings.sol from OpenZeppelin library via GitHub URL
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

/*
 * Or install Strings.sol via npm when compiling this script with Hardhat
 * Reference: https://www.npmjs.com/package/@openzeppelin/contracts
*/
//import "@openzeppelin/contracts/utils/Strings.sol";

// Import JsonParserAsset.sol to utilise Asset library
import { Asset } from "./JsonParserAsset.sol";

library JsonParserLib {

    // getTemplateAsset() returns Asset as asset template
    function getAssetTemplate() internal pure returns ( Asset memory ) {

        return Asset( {
            stringData  : "",
            addressData : 0x0000000000000000000000000000000000000000,
            uint256Data : 0,
            int256Data  : 0,
            boolData    : false,
            bytes32Data : 0x0000000000000000000000000000000000000000000000000000000000000000
        } );
    }

    // stringifyAsset() returns string memory as stringified JSON
    function stringifyAsset( Asset memory inputAsset ) internal pure returns ( string memory ) {
        string memory result;
        result = string( abi.encodePacked(    "{", "\"stringData\":\"",  inputAsset.stringData,                         "\"," ) );
        result = string( abi.encodePacked( result, "\"addressData\":\"", addressToString( inputAsset.addressData ),     "\"," ) );
        result = string( abi.encodePacked( result, "\"uint256Data\":",   Strings.toString( inputAsset.uint256Data ),      "," ) );
        result = string( abi.encodePacked( result, "\"int256Data\":",    Strings.toStringSigned( inputAsset.int256Data ), "," ) );
        result = string( abi.encodePacked( result, "\"boolData\":",      boolToString( inputAsset.boolData ),             "," ) );
        result = string( abi.encodePacked( result, "\"bytes32Data\":\"", bytes32ToString( inputAsset.bytes32Data ),     "\"}" ) );

        return result;
    }

    // stringifyAssetList() returns string memory as stringified JSON ( array of object )
    function stringifyAssetList( Asset[] memory inputAssetList ) internal pure returns ( string memory ) {
        string memory result = "[";
        for ( uint256 i = 0; i < inputAssetList.length; i++ ) {
            if ( i == inputAssetList.length - 1 ) {
                result = string( abi.encodePacked( result, stringifyAsset( inputAssetList[ i ] ), "]" ) );
            } else {
                result = string( abi.encodePacked( result, stringifyAsset( inputAssetList[ i ] ), "," ) );
            }
        }

        return result;
    }

    // generateAssetId() returns byte32 generated by keccak256
    function generateAssetId( Asset memory asset ) internal pure returns ( bytes32 ) {

        return keccak256( bytes( string( abi.encodePacked(
            asset.stringData,                           // stringData
            addressToString( asset.addressData ),       // addressData
            Strings.toString( asset.uint256Data ),      // uint256Data
            Strings.toStringSigned( asset.int256Data ), // int256Data
            boolToString( asset.boolData ),             // boolData
            bytes32ToString( asset.bytes32Data )        // bytes32Data
        ) ) ) );
    }

    // assetIdExists() returns bool to check if input asset ID exists in the wallet
    function assetIdExists( bytes32 inputBytes32, bytes32[] memory inputIdList ) internal pure returns ( bool ) {
        bool result = false;
        for ( uint256 i = 0; i < inputIdList.length; i++ ) {
            if ( inputBytes32 == inputIdList[ i ] ) {
                result = true;
                break;
            }
        }

        return result;
    }

    // addressToString() converts address to string 
    function addressToString( address inputAddress ) private pure returns ( string memory ) {

        return Strings.toHexString( inputAddress );
    }

    // boolToString() converts bool to string
    function boolToString( bool inputBool ) private pure returns ( string memory ) {

        if ( inputBool == true ) { return "true";  }
        else                     { return "false"; }
    }

    // bytes32ToString() converts bytes32 to string
    function bytes32ToString( bytes32 inputBytes32 ) private pure returns ( string memory ) {

        return Strings.toHexString( uint256( inputBytes32 ), 32 );
    }
}
