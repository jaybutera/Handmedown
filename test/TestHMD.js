const Handmedown = artifacts.require('./Handmedown.sol')

contract('Handmedown', accounts => {
   let hmd_addr;
   let root = accounts[0];
   let child = accounts[1];
   let par = accounts[2];
   let sitter = accounts[3];

   before( async () => {
      hmd_addr = await Handmedown.new()
   })

   describe('All tests', async () => {
      it('Should assign child to parent', async () => {
         await hmd_addr.assignAsset(child, par, {from:root})
      })
      it('Should handoff a child', async () => {
         await hmd_addr.requestHandoff(child, sitter, {from:par})
         //await hmd_addr.requests[child]
         console.log('sup')
         //assert(
         await hmd_addr.acceptHandoff(child, {from:sitter})
      })
      it('Should return list of owners', async () => {
         let owners = await hmd_addr.getOwners(child)
         console.log(owners)
      })
   })
})
