// SPDX-License-Identifier: MIT
pragma solidity ^0.8.6;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract NLPToken is ERC721, Ownable{
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    address signerAddress;

    event TokenMinted(address, uint256);
    event SignerChanged(address);

    constructor(address _signerAddress ) ERC721("NLP-Token", "NLP") {
        signerAddress = _signerAddress;
    }

    function mintNPL(
        uint256 deadline,
        bytes memory signature) external {
        require(verify(msg.sender, deadline, signature), "INVALID_SIGNATURE");
        require( deadline > block.timestamp,"deadline Passed");

        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(msg.sender, tokenId);
        emit TokenMinted(msg.sender, tokenId);
    }

    //getting msg hash to generate signature off chian
    function getMessageHash(
        address receiver,
        uint256 deadline
    ) public pure returns (bytes32) {
        return keccak256(abi.encodePacked(receiver, deadline));
    }

    //signer functioanlity
        function getEthSignedMessageHash(bytes32 _messageHash)
        public
        pure
        returns (bytes32)
    {
        /*
        Signature is produced by signing a keccak256 hash with the following format:
        "\x19Ethereum Signed Message\n" + len(msg) + msg
        */
        return
            keccak256(
                abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
            );
    }

    function verify(
        address receiver,
        uint256 deadline,
        bytes memory signature
    ) public view returns (bool) {
        bytes32 messageHash = getMessageHash(receiver, deadline);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);

        return recoverSigner(ethSignedMessageHash, signature) == signerAddress;
    }

    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature)
        public
        pure
        returns (address)
    {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);

        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory sig)
        public
        pure
        returns (
            bytes32 r,
            bytes32 s,
            uint8 v
        )
    {
        require(sig.length == 65, "invalid signature length");

        assembly {
            /*
            First 32 bytes stores the length of the signature
            add(sig, 32) = pointer of sig + 32
            effectively, skips first 32 bytes of signature
            mload(p) loads next 32 bytes starting at the memory address p into memory
            */

            // first 32 bytes, after the length prefix
            r := mload(add(sig, 32))
            // second 32 bytes
            s := mload(add(sig, 64))
            // final byte (first byte of the next 32 bytes)
            v := byte(0, mload(add(sig, 96)))
        }

        // implicitly return (r, s, v)
    }



    function setSignerAddress(address _address) external onlyOwner {
        signerAddress = _address;
        emit SignerChanged(_address); 
    }
}