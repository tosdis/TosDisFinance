const HDWalletProvider = require("truffle-hdwallet-provider");

var privateKeyKovan = [
  "",
  "",
  "",
];
var providerURL = "https://kovan.infura.io/v3/9aa3d95b3bc440fa88ea12eaa4456161";

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
      from: "",
      skipDryRun: true,
    },
    testBSC: {
        // must be a thunk, otherwise truffle commands may hang in CI
        provider: () => new HDWalletProvider(privateKeyKovan, "https://data-seed-prebsc-2-s3.binance.org:8545/", 0, 3),
        network_id: "97",
        from: "",
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
    etherscan: "",
  },
};
