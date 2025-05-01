# 🃏 Web-Based Blackjack Game

## 📖 Overview
This is an interactive web-based Blackjack card game implemented in Racket using the `web-server/insta` framework. The game includes all standard Blackjack rules, betting functionality, and a visually appealing interface with card images.

## 🎮 Game Features
- 🎴 Full standard deck of 52 playing cards
- 💰 Betting system with balance tracking
- 🧠 Intelligent dealer AI that follows standard Blackjack rules (hits until 17+)
- 💵 Special 3:1 payout for natural Blackjack
- 🎨 Visual card representations using SVG images
- 📜 Dealer action log for game transparency
- 📱 Responsive design with clean CSS styling

## 🛠️ Technical Implementation
The project demonstrates several key programming concepts:

- **Functional Programming**: Uses Racket's functional paradigm for card evaluation and game logic
- **State Management**: Manages game state with global variables
- **Web Server**: Leverages Racket's web server capabilities
- **Event Handling**: Implements handlers for game actions
- **Dynamic UI**: Renders the UI differently based on game state

## 📋 Game Rules
1. Player starts by setting their bank amount and placing a bet
2. Initial deal gives two cards to player (both face up) and dealer (one face up, one face down)
3. Player can choose to "hit" (draw another card) or "stay"
4. If player exceeds 21 points, they bust and lose automatically
5. Dealer plays after player stays, following strict rules (must hit until 17+)
6. Higher hand value wins, without exceeding 21
7. Natural Blackjack (21 with first two cards) pays 3:1

## 📸 Gameplay Screenshots

### Bank Account Setup
![Bank Setup](screenshots/bank_setup.png)
*Setting up your initial bank account with $100*

### Placing Your Bet
![Betting Screen](screenshots/betting_screen.png)
*Placing a $10 bet before starting the game*

### Game In Progress
![Gameplay](screenshots/active_gameplay.png)
*Game in progress: Player has 20 points (Jack of Hearts and 10 of Spades), while dealer shows Queen of Hearts with one card face down. Player can choose to hit or stay*

### Player Bust
![Player Bust](screenshots/player_bust.png)
*Game over: Player busted with 23 points after hitting (Jack of Hearts, 10 of Spades, and 3 of Clubs), while dealer has 16 points (6 of Spades and Queen of Hearts)*


## 🖥️ Code Structure
- Card and deck representation
- Hand evaluation logic
- Dealer AI implementation
- Web-based UI rendering
- CSS styling for visual appeal
- Event handlers for game actions

---

© 2025 | Created using Racket and `web-server/insta`