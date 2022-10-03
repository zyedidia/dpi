module core.stdc.stdint;

static if ((void*).sizeof == ulong.sizeof) {
    alias uintptr_t = ulong;
} else static if ((void*).sizeof == uint.sizeof) {
    alias uintptr_t = uint;
} else {
    static assert(false, "pointer type is not 64 or 32 bit");
}
