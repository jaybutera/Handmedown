var Migrations = artifacts.require("./Migrations.sol");
var Handmedown = artifacts.require("./Handmedown.sol");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  deployer.deploy(Handmedown);
};
