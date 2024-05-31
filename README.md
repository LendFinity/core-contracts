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

```bash
┌─────────────────────────────────────────┬──────────────────────────────────────────────┐
│ (index)                                 │ address                                      │
├─────────────────────────────────────────┼──────────────────────────────────────────────┤
│ ACLManager-Bitfinity                    │ '0x70F804060040bAb7E443b0F4334d356B7a6D4bAc' │
│ AToken-Bitfinity                        │ '0x26956F14dd56483e358C237fBF7a1729254b648D' │
│ AaveOracle-Bitfinity                    │ '0x14fB3B15bc6046aa94A704EC86Bf795D16d05424' │
│ BorrowLogic                             │ '0xFb3A7D4cdA276f3Ed98E4ACA2D6318BCd9751859' │
│ BridgeLogic                             │ '0x6d824682aA66da4e6738c6f3e16cC15fe9ce6F79' │
│ CAL-TestnetPriceAggregator-Bitfinity    │ '0x45D97250E4F261c4116b2ebDBA1b963e55B068d3' │
│ CHAP-TestnetPriceAggregator-Bitfinity   │ '0x6736422d082B6f12de3cCBE0D749CA2FF0Ea3964' │
│ COD-TestnetPriceAggregator-Bitfinity    │ '0xa10f1134b2E1Cdb364C77A172458b8AADD2f7FB5' │
│ CVA-TestnetPriceAggregator-Bitfinity    │ '0x3912aD5b13bdC3966c6d7552612Bbec462bC68c4' │
│ CYN-TestnetPriceAggregator-Bitfinity    │ '0x8be34D7830d446747B95Aa3ace0eaA4FF19b2007' │
│ ConfiguratorLogic                       │ '0x81D0043Fa848D07A36899388E46765aeA0e11a6b' │
│ DelegationAwareAToken-Bitfinity         │ '0x7Df54861967d020734Bcc3a115182E6e3E13316A' │
│ EModeLogic                              │ '0xCDa53a4bCEefbB873581d2206316a439a7498172' │
│ EmissionManager                         │ '0x1adc67Ca1ddb67A43772a29f79d58394A125C1b3' │
│ FNS-TestnetPriceAggregator-Bitfinity    │ '0xB56Ab229bD4d9459e61BC7Bb34E394Ed6c1a8e39' │
│ FlashLoanLogic                          │ '0xc9fb11FEEbf439cEb7E04D94FDd4A0314F01c597' │
│ INT-TestnetPriceAggregator-Bitfinity    │ '0x8484C6b4dEa25cc60c5d8bB0477af74Ba9C7eb64' │
│ IncentivesProxy                         │ '0x393ceb0230827066485267508A21Bf4A5f83C685' │
│ IncentivesV2-Implementation             │ '0x18a0503B232224B2f8954ADB2391B623Bc6A8960' │
│ LiquidationLogic                        │ '0xe14EbF1e8e8c39C1cf075fe1582f54392C97d8FE' │
│ Pool-Implementation                     │ '0x36A7f9ca3EBD83E00c1bca3A1db378bcF039Bf85' │
│ Pool-Proxy-Bitfinity                    │ '0xA7ed667bC90Dec516292A457C8387D336Cf68c07' │
│ PoolAddressesProvider-Bitfinity         │ '0x39833d01a18ebDB9f389F550182913ed884d44a3' │
│ PoolAddressesProviderRegistry           │ '0xd3aAA70197b22116c6732a964edC09C853AaC941' │
│ PoolConfigurator-Implementation         │ '0xA4e9C96b5FfA721223a3f360b9d4d25613c37Fc5' │
│ PoolConfigurator-Proxy-Bitfinity        │ '0x1F5030Be76606AC5649217Fe085fF71Ad410069f' │
│ PoolDataProvider-Bitfinity              │ '0xE076341997771AB62fe184d1101BCd78d18053e2' │
│ PoolLogic                               │ '0x406e5D7dDaA4029eB8B957aD7677c63e15c28AC7' │
│ ReserveStrategy-rateStrategyStableOne   │ '0x492f33E4701D9bd42a133c1b5AB1e4ac8333c590' │
│ ReserveStrategy-rateStrategyStableTwo   │ '0x867e1Ccb964654A1074627b0C6557b0ccEb869C4' │
│ ReserveStrategy-rateStrategyVolatileOne │ '0xe7fA8a2D1DD0Bd3F766e04ccFC50061891A4641e' │
│ ReservesSetupHelper                     │ '0xFae8bf5E0bCBdcc44f3E13966C8c3F16917463bE' │
│ StableDebtToken-Bitfinity               │ '0xBEC054144d241EE23834D352E3a2033fC9092e2a' │
│ SupplyLogic                             │ '0xdB52E4853b6A40D2972E6797E0BDBDb3eB761966' │
│ TUSDT-TestnetPriceAggregator-Bitfinity  │ '0xB49BafEc7095d2d337A9e7DaaAE2DAA0F73d5b5A' │
│ Treasury-Controller                     │ '0x1EC66e52D13c18809F023948f1ae053025D2c969' │
│ Treasury-Implementation                 │ '0x4417E9B86Be5d09331eF8B5a98Af4589228F476E' │
│ TreasuryProxy                           │ '0x2EeA9517B018B2f63072a9729ceC3EE524809460' │
│ VariableDebtToken-Bitfinity             │ '0x899AA352C85DBb7C579e6DfE56f875B42bfe2C36' │
│ WBFT-TestnetPriceAggregator-Bitfinity   │ '0x45d736c32e64AC430c091b419B83E40F14F70a80' │
│ WBFT-AToken-Bitfinity                   │ '0x090827ea2AA15696681d6095ef5eD330E3b0E743' │
│ WBFT-VariableDebtToken-Bitfinity        │ '0x995E5E6ff27D44d69536321e961A44A43be71191' │
│ WBFT-StableDebtToken-Bitfinity          │ '0xFBc30039C2D1143e46b3E446f580CF67828183e9' │
│ CHAP-AToken-Bitfinity                   │ '0xa7647cD01482492017c6Bdbd34f764C871C8f01B' │
│ CHAP-VariableDebtToken-Bitfinity        │ '0xe3718389e4e8137c0D288e84D5fbcBC4Ed621dF0' │
│ CHAP-StableDebtToken-Bitfinity          │ '0x2b204Dab8833C235e3738D427b8C8c0f102E6117' │
│ INT-AToken-Bitfinity                    │ '0xc57C1Eeb56BcAb0Cc9019434E87cc8fD461d2B23' │
│ INT-VariableDebtToken-Bitfinity         │ '0x654F1962E870dDca093C7C46E5F6e4264ABFf372' │
│ INT-StableDebtToken-Bitfinity           │ '0xA2E663f976bd7aFbD4F497554675771cBf487DA9' │
│ COD-AToken-Bitfinity                    │ '0xfC0058066F9C89d48eF5985D0913ED8BB442DDe8' │
│ COD-VariableDebtToken-Bitfinity         │ '0xD55A5c7fF584B9340AB24df1E74C72de94621Aa6' │
│ COD-StableDebtToken-Bitfinity           │ '0xF082dDD5cc5D0a9Cb5CadfeF39e54B976F64B289' │
│ CVA-AToken-Bitfinity                    │ '0x92ef6b415Bc33bb3896984B7d870DE705D61e2ce' │
│ CVA-VariableDebtToken-Bitfinity         │ '0x5328e7abAc3AF5FB40b8D2EAF05F9D654da00432' │
│ CVA-StableDebtToken-Bitfinity           │ '0x1806A589DBFfF506F8FF22Ba0d0e7Af12313641E' │
│ CYN-AToken-Bitfinity                    │ '0xCaC121dd65ed6C4Fe5f204E11f389d9171cEDAfE' │
│ CYN-VariableDebtToken-Bitfinity         │ '0x745183796f56caF9563Df2e7E5DC20767C93e29A' │
│ CYN-StableDebtToken-Bitfinity           │ '0x266A4f1Bd1Da55c00FD23d9C0B695fCdF18446eD' │
│ CAL-AToken-Bitfinity                    │ '0x67aaDE9888722441AC589b0dfF19EDF838B3C357' │
│ CAL-VariableDebtToken-Bitfinity         │ '0x0066286aE9F1B2C02F4E3b79A8cC4D10bf7FC56d' │
│ CAL-StableDebtToken-Bitfinity           │ '0xE79d45c9ecE8e6F7a3C85245D74ab762132678b6' │
│ TUSDT-AToken-Bitfinity                  │ '0x4bcF8C9C372159c28FA005895Fe22D6D67341416' │
│ TUSDT-VariableDebtToken-Bitfinity       │ '0x4b46Eed3944278414ABf9dB60a2B57f75C29B4d2' │
│ TUSDT-StableDebtToken-Bitfinity         │ '0xF3B7e372d811a473BF86814285Be31Fc33707CFC' │
│ FNS-AToken-Bitfinity                    │ '0xf43181E138D142505330d379E0163CA9d8C5358f' │
│ FNS-VariableDebtToken-Bitfinity         │ '0x6Ec82F91e7589A73cdcd7f646A0C0fb13b3d4a41' │
│ FNS-StableDebtToken-Bitfinity           │ '0x7D1Dd1daCD45AE2d0130DE0D71C4BF6895d80ff1' │
│ WrappedTokenGatewayV3                   │ '0x93691c0Cb6F6bb785Ec2405E98aC7B4A2BcF752A' │
│ WalletBalanceProvider                   │ '0x1a363a3e66b3fcF7Ae8d10222620a070D751e38b' │
│ UiIncentiveDataProviderV3               │ '0x4f278E2Ec87e266E90FAeb5595212EadEaC45e1D' │
│ UiPoolDataProviderV3                    │ '0xE65FA718Fe0D7683eE6A4208D40e594F669A11A1' │
└─────────────────────────────────────────┴──────────────────────────────────────────────┘
```
