const AMM = artifacts.require("AMM");
const ERC20 = artifacts.require("ERC20");
const Token = artifacts.require("Token");
const truffleAssert = require("truffle-assertions");

contract("AMM", (accounts) => {
    it("Should deploy pool", async () => {

        const user1 = accounts[0];
        const user2 = accounts[1];

        console.log("Deploying contracts");

        const erc20Token0 = await Token.new("token0", "T0", { from: user1 });
        const erc20Token1 = await Token.new("token1", "T1", { from: user1 });
        const amm = await AMM.new(erc20Token0.address, erc20Token1.address, { from: user1 });

        console.log("Approving tokens");
        await erc20Token0.approve(amm.address, 1000, { from: user1 });
        await erc20Token1.approve(amm.address, 1000, { from: user1 });

        console.log("Adding liquidity");
        await amm.addLiquidity(1000, 1000, { from: user1 });

        console.log("Sending tokens to user2");
        await erc20Token0.transfer(user2, 100);

        console.log("Swap tokens");
        await erc20Token0.approve(amm.address, 100, { from: user2 });
        await amm.swap(erc20Token0.address, 100, { from: user2 });

        const user2Token0balanceAfterTransfer = (await erc20Token0.balanceOf.call(user2)).toString();
        const user2Token1balanceAfterTransfer = (await erc20Token1.balanceOf.call(user2)).toString();

        console.log("User 2: Balance after swap", user2Token0balanceAfterTransfer, user2Token1balanceAfterTransfer);
        expect(user2Token1balanceAfterTransfer).to.equal("90");

        const ammToken0balanceAfterTransfer = (await erc20Token0.balanceOf.call(amm.address)).toString();
        const ammToken1balanceAfterTransfer = (await erc20Token1.balanceOf.call(amm.address)).toString();

        console.log("AMM: Balance after swap", ammToken0balanceAfterTransfer, ammToken1balanceAfterTransfer);
        expect(ammToken0balanceAfterTransfer).to.equal("1100");
        expect(ammToken1balanceAfterTransfer).to.equal("910");

    });
});