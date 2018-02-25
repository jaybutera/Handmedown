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

   function acceptHandoff (address _asset) public {
      //entities[_leasee].assets[_asset] = true;
      //entities[_asset].owners[_leasee] = true;
      entities[msg.sender].assets.push( _asset );
      entities[_asset].owners.push( msg.sender );
   }

   function requestReturn (address _asset, address _leasee) public {
      requests[ _asset ] = Request(msg.sender, _leasee, false);
      RequestMade(msg.sender, _leasee, false);
   }

   function acceptReturn (address _asset) public {
      //entities[msg.sender].assets[_asset] = false;
      //entities[_asset].owners[msg.sender] = false;
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

   function getOwners (address _asset) public view returns (address[]) {
      address[] memory owners = entities[_asset].owners;
      return owners;
   }
}
