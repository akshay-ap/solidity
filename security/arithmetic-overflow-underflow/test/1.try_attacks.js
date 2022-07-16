const Attack = artifacts.require("Attack");
const Attack2 = artifacts.require("Attack2");

const VaultSecured = artifacts.require("VaultSecured");
const truffleAssert = require('truffle-assertions');

contract("attack vault", (accounts) => {
    it("should attack the contract", async () => {
        const depoyedAttack = await Attack.deployed();
        await depoyedAttack.attack({ value: 10 ** 18 });
    })

    it("attack should fail", async () => {
        // const vaultSecured = await VaultSecured.deployed();
        const depoyedAttack = await Attack2.deployed();

        //  const depoyedAttack = await Attack.new(vaultSecured);
        await truffleAssert.reverts(depoyedAttack.attack({ value: 10 ** 18 }));
    });
})