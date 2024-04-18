# Bitfinity Protocol

This repository contains the smart contracts source code and markets configuration for Bitfinity V3. The repository uses Docker Compose and Hardhat as development environment for compilation, testing and deployment tasks.

## What is Bitfinity?

Bitfinity is a decentralized non-custodial liquidity markets protocol where users can participate as suppliers or borrowers. Suppliers provide liquidity to the market to earn a passive income, while borrowers are able to borrow in an overcollateralized (perpetually) or undercollateralized (one-block liquidity) fashion.

## Documentation

See the link to the technical paper or visit the Aave Developer docs

- [Technical Paper](./techpaper/Aave_V3_Technical_Paper.pdf)

- [Developer Documentation](https://docs.aave.com/developers/)

## Audits and Formal Verification

You can find all audit reports under the audits folder

V3.0.1 - December 2022

- [PeckShield](./audits/09-12-2022_PeckShield_AaveV3-0-1.pdf)
- [SigmaPrime](./audits/23-12-2022_SigmaPrime_AaveV3-0-1.pdf)

V3 Round 1 - October 2021

- [ABDK](./audits/27-01-2022_ABDK_AaveV3.pdf)
- [OpenZeppelin](./audits/01-11-2021_OpenZeppelin_AaveV3.pdf)
- [Trail of Bits](./audits/07-01-2022_TrailOfBits_AaveV3.pdf)
- [Peckshield](./audits/14-01-2022_PeckShield_AaveV3.pdf)

V3 Round 2 - December 2021

- [SigmaPrime](./audits/27-01-2022_SigmaPrime_AaveV3.pdf)

Formal Verification - November 2021-January 2022

- [Certora](./certora/Aave_V3_Formal_Verification_Report_Jan2022.pdf)

## Getting Started

You can install `@aave/core-v3` as an NPM package in your Hardhat or Truffle project to import the contracts and interfaces:

`npm install @aave/core-v3`

Import at Solidity files:

```
import {IPool} from "@aave/core-v3/contracts/interfaces/IPool.sol";

contract Misc {

  function supply(address pool, address token, address user, uint256 amount) public {
    IPool(pool).supply(token, amount, user, 0);
    {...}
  }
}
```

The JSON artifacts with the ABI and Bytecode are also included in the bundled NPM package at `artifacts/` directory.

Import JSON file via Node JS `require`:

```
const PoolV3Artifact = require('@aave/core-v3/artifacts/contracts/protocol/pool/Pool.sol/Pool.json');

// Log the ABI into console
console.log(PoolV3Artifact.abi)
```

## Setup

The repository uses Docker Compose to manage sensitive keys and load the configuration. Prior to any action like test or deploy, you must run `docker-compose up` to start the `contracts-env` container, and then connect to the container console via `docker-compose exec contracts-env bash`.

Follow the next steps to setup the repository:

- Install `docker` and `docker-compose`
- Create an environment file named `.env` and fill the next environment variables

```
# Add Alchemy or Infura provider keys, alchemy takes preference at the config level
ALCHEMY_KEY=""
INFURA_KEY=""


# Optional, if you plan to use Tenderly scripts
TENDERLY_PROJECT=""
TENDERLY_USERNAME=""

```

## Test

You can run the full test suite with the following commands:

```
# In one terminal
docker-compose up

# Open another tab or terminal
docker-compose exec contracts-env bash

# A new Bash terminal is prompted, connected to the container
npm run test
```


## Adresses

### Deployments

```bash
┌─────────────────────────────────────────┬──────────────────────────────────────────────┐
│ (index)                                 │ address                                      │
├─────────────────────────────────────────┼──────────────────────────────────────────────┤
│ PoolAddressesProviderRegistry           │ '0x5A61c51C6745b3F509f4a1BF54BFD04e04aF430a' │
│ SupplyLogic                             │ '0x832092FDF1D32A3A1b196270590fB0E25DF129FF' │
│ BorrowLogic                             │ '0xe3e4631D734e4b3F900AfcC396440641Ed0df339' │
│ LiquidationLogic                        │ '0x8729c0238b265BaCF6fE397E8309897BB5c40473' │
│ EModeLogic                              │ '0xDf795df2e0ad240a82d773DA01a812B96345F9C5' │
│ BridgeLogic                             │ '0x0Ff833129533546D96A5847C22b57AACccD00FD5' │
│ ConfiguratorLogic                       │ '0x26320DE63415e5AAf2BA617D97C39444eDb6F741' │
│ FlashLoanLogic                          │ '0x2ac430E52F47420A00984E11Ef0DDba80652419a' │
│ PoolLogic                               │ '0x2550d6424b46f78F4E31F1CCf88Da26dda7826C6' │
│ TreasuryProxy                           │ '0xDb731EaaFA0FFA7854A24C2379585a85D768Ed5C' │
│ Treasury-Controller                     │ '0x335796f7A0F72368D1588839e38f163d90C92C80' │
│ Treasury-Implementation                 │ '0xa86582Ad5E80abc19F95f8A9Fb3905Cda0dAbd59' │
│ Faucet-Aave                             │ '0xA002B84Ca3c9e8748209F286Ecf99300CA50161A' │
│ PoolAddressesProvider-Aave              │ '0xc565EB7363769f8ffAe0005285ccD854c631A0a0' │
│ PoolDataProvider-Aave                   │ '0xdA796117bF6905DD8DB2fF1ab4397f6d2c4ADda3' │
│ DAI-TestnetPriceAggregator-Aave         │ '0x88777418972fB3F58489303d763d4DaF398A6527' │
│ LINK-TestnetPriceAggregator-Aave        │ '0x4728aF32823cf144586DaB95632156cC81BB0203' │
│ USDC-TestnetPriceAggregator-Aave        │ '0x37d0eD258f37a966f33b75b5AE7486917a0ae614' │
│ WBTC-TestnetPriceAggregator-Aave        │ '0x294c69bD8415219b41B68a2f065DeABB950dd489' │
│ WETH-TestnetPriceAggregator-Aave        │ '0x48288D0e3079A03f6EC1846554CFc58C2696Aaee' │
│ USDT-TestnetPriceAggregator-Aave        │ '0x74Ce26A2e4c1368C48A0157CE762944d282896Db' │
│ AAVE-TestnetPriceAggregator-Aave        │ '0x7c77704007C9996Ee591C516f7319828BA49d91E' │
│ EURS-TestnetPriceAggregator-Aave        │ '0x676F5F71DAE1C83Dc31775E4c61212bC9e799d9C' │
│ Pool-Implementation                     │ '0x081F08945fd17C5470f7bCee23FB57aB1099428E' │
│ PoolConfigurator-Implementation         │ '0x5EdB3Ff1EA450d1FF6d614F24f5C760761F7f688' │
│ ReservesSetupHelper                     │ '0x98F74b7C96497070ba5052E02832EF9892962e62' │
│ ACLManager-Aave                         │ '0xF47e3B0A1952A81F1afc41172762CB7CE8700133' │
│ AaveOracle-Aave                         │ '0xD6b8Eb34413f07a1a67A469345cFEa6633efd58d' │
│ Pool-Proxy-Aave                         │ '0xC898bbd6B62e871Ca3Ab593A7fb92822fb65e1aF' │
│ PoolConfigurator-Proxy-Aave             │ '0x6AF8E91FC971D5c061b6D6edfa43E07c9c481873' │
│ EmissionManager                         │ '0x934A389CaBFB84cdB3f0260B2a4FD575b8B345A3' │
│ IncentivesV2-Implementation             │ '0xc91B651f770ed996a223a16dA9CCD6f7Df56C987' │
│ IncentivesProxy                         │ '0xcFd23a2044E8475C9c9166B47b3ba72F3690A08E' │
│ PullRewardsTransferStrategy             │ '0x10d16E2A026C4b5264A2aAC51cA65749cDf2037E' │
│ AToken-Aave                             │ '0x4B7099FD879435a087C364aD2f9E7B3f94d20bBe' │
│ DelegationAwareAToken-Aave              │ '0x98721EFD3D09A7Ae662C4D63156286DF673FC50B' │
│ StableDebtToken-Aave                    │ '0x240A60DC5e0B9013Cb8CF39aa6f9dDd8f25E40D2' │
│ VariableDebtToken-Aave                  │ '0xb69FC79100eDd058f9c96c0a13C80124aC1a7D77' │
│ ReserveStrategy-rateStrategyVolatileOne │ '0x757Fd23a0fDF9F9d2786f62f96f02Db4D096d10A' │
│ ReserveStrategy-rateStrategyStableOne   │ '0x7930AC7ddD1e35fD4b25230121A9C45923894e67' │
│ ReserveStrategy-rateStrategyStableTwo   │ '0x4a680B00eEacbcCA480eB9aB57161A7B08A8F0Ba' │
│ DAI-AToken-Aave                         │ '0x09ceEBBc3B3674198c066e4cbF7B6988DF1C8317' │
│ DAI-VariableDebtToken-Aave              │ '0x0CfEb3BDBA8b4Ec39B80169f44bF65E30ee20B47' │
│ DAI-StableDebtToken-Aave                │ '0xb8ECd991e7445355FCA3a97787E6200cF134c007' │
│ LINK-AToken-Aave                        │ '0x97f2faE1B8e180cb3E249a76ECb66F3C42567aCe' │
│ LINK-VariableDebtToken-Aave             │ '0xbA90B51dA769d46bb7394084109889C8E0061769' │
│ LINK-StableDebtToken-Aave               │ '0x2A4d53F4f5E50ab59E7f1e3E2A2082e3C1c95e8d' │
│ USDC-AToken-Aave                        │ '0x72f8Bf120aB1982119b7f6542756dd21ac552773' │
│ USDC-VariableDebtToken-Aave             │ '0xc9407Cc32DF0666d671aC94a0A6Ac337391E042E' │
│ USDC-StableDebtToken-Aave               │ '0x982226633315905D06c77a7306b8D860cBb1EAD5' │
│ WBTC-AToken-Aave                        │ '0x5d6915cBB8973f339bdFd87C2A9759f99F212408' │
│ WBTC-VariableDebtToken-Aave             │ '0xfa436251cC1484bFB6e6A36E435383873227e5fc' │
│ WBTC-StableDebtToken-Aave               │ '0x5CD0a3E28F25CFCc0F322D5A36030f832BCC23d5' │
│ WETH-AToken-Aave                        │ '0x261c6766844C31E602c183827ee425361eA76e4b' │
│ WETH-VariableDebtToken-Aave             │ '0x13C0895577aca4ac519232d1609b7Fe96F909f5f' │
│ WETH-StableDebtToken-Aave               │ '0xE5EFA7571116F75CCd2ce494B01Cb952Fa1b59f1' │
│ USDT-AToken-Aave                        │ '0x63d4Ca3767eD5ce32e5081389B875846EF859335' │
│ USDT-VariableDebtToken-Aave             │ '0x6f0b8815710C0c233De30018Cf88741d625190da' │
│ USDT-StableDebtToken-Aave               │ '0x7deD5cE031C3c6026c7d8C07438c92765302c3b0' │
│ AAVE-AToken-Aave                        │ '0x40d2e0911Cb1799eaB65189e934ea2cEd0FaFCA3' │
│ AAVE-VariableDebtToken-Aave             │ '0xcf71C876f4da42cb5793Dd2a449a5405A1454243' │
│ AAVE-StableDebtToken-Aave               │ '0x5ce0c570F363eB534A9177F4b49A1a0a9b7DcE68' │
│ EURS-AToken-Aave                        │ '0x58cF7330cb4Dd3d509cEd5Bf0f5a35457E4Ff833' │
│ EURS-VariableDebtToken-Aave             │ '0xA8814BD5b419c1bFA1d88e70b4eC0d8412750aA2' │
│ EURS-StableDebtToken-Aave               │ '0x6e894F9C5EA573cD7439Df1D8FEf39b23cE90257' │
│ MockFlashLoanReceiver                   │ '0x76C9284988B979f750BC504173ADc08E00c04398' │
│ WrappedTokenGatewayV3                   │ '0x2F94C3189edA0e357B23048aEc736F323Ac431f6' │
│ WalletBalanceProvider                   │ '0x9118EA4a52C6c7873729c8d8702cCd85E573f9E9' │
│ UiIncentiveDataProviderV3               │ '0x1A223F93131cD7d898c28Ee0B905C39Db474FA08' │
│ UiPoolDataProviderV3                    │ '0x77e6Bd5c1988d8d766698F9CeEa5C24559b999f8' │
└─────────────────────────────────────────┴──────────────────────────────────────────────┘
```

### Mintable Reserves and Rewards

```bash
┌────────────────────────────────┬──────────────────────────────────────────────┐
│ (index)                        │ address                                      │
├────────────────────────────────┼──────────────────────────────────────────────┤
│ DAI-TestnetMintableERC20-Aave  │ '0x4633394E4Fd1175273845d7F0d6A5F613309d384' │
│ LINK-TestnetMintableERC20-Aave │ '0x039d7496e432c6Aea4c24648a59318b3cbe09942' │
│ USDC-TestnetMintableERC20-Aave │ '0xbF97DEfeb6a387215E3e67DFb988c675c9bb1a29' │
│ WBTC-TestnetMintableERC20-Aave │ '0xaE7b7A1c6C4d859e19301ccAc2C6eD28A4C51288' │
│ WETH-TestnetMintableERC20-Aave │ '0xe9CD84fe4ddfB0f016e3264791923902906753Bd' │
│ USDT-TestnetMintableERC20-Aave │ '0x7722f5d7964a04672761cdfdC7c17B7Ac8f197b7' │
│ AAVE-TestnetMintableERC20-Aave │ '0xeA2e668d430e5AA15babA2f5c5edfd4F9Ef6EB73' │
│ EURS-TestnetMintableERC20-Aave │ '0xA7240bcff60Eef40F31B8eD5d921BaD6DB13B199' │
└────────────────────────────────┴──────────────────────────────────────────────┘
```
