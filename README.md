# Deckxchange Smart Contract

## Overview

**Deckxchange** is a blockchain-based card trading game implemented in the Clarity language. The smart contract allows users to create, trade, and battle with unique collectible cards. Each card is represented as a non-fungible token (NFT) and includes customizable attributes such as attack, defense, rarity, and element type. The contract supports both market-driven trades and direct player-to-player exchanges.

## Features

1. **Card Creation**  
   - Admins can mint new cards with unique attributes.  
   - Each card has a unique `card-id` and customizable properties.  

2. **Card Trading**  
   - Players can list their cards on a marketplace for other players to purchase using STX tokens.  
   - Cards can be unlisted from the marketplace at any time by their owners.  

3. **Direct Trading**  
   - Players can directly exchange cards with other players without involving the marketplace.  

4. **Read-Only Queries**  
   - Retrieve details about specific cards, including attributes and ownership.  
   - Check marketplace listings for cards available for purchase.

## Smart Contract Functions

### Admin Functions

- **`(create-card name attack defense rarity element)`**  
  Creates a new card with specified attributes.  
  - **Parameters**:  
    - `name`: The name of the card (string, max 50 characters).  
    - `attack`: Attack value of the card (uint).  
    - `defense`: Defense value of the card (uint).  
    - `rarity`: Rarity level of the card (uint).  
    - `element`: Element type of the card (string, max 20 characters).  
  - **Returns**: The unique ID of the newly created card.  
  - **Access Control**: Only the contract owner can invoke this function.

---

### Trading Functions

- **`(list-card card-id price)`**  
  Lists a card on the marketplace with a specified price.  
  - **Parameters**:  
    - `card-id`: The unique ID of the card (uint).  
    - `price`: Listing price in STX (uint).  
  - **Returns**: `true` if successful.  

- **`(unlist-card card-id)`**  
  Removes a card from the marketplace.  
  - **Parameters**:  
    - `card-id`: The unique ID of the card (uint).  
  - **Returns**: `true` if successful.  

- **`(buy-card card-id)`**  
  Purchases a listed card from the marketplace.  
  - **Parameters**:  
    - `card-id`: The unique ID of the card (uint).  
  - **Returns**: `true` if successful.  

- **`(trade-cards send-card-id receive-card-id counterparty)`**  
  Trades a card with another player directly.  
  - **Parameters**:  
    - `send-card-id`: The card ID being offered (uint).  
    - `receive-card-id`: The card ID expected in return (uint).  
    - `counterparty`: Principal of the other player.  
  - **Returns**: `true` if successful.  

---

### Read-Only Functions

- **`(get-card-details card-id)`**  
  Retrieves attributes of a specific card.  
  - **Parameters**:  
    - `card-id`: The unique ID of the card (uint).  
  - **Returns**: Card details as a map.  

- **`(get-market-listing card-id)`**  
  Retrieves marketplace details of a specific card.  
  - **Parameters**:  
    - `card-id`: The unique ID of the card (uint).  
  - **Returns**: Marketplace listing details as a map.  

- **`(get-card-owner card-id)`**  
  Checks the current owner of a card.  
  - **Parameters**:  
    - `card-id`: The unique ID of the card (uint).  
  - **Returns**: Principal of the card owner.  

---

## Data Structures

### Card Attributes
Each card is defined with the following attributes:  
- `name`: Card name (string, max 50 characters).  
- `attack`: Attack power (uint).  
- `defense`: Defense power (uint).  
- `rarity`: Rarity level (uint).  
- `element`: Element type (string, max 20 characters).  

### Marketplace Listing
Each marketplace entry includes:  
- `price`: Listing price in STX (uint).  
- `seller`: Principal of the seller.

---

## Error Codes

- **`u100`**: Action restricted to the contract owner.  
- **`u101`**: Caller is not the owner of the specified card.  
- **`u102`**: Invalid card ID.  
- **`u103`**: Card already exists.  
- **`u104`**: Insufficient payment for card purchase.  

---

## Deployment and Usage

1. **Deploying the Contract**  
   - Ensure the Clarity environment is set up.  
   - Deploy the contract on the Stacks blockchain under the name `Deckxchange`.  

2. **Interacting with the Contract**  
   - Use a compatible Clarity wallet or developer tools to invoke contract functions.  
   - Ensure sufficient STX balance for trading activities.

---

## Future Enhancements

- Adding support for card battles and tournaments.  
- Introducing rarity-based bonuses and in-game mechanics.  
- Enabling multi-card trades.  

**Deckxchange**: Trade, collect, and conquer with your ultimate deck! 