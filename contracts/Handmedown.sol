pragma solidity ^0.4.19;

contract Handmedown {
   mapping(address => Entity) entities;
   // Maps a child to a request object
   mapping(address => Request) requests;

   struct Entity {
      address[] owners;
      address[] assets;
      //mapping(address => bool) owners;
      //mapping(address => bool) assets;
   }

   struct Request {
      address requester;
      address requestee;
      bool isGiveReq;
   }

   event RequestMade(address requester, address requestee, bool isGiveReq);

   function acceptHandoff (address _asset, address _leasee) public {
      //entities[_leasee].assets[_asset] = true;
      //entities[_asset].owners[_leasee] = true;
      //Make sure msg.sender is fulfilling an existing request
      require(requests[_asset].requestee == _leasee && requests[_asset].isGiveReq == true);
      entities[msg.sender].assets.push( _asset );
      entities[_asset].owners.push( msg.sender );
   }

   function requestHandoff (address _asset, address _leasee) public canClaim(_asset){
      requests[ _asset ] = Request(msg.sender, _leasee, true);
      RequestMade(msg.sender, _leasee, true);
   }

   function requestReturn (address _asset, address _leasee) public canClaim(_asset){
      requests[ _asset ] = Request(msg.sender, _leasee, false);
      RequestMade(msg.sender, _leasee, false);
   }

   function acceptReturn (address _asset) public {
      //entities[msg.sender].assets[_asset] = false;
      //entities[_asset].owners[msg.sender] = false;
      //Make sure msg.sender is fulfilling an existing request
      require(requests[_asset].requestee == msg.sender && requests[_asset].isGiveReq == false);

      address[] storage owners = entities[_asset].owners;
      for (uint i = 0; i < owners.length; i++) {
         if ( owners[i] == msg.sender )
            delete entities[_asset].owners[i];
      }
      address[] storage assets = entities[msg.sender].assets;
      for (i = 0; i < assets.length; i++) {
         if ( assets[i] == _asset )
            delete entities[msg.sender].assets[i];
      }
   }

   //First return is a list of all ownerships
	//Second return is index of first coOwnerships (subsequent indices are coownerships)
   /*
	function getInventory () external view returns(address[], uint){
		address[] memory inventory = new address[](entities[msg.sender].assets.length);
		address[] memory uniqueOwnerships;
		address[] memory coOwnerships;
		for(uint i = 0; i < entities[msg.sender].assets.length; i++){
			if( entities[entities[msg.sender].assets[i]].owners.length == 1){
				uniqueOwnerships.push(entities[msg.sender].assets[i]);
			} else {
				coOwnerships.push(entities[msg.sender].assets[i]);
			}
		}
		
		uint firstCoOwned = uniqueOwnerships.length;
		for(i = 0; i < uniqueOwnerships.length; i++){
			inventory[i] = uniqueOwnerships[i];
		}
		for(i = 0; i < coOwnerships.length; i++){
			inventory[firstCoOwned+i] = coOwnerships[i];
		}
		return (inventory, firstCoOwned);
	}
   */
  function getInventory () external view returns(address[]) {
      address[] memory assets = entities[msg.sender].assets;
      return assets;
  }
   
   modifier canClaim(address _asset){
      for(uint i = 0; i < entities[_asset].owners.length; i++){
         if(entities[_asset].owners[i] == msg.sender)
            _;
      }
      revert();
   }

   function getOwners (address _asset) public view returns (address[]) {
      address[] memory owners = entities[_asset].owners;
      return owners;
   }
}
