# Re-entrancy attack

## Setup

```bash
npm install -g truffle
npm install
```

## Comiple and deploy

```bash
truffle compile
truffle migrate --network development
```

## Test

```bash
truffle test test/1.attack.js 
truffle test test/2.attack_fail.js 
```

## References

- https://developers.polymath.network/polymath/api/reentrancyguard
- https://solidity-by-example.org/hacks/re-entrancy/