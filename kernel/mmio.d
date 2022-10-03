module kernel.mmio;

import core.bitop;

const base = 0x3f000000;

void st(uint* ptr, uint value) {
    volatileStore(ptr, value);
}

uint ld(uint* ptr) {
    return volatileLoad(ptr);
}
