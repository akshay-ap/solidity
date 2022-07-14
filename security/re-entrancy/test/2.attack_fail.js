const ValueStoreSecure1 = artifacts.require("ValueStoreSecure1");
const ValueStoreSecure2 = artifacts.require("ValueStoreSecure2");
const Attack = artifacts.require("Attack");
const truffleAssert = require('truffle-assertions');


contract("Attack fail", (accounts) => {
    it("should not steal user funds", async () => {

        const contractValueStore = await ValueStoreSecure1.deployed();

        const contractAttack = await Attack.new(contractValueStore.address, { from: accounts[0] });

        // Deposit
        await contractValueStore.deposit({ from: accounts[0], value: 10 ** 18 });
        await contractValueStore.deposit({ from: accounts[1], value: 10 ** 18 });

        const totalBal = (await contractValueStore.totalDeposits.call()).toString();
        assert.equal(totalBal, 2 * (10 ** 18))

        // Attack
        // await contractAttack.attack({ from: accounts[2], value: 10 ** 18 });
        await truffleAssert.reverts(contractAttack.attack({ from: accounts[2], value: 10 ** 18 }));

        const attackerBalance = (await contractAttack.getBalance.call()).toString();
        assert.equal(attackerBalance, 0);

        const balanceBeforeWithdraw = (await contractValueStore.balanceOf.call(accounts[1])).toString();
        assert.equal(balanceBeforeWithdraw, 10 ** 18);

        await contractValueStore.withdraw({ from: accounts[1] });
        const balanceAfterWithdraw = (await contractValueStore.balanceOf.call(accounts[1])).toString();
        assert.equal(balanceAfterWithdraw, 0);
    })


    it("should not steal user funds - using re-entrancy guard", async () => {

        const contractValueStore = await ValueStoreSecure2.deployed();

        const contractAttack = await Attack.new(contractValueStore.address, { from: accounts[0] });

        // Deposit
        await contractValueStore.deposit({ from: accounts[0], value: 10 ** 18 });
        await contractValueStore.deposit({ from: accounts[1], value: 10 ** 18 });

        const totalBal = (await contractValueStore.totalDeposits.call()).toString();
        assert.equal(totalBal, 2 * (10 ** 18))

        // Attack
        // await contractAttack.attack({ from: accounts[2], value: 10 ** 18 });
        await truffleAssert.reverts(contractAttack.attack({ from: accounts[2], value: 10 ** 18 }));

        const attackerBalance = (await contractAttack.getBalance.call()).toString();
        assert.equal(attackerBalance, 0);

        const balanceBeforeWithdraw = (await contractValueStore.balanceOf.call(accounts[1])).toString();
        assert.equal(balanceBeforeWithdraw, 10 ** 18);

        await contractValueStore.withdraw({ from: accounts[1] });
        const balanceAfterWithdraw = (await contractValueStore.balanceOf.call(accounts[1])).toString();
        assert.equal(balanceAfterWithdraw, 0);
    })
})