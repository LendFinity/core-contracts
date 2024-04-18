# Lendfinity Protocol

This repository contains the smart contracts source code and markets configuration for Lendfinity V3. The repository uses Docker Compose and Hardhat as development environment for compilation, testing and deployment tasks.

## What is Lendfinity?

Lendfinity is a decentralized non-custodial liquidity markets protocol where users can participate as suppliers or borrowers. Suppliers provide liquidity to the market to earn a passive income, while borrowers are able to borrow in an overcollateralized (perpetually) or undercollateralized (one-block liquidity) fashion.

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

Testnet addresses:

```bash
┌─────────────────────────────────────────┬──────────────────────────────────────────────┐
│ (index)                                 │ address                                      │
├─────────────────────────────────────────┼──────────────────────────────────────────────┤
│ PoolAddressesProviderRegistry           │ '0xD83C9f1B0DaFb1992eF92ac62D6509e54AD4eD48' │
│ SupplyLogic                             │ '0x0d6e43d4d7944408d9a5A10BC57B4348d61cD764' │
│ BorrowLogic                             │ '0xc90C13734D20e27904dF248FB850f50C81CE3642' │
│ LiquidationLogic                        │ '0xFCc4Ba754Ae127396D3c6dCA507389b5A5b6EFAe' │
│ EModeLogic                              │ '0x473A31861aB89d5D7a78E7efc57ad31d84ED5343' │
│ BridgeLogic                             │ '0xBd57b20c3671cDb9a6bD2d847bC3C33e441B8a02' │
│ ConfiguratorLogic                       │ '0x3A25408D952F91e42F39587820bEe5f051f4556c' │
│ FlashLoanLogic                          │ '0xA6407325fF7DAAB36D20992dADC031c82D1C4390' │
│ PoolLogic                               │ '0xE65B75e7A8de220bcfec86F58c4c25A62aB7CD9b' │
│ TreasuryProxy                           │ '0x1Fb0D426927Dab092Def63b73E1397b3F29E7b33' │
│ Treasury-Controller                     │ '0xB4059a6808Af368A69d12FBbD104Bb6B9c37e629' │
│ Treasury-Implementation                 │ '0xe4FEed16F54b4244C174b408Ba3B5F1f19DD1E4D' │
│ PoolAddressesProvider-Bitfinity         │ '0xA388228A1fA75a5F5844226E2874d7EE4d940256' │
│ PoolDataProvider-Bitfinity              │ '0x329058C12E8B269BFA0896c8705b427c5Dd26b96' │
│ Pool-Implementation                     │ '0x514b34d5c6e2e29502FB302aCD09730B5C298070' │
│ PoolConfigurator-Implementation         │ '0x807951d1F003c2161CdA995168383b54127755d5' │
│ ReservesSetupHelper                     │ '0x4D5D3FaE9b08a4FA2aEB9Bc0d86E3dB3b3126438' │
│ ACLManager-Bitfinity                    │ '0x0CA1caF038546b20380B2bd88fbcf604D5066628' │
│ AaveOracle-Bitfinity                    │ '0x2C328D592819524F741A88A18572372CCE196782' │
│ Pool-Proxy-Bitfinity                    │ '0xD8B9c8934049Ed80f497489f9eE5139aa044FC0e' │
│ PoolConfigurator-Proxy-Bitfinity        │ '0x4f397754f18B5d54E4BdfB34DaCfb63E4c61D4aB' │
│ EmissionManager                         │ '0x43f48B2eAF8a3f2F573136F25C1aE3C6924F1E3e' │
│ IncentivesV2-Implementation             │ '0x47CD4297b04621b2CE041eAe635416e1b65f147f' │
│ IncentivesProxy                         │ '0x5d0352475e1884D72169d0ccf91272321787BE61' │
│ AToken-Bitfinity                        │ '0xD1586f4624775920121A0D58A785F46e9f91500d' │
│ DelegationAwareAToken-Bitfinity         │ '0x1D0DC97cdD22b8D6D763083722962418eae8F2Ff' │
│ StableDebtToken-Bitfinity               │ '0xe28041BF5e9f8fC51dc84bFc39757557a70dC860' │
│ VariableDebtToken-Bitfinity             │ '0x549286e5CdafFDAb91b78b0ee8A670Af12E35F23' │
│ ReserveStrategy-rateStrategyVolatileOne │ '0x9505E8B8546cC9015B2c015826d25821CC48C153' │
│ ReserveStrategy-rateStrategyStableOne   │ '0xc9D18D86f1c101Dc87A09e683875004A02a67607' │
│ ReserveStrategy-rateStrategyStableTwo   │ '0xB4f34879C2c3db50934E5069CE01fD5EcE3Aa051' │
│ CHAP-AToken-Bitfinity                   │ '0x0457d47d212C1E19406b8BfAbAB511D90F976d77' │
│ CHAP-VariableDebtToken-Bitfinity        │ '0xFbEDa1361027CBA3752F2d9aC7153835bC2fb8ca' │
│ CHAP-StableDebtToken-Bitfinity          │ '0xc2F17c45b74022D965DD2BdCB2599867D00d127A' │
│ WBFT-AToken-Bitfinity                   │ '0x523d3b74A239948b2C0f9a752d0F41440Ad5599c' │
│ WBFT-VariableDebtToken-Bitfinity        │ '0x5a19A0E7f2fe439ae2BeF2CcBCF494a21e990713' │
│ WBFT-StableDebtToken-Bitfinity          │ '0xf6020D99033ee977B9E218201636ba4983CC5ca2' │
│ COD-AToken-Bitfinity                    │ '0xdA9ed2ffD6bfB88957b7E5dBE27201382cC54200' │
│ COD-VariableDebtToken-Bitfinity         │ '0x785aE431B0258148Ecdaf14A6A5269eF728C2eb1' │
│ COD-StableDebtToken-Bitfinity           │ '0xFc630bf5A36a0b649F1fb393e298E1527DAA919f' │
│ CVA-AToken-Bitfinity                    │ '0x165f56c2465490C46f1CE85e4aC1BC3d8fBf7251' │
│ CVA-VariableDebtToken-Bitfinity         │ '0x7AAd53c0f69a9Da78c65214b54bc540A9fA0EE70' │
│ CVA-StableDebtToken-Bitfinity           │ '0xfDf2D66ee3AD4142d9e1Cac9fA5E1Dbe56Ab426C' │
│ CYN-AToken-Bitfinity                    │ '0x24174Cc4e6aE73e7e98AC62d711e1BAbc5Aa48E8' │
│ CYN-VariableDebtToken-Bitfinity         │ '0xA3C75a621d12f7FbDE3Fe09aE3bA22081AfAA46D' │
│ CYN-StableDebtToken-Bitfinity           │ '0xBb865BCe5e00B48318ce387895F906325a812A14' │
│ CAL-AToken-Bitfinity                    │ '0x9A211F60635c9E0040722975182d0cCf07E9E509' │
│ CAL-VariableDebtToken-Bitfinity         │ '0xbe3fE74Bf5b79C0e572F73C5EC38B86ff6789530' │
│ CAL-StableDebtToken-Bitfinity           │ '0xCDd8D8324A6980CBe00Db23FBB826F312Efac2dC' │
│ FNS-AToken-Bitfinity                    │ '0xE5A372AE450bca34754801EeAA0e0e70E6fdF1A9' │
│ FNS-VariableDebtToken-Bitfinity         │ '0x2cb71BE45ea388f79ce7361d2aA693FdA2b23C20' │
│ FNS-StableDebtToken-Bitfinity           │ '0xE07D02788c364a38387c3De93393b9434Cf8d912' │
│ INT-AToken-Bitfinity                    │ '0x91FCc9F77F90906dAFd26c8435a04d1D4Dd0Ea11' │
│ INT-VariableDebtToken-Bitfinity         │ '0x981d467c2B0d32628c3808DA26a7A1E9Aa7bb1b5' │
│ INT-StableDebtToken-Bitfinity           │ '0x9ba575E7F292f72F47f601b2814ba4aCA6faDd32' │
│ TUSDT-AToken-Bitfinity                  │ '0x1f508F593C20F6aECD0eD525c9Af01D465C13377' │
│ TUSDT-VariableDebtToken-Bitfinity       │ '0x05E0a82dF31839ceE2a9e956a01d47B7BA23c64b' │
│ TUSDT-StableDebtToken-Bitfinity         │ '0x02683BC8A310787EA7b14534cF612B19aaBD378a' │
│ WrappedTokenGatewayV3                   │ '0x81B2b28442e743954C8678b0d2e4be396976F561' │
│ WalletBalanceProvider                   │ '0xfd3Cb0fFE63B1fDBBE257b9AdFCCC065f300C829' │
│ UiIncentiveDataProviderV3               │ '0x361Da44d0B5dAcC8F1c375093f5a7c90dfdA24A3' │
│ UiPoolDataProviderV3                    │ '0x7f3fF452D3da0EAD3ce227eB4A6c84E896685C3C' │
└─────────────────────────────────────────┴──────────────────────────────────────────────┘
```
