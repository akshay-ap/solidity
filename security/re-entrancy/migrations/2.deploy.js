const ValueStore = artifacts.require("ValueStore");
const ValueStoreSecure1 = artifacts.require("ValueStoreSecure1");
const ValueStoreSecure2 = artifacts.require("ValueStoreSecure2");

const Attack = artifacts.require("Attack");

module.exports = async function (deployer) {
    await deployer.deploy(ValueStore);
    await deployer.deploy(ValueStoreSecure1);
    await deployer.deploy(ValueStoreSecure2);

    const vDeployed = await ValueStore.deployed();

    await deployer.deploy(Attack, vDeployed.address);
    await deployer.deploy(Attack, vDeployed.address);
};