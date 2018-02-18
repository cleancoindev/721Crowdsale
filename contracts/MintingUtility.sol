pragma solidity ^0.4.18;
import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";

contract MintingUtility is Pausable {
    uint8 public _tokenBatchSize = 64;

    function setTokenBatchSize(
        uint8 _size
    )  
        external
        onlyOwner
    {
        _tokenBatchSize = _size;
    }

    /*
        @dev Validates the lenght of an input parcel is not over block limit estimation 
        @param _tokenIds - tile tokens.
    */
    modifier limitBatchSize(
        uint64[] _tokenIds
    ) {
        require(_tokenIds.length <= _tokenBatchSize);
        _;
    }

    /*
        @dev can be overridden in utility subclass if the utility 
        mints
    */
    function isMinter()
        public
        pure
        returns (bool)
    {
        return false;
    }

    /* 
        Only minter contracts can access via this modifier
        Minter contracts return true for isMinter.
        Also, a minter either owns this contract or is owned by 
        the same contract as this
    */
    modifier onlyMinter()
    {
        MintingUtility minter = MintingUtility(msg.sender);
        // Either the minter contract is this owner
        // OR the minter's owner is this owner
        require(minter == owner || minter.owner() == owner);
        require(minter.isMinter() == true);
        _;
    }
}
