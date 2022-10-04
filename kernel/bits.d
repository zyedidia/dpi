module kernel.bits;

uint mask(uint nbits) {
    if (nbits == 32) {
        return ~0;
    }
    return (1 << nbits) - 1;
}

uint get(uint x, uint ub, uint lb) {
    return (x >> lb) & mask(ub - lb + 1);
}

bool get(uint x, uint bit) {
    return (x >> bit) & 1;
}
