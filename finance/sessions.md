# Session Stage

A session stage is specified in the [Trade](./command-trade-insert.md) command to mark the transaction executed during a particular trading or settlement regime.

The codes are specific to each trading venue.

| Code | Name | Description |
|---|---|---|
| `NA` | `NON_ACTIVE` | Non-Active |
| `S` | `OPENING_AUCTION_CALL` | Opening Auction Call |
| `O` | `OPENING_AUCTION` | Opening Auction Crossing |
| `N` | `REGULAR` | Regular Trading |
| `L` | `CLOSING_AUCTION` | Closing Auction |
| `E` | `CLOSING_AUCTION_POST_CROSSING` | Closing Auction Post-Crossing |
| `C` | `CLOSED` | Closed, or End-of-Day |
| `M` | `PRE_MARKET` | Pre-market Trade |
| `V` | `AFTER_MARKET` | After-market Trade |
| `X` | `EXTENDED_TRADING` | Extended Period Trade |