const Attack = artifacts.require("Attack");
const Attack2 = artifacts.require("Attack2");

const Vault = artifacts.require("Vault");
const VaultSecured = artifacts.require("VaultSecured");

module.exports = async function (deployer) {
    await deployer.deploy(Vault);
    const vault = await Vault.deployed();
    await deployer.deploy(Attack, vault.address);

    await deployer.deploy(VaultSecured);
    const vault2 = await VaultSecured.deployed();

    await deployer.deploy(Attack2, vault2.address);

};
