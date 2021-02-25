const HDWalletProvider = require("truffle-hdwallet-provider");

var privateKeyKovan = [
  "bba52d01339bf2b5eb918dbb927bc18ba9fb9c53412b31b54a5439f03b9c8fa2",
  "8e403ee8f426f7e2aebc7039180a40ca4c594e1de4fc027a9d770da1fe4e515a",
  "5657d6764f47b6808e9e38d9aa527ca291284ffb250c5e3aa58efd5bd6a1c3ac",
];
var providerURL = "https://kovan.infura.io/v3/6c7fceaca1a3433dad73cb537f87644b";

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
      gas: 6721974,
    },
    kovan: {
      // must be a thunk, otherwise truffle commands may hang in CI
      provider: () => new HDWalletProvider(privateKeyKovan, providerURL, 0, 3),
      network_id: "42",
      from: "0x56655FdfF46Ac28dB72603c5589A69B45B8604cc",
      skipDryRun: true,
    },
    testBSC: {
        // must be a thunk, otherwise truffle commands may hang in CI
        provider: () => new HDWalletProvider(privateKeyKovan, "https://data-seed-prebsc-2-s3.binance.org:8545/", 0, 3),
        network_id: "97",
        from: "0x56655FdfF46Ac28dB72603c5589A69B45B8604cc",
        skipDryRun: true,
    },
  },
  mocha: {
    useColors: true,
  },
  plugins: ["solidity-coverage"],
  compilers: {
    solc: {
      version: "0.6.12",
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  plugins: ["truffle-plugin-verify"],
  api_keys: {
    etherscan: "SAIKBWBDX8TMVPPFRJS92IX21EX2WG1VIF",
  },
};
