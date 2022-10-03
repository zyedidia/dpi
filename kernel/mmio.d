module kernel.mmio;

import core.bitop;
import core.stdc.stdint;
import std.typecons;

const base = 0x3f000000;

alias ptr = Typedef!(uintptr_t);

void sti(T)(ptr ptr, uint i, T value) {
    volatileStore(cast(T*)ptr + i, value);
}

T ldi(T)(ptr ptr, uint i) {
    return volatileLoad(cast(T*)ptr + i);
}

void st(T)(ptr ptr, T value) {
    volatileStore(cast(T*)ptr, value);
}

T ld(T)(ptr ptr) {
    return volatileLoad(cast(T*)ptr);
}
