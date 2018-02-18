require('babel-register')({
  ignore: /node_modules\/(?!zeppelin-solidity)/
});
require('babel-polyfill');

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      gas: 6721975,
      gasPrice: 4200000,
      network_id: "*" // Match any network id
    },
  },
  solc: {
    optimizer: {
      enabled: true,
      runs: 200
    }
  }
};
