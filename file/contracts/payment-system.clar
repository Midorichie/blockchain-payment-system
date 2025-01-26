;; Payment System Smart Contract
(define-trait payment-interface
  (
    (transfer (uint uint principal principal) (response bool uint))
    (get-balance (principal) (response uint uint))
  )
)

(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u1))
(define-constant err-insufficient-funds (err u2))

;; Token storage
(define-map balances principal uint)

;; Transfer tokens between accounts
(define-public (transfer (amount uint) (recipient principal))
  (let 
    ((sender-balance (default-to u0 (map-get? balances tx-sender)))
     (recipient-balance (default-to u0 (map-get? balances recipient))))
    (begin
      (asserts! (>= sender-balance amount) err-insufficient-funds)
      (map-set balances tx-sender (- sender-balance amount))
      (map-set balances recipient (+ recipient-balance amount))
      (ok true)
    )
  )
)

;; Get account balance
(define-read-only (get-balance (account principal))
  (ok (default-to u0 (map-get? balances account)))
)

;; Initialize account with initial balance (only for testing)
(define-public (initialize-account (initial-balance uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (map-set balances tx-sender initial-balance)
    (ok true)
  )
)
