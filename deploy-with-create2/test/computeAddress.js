const Deployer = artifacts.require("Deployer");
const TestContract = artifacts.require("TestContract");
const truffleAssert = require("truffle-assertions");

contract("Deploy contract", (accounts) => {
    it("Should deploy at pre-determined address", async () => {
        const owner = accounts[0];
        const contractDeployer = await Deployer.new({ from: owner });
        const bytecode = await contractDeployer.getByteCode.call(owner, { from: owner });

        const preComputedAddress = await contractDeployer.getAddress.call(bytecode, 777, { from: owner });
        const actualAddress = await contractDeployer.deploy(777, { from: owner });

        expect(preComputedAddress).to.equal(actualAddress.logs[0].args.newContractAddress);

        console.log(`TestContract deployed successfully at expected address [${preComputedAddress}]`)
    })
})