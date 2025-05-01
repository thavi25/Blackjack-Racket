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

## 🖥️ Code Structure
- Card and deck representation
- Hand evaluation logic
- Dealer AI implementation
- Web-based UI rendering
- CSS styling for visual appeal
- Event handlers for game actions

## 🚀 How to Run
1. Ensure Racket is installed on your system
2. Install the `web-server` package if not already installed
   ```
   raco pkg install web-server
   ```
3. Run the application:
   ```
   racket project3.rkt
   ```
4. Access the game in your web browser at the default port

## 🎯 Future Enhancements
- Multiplayer support
- More advanced betting options (splitting, doubling down)
- Local storage for saving player stats
- Sound effects and animations
- Mobile-first responsive design

## 🎓 Educational Value
This project demonstrates:
- Fundamental card game algorithms
- Web application development in Racket
- State management in a functional context
- UI/UX considerations for web games
- Application of CSS for game interfaces

---

© 2025 | Created using Racket and `web-server/insta`