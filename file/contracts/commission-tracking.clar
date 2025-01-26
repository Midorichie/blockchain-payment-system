;; Commission Tracking Contract
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u1))
(define-constant err-invalid-commission (err u2))

;; Store commission rates for different transaction types
(define-map commission-rates (string-ascii 50) uint)

;; Track total commissions earned
(define-map total-commissions principal uint)

;; Set commission rate for a specific transaction type
(define-public (set-commission-rate (transaction-type (string-ascii 50)) (rate uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (asserts! (<= rate u100) err-invalid-commission)
    (map-set commission-rates transaction-type rate)
    (ok true)
  )
)

;; Calculate and distribute commission
(define-public (process-commission (transaction-type (string-ascii 50)) (amount uint))
  (let 
    ((commission-rate (default-to u0 (map-get? commission-rates transaction-type)))
     (commission-amount (/ (* amount commission-rate) u100))
     (current-total (default-to u0 (map-get? total-commissions tx-sender))))
    (begin
      (map-set total-commissions tx-sender (+ current-total commission-amount))
      (ok commission-amount)
    )
  )
)

;; Retrieve total commissions for an account
(define-read-only (get-total-commissions (account principal))
  (ok (default-to u0 (map-get? total-commissions account)))
)
