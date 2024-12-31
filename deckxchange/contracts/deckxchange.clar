;; Card Trading Game Contract

;; Constants
(define-constant admin tx-sender)
(define-constant err-admin-only (err u100))
(define-constant err-not-nft-owner (err u101))
(define-constant err-invalid-nft (err u102))
(define-constant err-nft-exists (err u103))
(define-constant err-insufficient-funds (err u104))

;; Define the NFT for cards
(define-non-fungible-token nft uint)

;; Data Maps
(define-map nft-properties
    uint    ;; nft-id
    {
        title: (string-utf8 50),
        power: uint,
        shield: uint,
        tier: uint,
        type: (string-utf8 20)
    })

(define-map nft-marketplace
    uint    ;; nft-id
    {
        cost: uint,
        owner: principal
    })

;; Variables
(define-data-var nft-counter uint u1)

;; Admin Functions
(define-public (mint-nft (title (string-utf8 50)) 
                          (power uint) 
                          (shield uint) 
                          (tier uint)
                          (type (string-utf8 20)))
    (let ((nft-id (var-get nft-counter)))
        (begin
            (asserts! (is-eq tx-sender admin) err-admin-only)
            (try! (nft-mint? nft nft-id admin))
            (map-set nft-properties nft-id
                {
                    title: title,
                    power: power,
                    shield: shield,
                    tier: tier,
                    type: type
                })
            (var-set nft-counter (+ nft-id u1))
            (ok nft-id))))

;; Trading Functions
(define-public (sell-nft (nft-id uint) (cost uint))
    (begin
        (asserts! (is-eq (unwrap! (nft-get-owner? nft nft-id) err-invalid-nft) tx-sender) 
                 err-not-nft-owner)
        (try! (nft-transfer? nft nft-id tx-sender (as-contract tx-sender)))
        (map-set nft-marketplace nft-id {cost: cost, owner: tx-sender})
        (ok true)))

(define-public (cancel-sale (nft-id uint))
    (let ((marketplace-listing (unwrap! (map-get? nft-marketplace nft-id) err-invalid-nft)))
        (begin
            (asserts! (is-eq (get owner marketplace-listing) tx-sender) err-not-nft-owner)
            (try! (as-contract (nft-transfer? nft nft-id (as-contract tx-sender) tx-sender)))
            (map-delete nft-marketplace nft-id)
            (ok true))))

(define-public (purchase-nft (nft-id uint))
    (let ((listing (unwrap! (map-get? nft-marketplace nft-id) err-invalid-nft))
          (cost (get cost listing))
          (owner (get owner listing)))
        (begin
            (try! (stx-transfer? cost tx-sender owner))
            (try! (as-contract (nft-transfer? nft nft-id (as-contract tx-sender) tx-sender)))
            (map-delete nft-marketplace nft-id)
            (ok true))))

;; Direct Trading Between Players
(define-public (swap-nfts (send-nft-id uint) (receive-nft-id uint) (recipient principal))
    (begin
        (asserts! (is-eq (unwrap! (nft-get-owner? nft send-nft-id) err-invalid-nft) tx-sender)
                 err-not-nft-owner)
        (asserts! (is-eq (unwrap! (nft-get-owner? nft receive-nft-id) err-invalid-nft) recipient)
                 err-not-nft-owner)
        (try! (nft-transfer? nft send-nft-id tx-sender recipient))
        (try! (nft-transfer? nft receive-nft-id recipient tx-sender))
        (ok true)))

;; Read-Only Functions
(define-read-only (get-nft-properties (nft-id uint))
    (map-get? nft-properties nft-id))

(define-read-only (get-marketplace-listing (nft-id uint))
    (map-get? nft-marketplace nft-id))

(define-read-only (get-nft-owner (nft-id uint))
    (nft-get-owner? nft nft-id))