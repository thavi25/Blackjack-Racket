#lang web-server/insta

; User interface is built with racket's builtin 
; web application framework
; UI improvedments include card art,
; betting, colors, and a web based ui

(define make-card cons)
(define face cdr)
(define suit car)

(define faces '(2 3 4 5 6 7 8 9 10 J Q K A))
(define suits '(Clubs Diamonds Hearts Spades))

; Takes nothing and returns a new unsorted deck
; of cards
(define (make-deck) (apply append
  (map 
    (lambda (x) 
      ; (curry make-card x) creates a 
      ; proc that takes a face and 
      ; creates a card
      (map (curry make-card x) faces)) 
       suits)))



; Takes a player hand and returns the maximum
; value of that hand <= 21
(define (eval-hand playerhand)

  ; Takes a card and returns values for that card
  (define (card-values card)
    (let ([f (face card)])
      (cond
        [(number? f) (list f)]
        [(eq? f 'A) (list 1 11)]
        [(symbol? f) (list 10)])))

  ; Takes a player hand and returns a list
  ; of all possible values for that hand
  (define (hand-values playerhand)
    (foldl
      (lambda (a b)
        ; add everything to a to everything in b
        ; '(1 2) '(4 5) -> '(5 6 6 7)
        (flatten (map (lambda (c)
          (map ((curry +) c) a)) b)))
      (list 0)
      (map card-values playerhand)))

  (let* ([values (hand-values playerhand)]
         [f (if (andmap (curry >= 21) values)
              min
              (lambda (x y)
                (if (> y 21)
                  x
                  (max x y))))])
        (foldr f 100 values)))

; Macro that takes the first two cards
; off the top of a deck and returns them
(define-syntax-rule (deal! deck)
  (let ([tmp (list (car deck) (cadr deck))])
    (set! deck (cddr deck))
    tmp))

; Macro that moves the top card off of a deck
; and into a hand
(define-syntax-rule (hit! deck hand)
  (begin
    (set! hand (append hand (list (car deck))))
    (set! deck (cdr deck))))

; Gamestate deck to be used
(define thedeck (shuffle (make-deck)))

; Gamestate user's balance
(define money 0)

; Gamestate user's bet`
(define bet 0)

; Gamestate player's hand
(define playerhand '())

; Gamestate dealer's hand
(define dealerhand '())

; Gamestate list of the dealer's moves
(define dealerlog '())

; Gamestate boolean that's set to true 
; if the player hands value exceeds 21
; the dealer hands value exceeds 21
; both players choose to stay
(define gameover #f)

; entry point, our main function
(define (start request)
  (render-black-jack request))

; Responsible for render dealer's hand
; when game is over displays all cards in dealer's hand
; otherwise just the first
(define (render-dealerhand)
  `(div 
    ,(if gameover
        (show-hand dealerhand 'Full "Dealer Hand")
        (show-hand dealerhand 'Part "Dealer Hand"))))

; Responsible for rendering a gameover message
; displaying who won the hand
(define (render-gameover)
  (if gameover
    `(div ((class "gameover"))
      (h1
        ,(let* ([hand (eval-hand playerhand)]
                [dhand (eval-hand dealerhand)]
               [lose! (lambda () 
                        (begin
                          (set! money (- money bet))
                          "You Lose!"))]
               [win! (lambda () 
                        (begin
                          (if (eq? hand 21)
                            (set! 
                              money 
                              (+ money (* 3 bet)))
                            (set! money (+ money bet)))
                          "You Win!"))])
          (cond
            [(and (<= hand 21) 
                 (> dhand 21)) 
             (win!)]
            [(and (<= dhand 21) 
                  (> hand 21)) 
             (lose!)]
            [(> hand dhand) (win!)]
            [(>= dhand hand) (lose!)]))))
    `(div)))

; Responsible for rendering the game
; Displays the Start, Hit and Stay, and Reset controls dynamically
; as well as statically displaying the game icon
(define (render-game hit-handler!
                     start-handler! 
                     stay-handler!
                     reset-handler!)
  `(div ((class "game"))
     (img ((src "https://icons.iconarchive.com/icons/icons-land/metro-raster-sport/256/Casino-Playing-Cards-icon.png")))
    ,(cond
       [(<= money 0)
          `(form ((class "start-buttons"))
              (input ((name "money")))
              (input ((type "submit") (value "Bank Account"))))]
       [(eq? bet 0)
          `(form ((class "start-buttons"))
              (input ((name "bet")))
              (input ((type "submit") (value "Bet"))))]
       [(null? playerhand)
        `(div ((class "start-buttons"))
          (a ((href
                 ,start-handler!))
              "Start"))]
       [gameover
        `(a ((href
               ,reset-handler!))
            "Reset")]
       [else 
        `(div ((class "buttons"))
           (a ((href 
                 ,hit-handler!))
              "Hit")
           (a ((href 
                 ,stay-handler!))
              "Stay"))])))

; Show hand takes hand, how: 'Part | 'Full and a description
; and displays either a fully visible or partially visable hand
; when fully visible the hand is displayed with a value
; if the game is over and the hand value exceeds 21 "Bust" is displayed
(define (show-hand hand how description)
  (if (null? hand)
    `(div)
    `(div 
       ((class "hand"))
       (h1 ,description)
      ,(if (eq? how 'Part)
         `(div
            (img ((src "https://tekeye.uk/playing_cards/images/svg_playing_cards/backs/red.svg")))
            ,@(map render-card (cdr hand)))
         `(div
            ,(if (> (eval-hand hand) 21)
               `(h1 "Bust!")
               `(h1))
            (h1
              ,(string-append "Value: "
                 (number->string 
                   (eval-hand hand))))
            ,@(map render-card hand))))))
           

; Renders the dealerlog a list of messages describing
; the dealer's actions
(define (render-dealerlog)
  `(div ((class "dealerlog"))
     (h1 "Dealer Moves")
     (ul
      ,@(map (lambda (x) `(li ,x)) dealerlog))))

; Renders an individual card pulls image from an online
; card image repository
(define (render-card card)
  (let ([f (face card)]
        [s (suit card)])
    `(img 
       ((src ,(string-join (list
         "https://tekeye.uk/playing_cards/images/svg_playing_cards/fronts/"
         (cond
           [(eq? s 'Diamonds) "diamonds"]
           [(eq? s 'Hearts) "hearts"]
           [(eq? s 'Spades) "spades"]
           [(eq? s 'Clubs) "clubs"])
         "_"
         (cond 
           [(eq? f 'A) "ace"]
           [(eq? f 'J) "jack"]
           [(eq? f 'Q) "queen"]
           [(eq? f 'K) "king"]
           [else (number->string f)]) 
         ".svg") ""))))))

; Renders players money
(define (render-money)
  `(div
     (h1 "Balance")
     (h1 ,(string-append (number->string money) "$"))
     (h1 "Your Bet")
     (h1 ,(string-append (number->string bet) "$"))))

; Main rendering function loop
; Callbacks trigger this to rerender causing state to be updated
(define (render-black-jack request)
    
    ; Handles forms for betting
    (let* ([bind (request-bindings request)]
           [extract-num 
             (lambda (sym)
               (if (exists-binding? sym bind)
                 (string->number
                   (extract-binding/single sym bind))
                 #f))]
           [b (extract-num 'bet)]
           [m (extract-num 'money)])
      (when b
        (set! bet b))
      (when m
        (set! money m)))

  (define (response-generator embed/url)
    (response/xexpr
      `(html
        (head (title "Black Jack")
        (style ,css))
        (body 
          (div ((class "main"))
               (div ((class "top"))
                 (div
                    (h1 "Black Jack")
                   ,(render-gameover)
                   ,(render-dealerhand))
                ,(render-dealerlog)
                ,(render-money))
               ,(render-game 
                  (embed/url hit-handler!)
                  (embed/url start-handler!)
                  (embed/url stay-handler!)
                  (embed/url reset-handler!)))
          (div ((class "footer"))
            ,(show-hand playerhand 'Full "Player Hand"))))))

  ; Defines the dealer's ai
  ; returns whether or not the dealer hit
  (define (dealer-move!?)
    (if (<= (eval-hand dealerhand) 17)
      (begin
        (hit! thedeck dealerhand)
        (set! dealerlog (cons "Hit" dealerlog))
        (when (>= (eval-hand dealerhand) 21)
              (set! gameover #t))
        #t)
      (begin
        (set! dealerlog (cons "Stay" dealerlog))
        #f)))

  
  ; Handler for start button
  (define (start-handler! request)
    (set! playerhand (deal! thedeck))
    (set! dealerhand (deal! thedeck))
    
    ; Check for instant blackjack
    (when (or (eq? (eval-hand playerhand) 21) 
              (eq? (eval-hand dealerhand) 21))
      (set! gameover #t))

    (render-black-jack request))
    
  ; Hander for hit button
  (define (hit-handler! request)

    (hit! thedeck playerhand)

    (if (>= (eval-hand playerhand) 21)
      (set! gameover #t)
      (dealer-move!?))

    (render-black-jack request))
  
  ; Handler for stay button
  (define (stay-handler! request)

    (when (not (dealer-move!?)) (set! gameover #t))
    (render-black-jack request))
  
  ; Handler for reset button
  (define (reset-handler! request)
    (set! playerhand '())
    (set! dealerhand '())
    (set! dealerlog '())
    (set! thedeck (shuffle (make-deck)))
    (set! gameover #f)
    (set! bet 0)
    (render-black-jack request))

  (send/suspend/dispatch response-generator))

; CSS as string to style the UI
(define css "
:root {
    --orange: #ed7d31;
    --brown: #6c5f5b;
    --gray: #4f4a45;
    --white: #f6f1ee;
}

* {
    margin: 0;
    padding: 0;
    font-family: monospace;
}

body {
    display: flex;
    flex-direction: column;
    justify-content: space-between;
    width: 100%;
    height: 100%;
    color: var(--white);
}

.main {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    background-color: var(--brown);
}

.game {
    height: 100%;
    display: flex;
    flex-direction: column;
    gap: 1rem;
    justify-content: center;
    align-items: center;
}

.game img {
    width: 20rem;
}

.game a {
    padding: .3rem;
    text-decoration: none;
    background-color: var(--orange);
    color: black;
    border-radius: .5rem;
    box-shadow: 4px 4px 10px var(--gray);
}

.game .buttons {
    display: flex;
    gap: 1rem;
}

.hand img {
    width: 10rem;
}

.gameover img {
    width: 10rem;
}

.footer {
    width: 100%;
    height: 20rem;
    padding: .5rem;
    background-color: var(--gray);
}

.top {
    display: flex;
    justify-content: space-between;
}

.top h1 {
    padding: .5rem;
}

.dealerlog {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.dealerlog li {
    font-size: 1.5rem;
}

.start-buttons {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: .5rem;
}

.start-buttons .forms {
    display: flex;
    flex-direction: column;
    gap: .3rem;
}

.start-buttons input {
    margin-right: .5rem;
    padding: .5rem;
    background-color: var(--white);
    border-radius: .3rem;
}
")
