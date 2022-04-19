import * as conf from "../config";
import { task } from "hardhat/config";

task("claim", "Claim reward")
    .setAction(async (taskArgs, { ethers }) => {
    let Staking = await ethers.getContractAt("Staking", conf.CONTRACT_ADDRESS);
    await Staking.claim();
  });