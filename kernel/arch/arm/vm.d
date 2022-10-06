module kernel.arch.arm.vm;

import std.bitfield;

struct pte_1mb_t {
    uint data;
    mixin(bitfield!(data,
        "tag",           2,
        "b",             1,
        "c",             1,
        "xn",            1,
        "domain",        4,
        "p",             1,
        "ap",            2,
        "tex",           3,
        "apx",           1,
        "s",             1,
        "ng",            1,
        "super_",        1,
        "_sbz1",         1,
        "sec_base_addr", 12
    ));
}

struct pde_t {
    uint data;
    mixin(bitfield!(data,
        "tag",    2,
        "sbz1",   1,
        "ns",     1,
        "sbz2",   1,
        "domain", 4,
        "p",      1,
        "addr",   22
    ));
}

struct pte_small_t {
    uint data;
    mixin(bitfield!(data,
        "xn"   , 1,
        "sz"   , 1,
        "b"    , 1,
        "c"    , 1,
        "ap"   , 2,
        "tex"  , 3,
        "apx"  , 1,
        "s"    , 1,
        "ng"   , 1,
        "addr" , 20
    ));
}

struct pte_large_t {
    uint data;
    mixin(bitfield!(data,
        "sz"   , 2,
        "b"    , 1,
        "c"    , 1,
        "ap"   , 2,
        "sbz"  , 3,
        "apx"  , 1,
        "s"    , 1,
        "ng"   , 1,
        "tex"  , 3,
        "xn"   , 1,
        "addr" , 16
    ));
}

union l1pte_t {
    pde_t pde;
    pte_1mb_t pte_1mb;
}

union l2pte_t {
    pte_small_t pte_4k;
    pte_large_t pte_16k;
}

struct pagetable_t {
    l1pte_t[4096] entries;
}

enum Ap {
    rw        = 0b11,
    no_access = 0b00,
    ro        = 0b10,
    ker_rw    = 0b01,
}

enum Dom {
    no_access = 0b00,
    client    = 0b01,
    reserved  = 0b10,
    manager   = 0b11,
}

enum Page {
    unmapped = 0,
    sz4kb    = 1 << 12,
    sz16kb   = 1 << 14,
    sz1mb    = 1 << 20,
    sz16mb   = 1 << 24,
}
