module lesson5::discount_coupon {
    use sui::tx_context::TxContext;
    use sui::transfer;
    use sui::object::{Self, UID};

    struct DiscountCoupon has key, store {
        id: UID,
        owner: address,
        discount: u8,
        expiration: u64,
    }

    /// get token owner info
    public fun owner(coupon: &DiscountCoupon): address {
        coupon.owner
    }

    /// get coupon discount info
    public fun discount(coupon: &DiscountCoupon): u8 {
        coupon.discount
    }

    // mint 1 coupon & transfer it to recipient
    public entry fun mint_and_topup(
        discount: u8,
        expiration: u64,
        recipient: address,
        ctx: &mut TxContext
    ) {
        let nft = DiscountCoupon {
            id: object::new(ctx),
            owner: recipient,
            discount,
            expiration,
        };
        transfer::public_transfer(nft, recipient)
    }

    // transfer coupon to other user
    public entry fun transfer_coupon(coupon: DiscountCoupon, recipient: address) {
        transfer::public_transfer(coupon, recipient);
    }

    // remove owned coupon
    public fun burn(nft: DiscountCoupon): bool {
        let DiscountCoupon { id, owner: _, discount: _, expiration: _ } = nft;
        object::delete(id);
        true
    }

    // use, then remove coupon
    public entry fun scan(nft: DiscountCoupon) {
        // ....check information
        burn(nft);
    }
}
