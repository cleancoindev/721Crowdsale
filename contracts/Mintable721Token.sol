pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/lifecycle/Pausable.sol";
import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "./QuickSort.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "./MintingUtility.sol";

contract Mintable721Token is ERC721Token, MintingUtility {
  using SafeMath for uint256;

  // Name and Symbol if needed
  string public constant name = "Mintable721";
  string public constant symbol = "M721";

  /*
   @dev Establishes ownership and brings parcel into existence AKA minting a token 
   @param _tokenIds - tile tokens.
   @param _beneficiary - Price of item (in wei) at beginning of auction.
  */
  function mint(
      address _beneficiary,
      uint64[] _tokenIds
    )
    limitBatchSize(_tokenIds)
    onlyMinter
    whenNotPaused
    public
  {
      for (uint i = 0; i < _tokenIds.length; i++) {
        // This will assign ownership, and also emit the Transfer event
        _mint(_beneficiary, _tokenIds[i]); 
      }
  }

  /*
   @dev returns a unique id representing all the tokens
   @param _tokenIds the list of tokenIds in group
  */
  function buildTokenGroupId(
    uint64[] memory _tokenIds
  ) 
    public 
    pure 
    returns (uint)
  {
      return uint256(keccak256(QuickSort.sortAndVerifyUnique(_tokenIds))); 
  }

  /***** TRANSFERS *****/

  /*
    @dev Transfer multiple tokens at once
    @param _from - Who we are transferring tile from.
    @param _to - beneficiary of tile.
    @param _tokenIds - tokens to transfer.
    @param sender - approved for transfer of tiles
  */
  function transferFromMany(
    address _from,
    address _to, 
    uint64[] _tokenIds
  ) 
    limitBatchSize(_tokenIds)
    whenNotPaused 
    public 
  {
      for (uint i = 0; i < _tokenIds.length; i++) {
          require(isApprovedFor(msg.sender, _tokenIds[i]));
          clearApprovalAndTransfer(_from, _to, _tokenIds[i]);
      }
  }

  /***** APPROVALS *****/
  
  /*
    @dev Approves a list of parcels for transfer
    @param sender - must be owner of tiles
    @param _tokenIds - tokens to approve.
  */
  function approveMany(
    address _to,
    uint64[] _tokenIds
  ) 
    limitBatchSize(_tokenIds)
    whenNotPaused 
    public 
  {
      for (uint i = 0; i < _tokenIds.length; i++) {
          approve(_to, _tokenIds[i]);
      }
  }

  /*
    @dev Check if an owner owns all tokens
    @param _owner - possible owner of tiles
    @param _tokenIds - tokens to check ownership.
  */
  function ownsTokens(
    address _owner, 
    uint64[] _tokenIds
  ) 
    public 
    constant 
    limitBatchSize(_tokenIds)
    returns (bool) 
  {
    for (uint i = 0; i < _tokenIds.length; i++) {
      if (ownerOf(_tokenIds[i]) != _owner) {
        return false;
      }
    }
    return true;
  }

}
