module kernel.vm;

uintptr pa2ka(uintptr pa) {
    return pa | (cast(uintptr) 1 << 31);
}

uintptr ka2pa(uintptr ka) {
    return ka & ~(cast(uintptr) 1 << 31);
}
