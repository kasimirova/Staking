import * as conf from "../config";
import { task } from "hardhat/config";

task("approve", "Approve")
    .addParam("spender", "Who's gonna spend the money")
    .addParam("value", "Amount of money")
    .setAction(async (taskArgs, { ethers }) => {
    let ERC20 = await ethers.getContractAt("ERC20", conf.LP_ADDRESS);
    await ERC20.approve(taskArgs.spender, taskArgs.value);
  });

