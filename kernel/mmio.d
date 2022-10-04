module kernel.mmio;

import core.bitop;

version(raspi)
    public import kernel.board.raspi.mmio;

void st(uint* ptr, uint value) {
    volatileStore(ptr, value);
}

uint ld(uint* ptr) {
    return volatileLoad(ptr);
}
