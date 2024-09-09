
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

// Import JsonParserAsset.sol to utilise Asset struct
import { Asset } from "./JsonParserAsset.sol";

// Import JsonParserLib.sol to utilise its library
import { JsonParserLib } from "./JsonParserLib.sol";

contract JsonParser {

    mapping( bytes32 => Asset ) wallet; // Asset wallet
    bytes32[] idList;                   // Asset ID list

    constructor() {
        // Initialise asset
        Asset memory asset = JsonParserLib.getAssetTemplate();

        // Asset for Freddie
        asset.stringData  = "Freddie";
        asset.addressData = 0x8601b9EEAf50E142bf93C63a125eC279610665a5;
        asset.uint256Data = 100;
        asset.int256Data  = 1;
        asset.boolData    = true;
        asset.bytes32Data = 0xda83dc108a7fb02ce8d1cc9365f7547ef1968205d845a7a0a6478e5e1a641e2e;

        // Create Freddie's asset ID
        bytes32 assetId = JsonParserLib.generateAssetId( asset ); 

        // Push Freddie's asset to wallet
        wallet[ assetId ] = asset;
        idList.push( assetId );

        // Asset for Brian
        asset.stringData  = "Brian";
        asset.addressData = 0x4cb11e9C4ce1a9C36Ef95CBCaFc81b40C1B51651;
        asset.uint256Data = 300;
        asset.int256Data  = -2;
        asset.boolData    = false;
        asset.bytes32Data = 0xdd9978f784de94c22a3274537653a94305fbc471befd4fede844e24f3dee3201;

        // Create Brian's asset ID
        assetId = JsonParserLib.generateAssetId( asset ); 

        // Push Brian's asset to wallet
        wallet[ assetId ] = asset;
        idList.push( assetId );

        // Asset for Roger
        asset.stringData  = "Roger";
        asset.addressData = 0xA9Bd1570CFC2d9d03aB1260aE5fA778e7a89a77E;
        asset.uint256Data = 500;
        asset.int256Data  = -3;
        asset.boolData    = false;
        asset.bytes32Data = 0xc6cfeb21cf277944057266eb7d61848482c752b3a1e1916d9d81f7b3c48469fb;

        // Create Roger's asset ID
        assetId = JsonParserLib.generateAssetId( asset ); 

        // Push Roger's asset to wallet
        wallet[ assetId ] = asset;
        idList.push( assetId );

        // Asset for John
        asset.stringData  = "John";
        asset.addressData = 0x19ebF3a95F5d6721728b607f1F48a21b044e5C4c;
        asset.uint256Data = 700;
        asset.int256Data  = 5;
        asset.boolData    = true;
        asset.bytes32Data = 0xbc99422d9e0abdd8ab52ce43a39333e401a87a9afa547572ea407e5699240479;

        // Create John's asset ID
        assetId = JsonParserLib.generateAssetId( asset ); 

        // Push John's asset to wallet
        wallet[ assetId ] = asset;
        idList.push( assetId );
    }

    // getAllAssetIds() returns bytes32[] as asset ID list
    function getAllAssetIds() public view returns ( bytes32[] memory ) {

        return idList;
    }

    // getAllAssets() returns Assets[] as all registered asset
    function getAllAssets() public view returns ( Asset[] memory ) {
        // Get empty asset list
        Asset[] memory result = new Asset[]( idList.length ); 

        // Fetch all the Assets by their IDs over for loop
        for ( uint256 i = 0; i < idList.length; i++ ) {
            result[ i ] = wallet[ idList[ i ] ];
        }

        return result;
    }

    // getAllAssetsAsJson() returns string as all registered assets as JSON ( array of object )
    function getAllAssetsAsJson() public view returns ( string memory ) {
        // Get empty asset list
        Asset[] memory result = new Asset[]( idList.length ); 

        // Fetch all the Assets by their IDs over for loop
        for ( uint256 i = 0; i < idList.length; i++ ) {
            result[ i ] = wallet[ idList[ i ] ];
        }

        return JsonParserLib.stringifyAssetList( result );
    }

    // getAssetById() returns Asset by asset ID
    function getAssetById( bytes32 assetId ) public view returns ( Asset memory ) {
        // Check if given asset ID already exists in the wallet
        require( JsonParserLib.assetIdExists( assetId, idList ) == true,
            "Error: This asset ID does not exist in the wallet!" );

        return wallet[ assetId ];
    }

    // getAssetByIdAsJson() returns string as Asset converted into stringified JSON
    function getAssetByIdAsJson( bytes32 assetId ) public view returns ( string memory ) {
        // Check if given asset ID already exists in the wallet
        require( JsonParserLib.assetIdExists( assetId, idList ) == true,
            "Error: This asset ID does not exist in the wallet!" );

        return JsonParserLib.stringifyAsset( wallet[ assetId ] );
    }
}


