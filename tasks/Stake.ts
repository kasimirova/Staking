import * as conf from "../config";
import { task } from "hardhat/config";
task("stake", "Stake tokens")
    .addParam("amount", "Amount of money to stake")
    .setAction(async (taskArgs, { ethers }) => {
    let Staking = await ethers.getContractAt("Staking", conf.CONTRACT_ADDRESS);
    await Staking.stake(taskArgs.amount);
  });