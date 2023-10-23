module lesson5::FT_TOKEN {
    use std::option;
    use std::string;
    use std::ascii::{Self, string};
    use sui::coin::{Self, Coin, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::event;
    use sui::url;

    struct FT_TOKEN has drop { }

    const SYMBOL: vector<u8> = b"FT_TOKEN";
    const NAME: vector<u8> = b"FT_TOKEN";
    const DESCRIPTION: vector<u8> = b"FT_TOKEN";
    const DECIMAL: u8 = 6;
    const ICON_URL: vector<u8> = b"https://www.google.com";

    struct TransferEvent has copy, drop {
        sender: address,
        recipient: address,
        amount: u64,
    }

    fun init(witness: FT_TOKEN, ctx: &mut TxContext) {
        let (treasury_cap, metadata) = coin::create_currency<FT_TOKEN>(
            witness,
            DECIMAL,
            SYMBOL,
            NAME,
            DESCRIPTION,
            option::some(url::new_unsafe(string(ICON_URL))),
            ctx
        );
        transfer::public_freeze_object(metadata);
        transfer::public_transfer(treasury_cap, tx_context::sender(ctx))
    }

    // mint 10_000 token each time, only owner can call
    public entry fun mint(treasury_cap: &mut TreasuryCap<FT_TOKEN>, ctx: &mut TxContext) {
        let c = coin::mint(treasury_cap, 10_000_000_000, ctx);
        transfer::public_transfer(c, tx_context::sender(ctx));
    }

    // burn owned tokens
    public entry fun burn_token(treasury_cap: &mut TreasuryCap<FT_TOKEN>, coin: Coin<FT_TOKEN>) {
        coin::burn(treasury_cap, coin);
    }

    // transfer tokens to others
    public entry fun transfer_token(coin: Coin<FT_TOKEN>, recipient: address, ctx: &mut TxContext) {
        let amount = coin::value(&coin);
        transfer::public_transfer(coin, recipient);
        // emit Transfer event
        event::emit(TransferEvent {
            sender: tx_context::sender(ctx),
            recipient,
            amount,
        });
    }

    // split token into multiple object
    // suggestion: use `coin` module from sui framework
    public entry fun split_token(coin: &mut Coin<FT_TOKEN>, split_amount: u64, ctx: &mut TxContext) {
        let c = coin::split(coin, split_amount, ctx);
        transfer::public_transfer(c, tx_context::sender(ctx));
    }

    // update token info methods
    public entry fun update_name(
        treasury_cap: &TreasuryCap<FT_TOKEN>, 
        metadata: &mut coin::CoinMetadata<FT_TOKEN>, 
        name: string::String
    ) {
        coin::update_name(treasury_cap, metadata, name);
    }

    public entry fun update_description(
        treasury_cap: &TreasuryCap<FT_TOKEN>,
        metadata: &mut coin::CoinMetadata<FT_TOKEN>,
        description: string::String
    ) {
        coin::update_description(treasury_cap, metadata, description);
    }

    public entry fun update_symbol(
        treasury_cap: &TreasuryCap<FT_TOKEN>,
        metadata: &mut coin::CoinMetadata<FT_TOKEN>,
        symbol: ascii::String
    ) {
        coin::update_symbol(treasury_cap, metadata, symbol);
    }

    public entry fun update_icon_url(
        treasury_cap: &TreasuryCap<FT_TOKEN>,
        metadata: &mut coin::CoinMetadata<FT_TOKEN>,
        icon_url: ascii::String
    ) {
        coin::update_icon_url(treasury_cap, metadata, icon_url);
    }

    // view methods
    public entry fun get_token_name(metadata: &coin::CoinMetadata<FT_TOKEN>): string::String {
        coin::get_name(metadata)
    }

    public entry fun get_token_description(metadata: &coin::CoinMetadata<FT_TOKEN>): string::String {
        coin::get_description(metadata)
    }

    public entry fun get_token_symbol(metadata: &coin::CoinMetadata<FT_TOKEN>): ascii::String {
        coin::get_symbol(metadata)
    }

    public entry fun get_token_icon_url(metadata: &coin::CoinMetadata<FT_TOKEN>): option::Option<url::Url> {
        coin::get_icon_url(metadata)
    }
}
