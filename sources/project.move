module YOURADDRESS::avatar {
    use std::signer;
    use std::vector;
    use std::timestamp;

    /// Avatar resource stored under each account
    struct Avatar has key {
        name: vector<u8>,
        image_url: vector<u8>,
        created_at: u64,
        updated_at: u64,
    }

    /// Create avatar (only if not exists)
    public entry fun create_avatar(account: &signer, name: vector<u8>, image_url: vector<u8>) {
        let addr = signer::address_of(account);
        assert!(!exists<Avatar>(addr), 1);

        let now = timestamp::now_seconds();
        move_to(account, Avatar {
            name,
            image_url,
            created_at: now,
            updated_at: now,
        });
    }

    /// Update avatar (must already exist)
    public entry fun update_avatar(account: &signer, name: vector<u8>, image_url: vector<u8>) acquires Avatar {
        let addr = signer::address_of(account);
        assert!(exists<Avatar>(addr), 2);

        let a_ref = borrow_global_mut<Avatar>(addr);
        a_ref.name = name;
        a_ref.image_url = image_url;
        a_ref.updated_at = timestamp::now_seconds();
    }

    /// View avatar data by address
    public fun get_avatar(owner: address): (vector<u8>, vector<u8>, u64, u64) acquires Avatar {
        if (exists<Avatar>(owner)) {
            let a_ref = borrow_global<Avatar>(owner);
            (a_ref.name, a_ref.image_url, a_ref.created_at, a_ref.updated_at)
        } else {
            (vector::empty<u8>(), vector::empty<u8>(), 0, 0)
        }
    }
}
