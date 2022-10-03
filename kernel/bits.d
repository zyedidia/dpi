module kernel.bits;

bool get(uint x, uint bit) {
    return (x >> bit) & 1;
}
