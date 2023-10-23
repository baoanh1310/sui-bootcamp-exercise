#[allow(unused_function)]
module lesson6::hero_game {
    use std::string::String;
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};
    use sui::object::{Self, UID};

    struct Hero has key, store {
        id: UID,
        name: String,
        hp: u64,
        experience: u64,
    }

    struct Sword has key, store {
        id: UID,
        attack: u64,
        strength: u64,
    }

    struct Armor has key, store {
        id: UID,
        defense: u64,
    }

    struct Monster has key {
        id: UID,
        hp: u64,
        strength: u64,
    }

    struct GameInfo has key {
        id: UID,
        admin: address
    }

    struct AdminCap has key, store {
        id: UID,
    }

    fun init(ctx: &mut TxContext) {
        transfer::public_transfer(AdminCap {
            id: object::new(ctx)
        }, tx_context::sender(ctx));
        transfer::share_object(GameInfo {
            id: object::new(ctx),
            admin: tx_context::sender(ctx)
        })
    }

    fun create_hero(name: String, hp: u64, experience: u64, ctx: &mut TxContext) {
        transfer::public_transfer(Hero {
            id: object::new(ctx),
            name,
            hp,
            experience
        }, tx_context::sender(ctx));
    }

    fun create_sword(attack: u64, strength: u64, ctx: &mut TxContext) {
        transfer::public_transfer(Sword {
            id: object::new(ctx),
            attack,
            strength
        }, tx_context::sender(ctx));
    }

    fun create_armor(defense: u64, ctx: &mut TxContext) {
        transfer::public_transfer(Armor {
            id: object::new(ctx),
            defense,
        }, tx_context::sender(ctx));
    }

    fun create_monter(_cap: &AdminCap, hp: u64, strength: u64, ctx: &mut TxContext) {
        transfer::share_object(Monster {
            id: object::new(ctx),
            hp,
            strength
        });
    }

    fun level_up_hero(hero: &mut Hero) {
        hero.experience = hero.experience + 1;
    }
    fun level_up_sword(sword: &mut Sword, attack: u64, strength: u64) {
        sword.attack = sword.attack + attack;
        sword.strength = sword.strength + strength;
    }
    fun level_up_armor(armor: &mut Armor, defense: u64) {
        armor.defense = armor.defense + defense;
    }

    public entry fun attack_monter(
        hero: &mut Hero,
        sword: &Sword,
        armor: &Armor,
        monster: &mut Monster
    ) {
        if (hero.hp + armor.defense <= monster.strength) {
            hero.hp = 0;
        } else {
            hero.hp = hero.hp + armor.defense - monster.strength;
        };

        if (sword.attack >= monster.strength) {
            monster.hp = 0;
        } else {
            monster.hp = monster.hp - sword.attack;
        };

        if (monster.hp == 0) {
            level_up_hero(hero);
        };
    }

}
