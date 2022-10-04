module dstart;

import boot.main;
import core.bitop;
import gcc.attribute;

@attribute("section", ".text.cstart") extern(C) void dstart() {
    extern(C) ubyte _boot_start;
    extern(C) ubyte _boot_size;

    ubyte* dst = cast(ubyte*) 0x0;
    ubyte* src = &_boot_start;
    while (dst < &_boot_size) {
        volatileStore(dst++, *src++);
    }

    extern(C) uint _bss_start, _bss_end;
    uint* bss = &_bss_start;
    uint* bss_end = &_bss_end;

    while (bss < bss_end) {
        volatileStore(bss++, 0);
    }

    boot_start();
}
