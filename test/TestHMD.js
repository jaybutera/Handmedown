const Handmedown = artifacts.require('./Handmedown.sol')

contract('Handmedown', accounts => {
   let hmd_addr;
   let child = accounts[0];
   let par = accounts[1];
   let sitter = accounts[2];

   before( async () => {
      hmd_addr = await Handmedown.new()
   })

   describe('All tests', async () => {
      it('Should handoff a child', async () => {
         await hmd_addr.request
         await hmd_addr.acceptHandoff
      })
   })
})
