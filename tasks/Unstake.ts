import * as conf from "../config";
import { task } from "hardhat/config";
task("unstake", "Unstake tokens")
    .setAction(async (taskArg, { ethers }) => {
    let Staking = await ethers.getContractAt("Staking", conf.CONTRACT_ADDRESS);
    await Staking.unstake();
  });