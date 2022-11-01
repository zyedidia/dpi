module std.bitmanip;

import gcc.builtins;

import std.traits;

size_t msb(uint x) {
    return x ? x.sizeof * 8 - __builtin_clz(x) : 0;
}

size_t msb(ulong x) {
    return x ? x.sizeof * 8 - __builtin_clzll(x) : 0;
}
