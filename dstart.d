module dstart;

import kernel;

import core.bitop;

extern(C) void dstart() {
    extern(C) uint _kbss_start, _kbss_end;

    uint* bss = &_kbss_start;
    uint* bss_end = &_kbss_end;

    while (bss < bss_end) {
        volatileStore(bss++, 0);
    }

    kmain();
}
