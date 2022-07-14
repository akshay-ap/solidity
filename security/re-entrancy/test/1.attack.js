const ValueStore = artifacts.require("ValueStore");
const Attack = artifacts.require("Attack");
const Web3 = require('web3');


contract("Attack", (accounts) => {
    it("should steal user funds", async () => {
        const contractValueStore = await ValueStore.deployed();
        const contractAttack = await Attack.deployed();


        // Deposit
        await contractValueStore.deposit({ from: accounts[0], value: 10 ** 18 });
        await contractValueStore.deposit({ from: accounts[1], value: 10 ** 18 });

        const totalBal = (await contractValueStore.totalDeposits.call()).toString();
        assert.equal(totalBal, 2 * (10 ** 18))

        // Attack
        await contractAttack.attack({ from: accounts[2], value: 10 ** 18 });
        const attackerBalance = (await contractAttack.getBalance.call()).toString();
        assert.equal(attackerBalance, 3 * (10 ** 18))
    })
})