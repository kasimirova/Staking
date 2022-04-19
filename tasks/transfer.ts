import * as conf from "../config";
import { task } from "hardhat/config";

task("transfer", "Transfer")
    .addParam("to", "Who's gonna receive the money")
    .addParam("value", "Amount of money")
    .setAction(async (taskArgs, { ethers }) => {
    let ERC20 = await ethers.getContractAt("ERC20", conf.REWARD_ADDRESS);
    await ERC20.transfer(taskArgs.to, taskArgs.value);
  });
