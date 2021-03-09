# Sessions

A session code is specified in the [Trade](./command-trade-insert.md) message to flag the transaction as occuring during a particular trading or settlement regime.

The codes are specific to each venue with most exchanges offering pre-market, regular, after-market, and auction sessions.

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