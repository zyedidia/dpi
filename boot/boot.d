module boot.main;

import gcc.attribute;

import core.bitop;
import timer = kernel.timer;
import uart = kernel.uart;
import crc = boot.crc32;
import sys = kernel.sys;

static import kernel;

enum BootFlags {
    BootStart = 0xFFFF0000,

    GetProgInfo = 0x11112222,
    PutProgInfo = 0x33334444,

    GetCode = 0x55556666,
    PutCode = 0x77778888,

    BootSuccess = 0x9999AAAA,
    BootError = 0xBBBBCCCC,

    BadCodeAddr = 0xdeadbeef,
    BadCodeCksum = 0xfeedface,
}

uint get_uint() {
    union recv {
        ubyte[4] b;
        uint i;
    }

    recv x;
    x.b[0] = uart.rx();
    x.b[1] = uart.rx();
    x.b[2] = uart.rx();
    x.b[3] = uart.rx();
    return x.i;
}

void put_uint(uint u) {
    uart.tx((u >> 0) & 0xff);
    uart.tx((u >> 8) & 0xff);
    uart.tx((u >> 16) & 0xff);
    uart.tx((u >> 24) & 0xff);
}

extern (C) extern __gshared ubyte _kheap_start;

extern (C) extern shared ubyte __start_copyin;
extern (C) extern shared ubyte __stop_copyin;

void boot() {
    while (true) {
        put_uint(BootFlags.GetProgInfo);
        timer.delay_ms(200);

        if (!uart.rx_empty() && get_uint() == BootFlags.PutProgInfo) {
            break;
        }
    }

    ubyte* base = cast(ubyte*) get_uint();
    uint nbytes = get_uint();
    uint crc_recv = get_uint();

    put_uint(BootFlags.GetCode);
    put_uint(crc_recv);

    if (get_uint() != BootFlags.PutCode) {
        return;
    }

    ubyte* heap = &_kheap_start;
    for (uint i = 0; i < nbytes; i++) {
        volatileStore(&heap[i], uart.rx());
    }
    uint crc_calc = crc.crc32(heap, nbytes);
    if (crc_calc != crc_recv) {
        put_uint(BootFlags.BadCodeCksum);
        return;
    }
    put_uint(BootFlags.BootSuccess);
    uart.tx_flush();

    // move copyin to heap+nbytes;
    ubyte* new_copyin = heap + nbytes + (nbytes % 8) + 16;
    long copyin_size = &__stop_copyin - &__start_copyin;
    memcpy(new_copyin, cast(ubyte*)&copyin, copyin_size);
    // call the new copyin that has been moved
    auto fn = cast(void function(ubyte*, ubyte*, uint)) new_copyin;
    fn(base, heap, nbytes);
}

void memcpy(ubyte* dst, ubyte* src, long nbytes) {
    for (uint i = 0; i < nbytes; i++) {
        volatileStore(&dst[i], src[i]);
    }
}

extern (C) void kmain() {
    kernel.init();
    boot();
    put_uint(BootFlags.BootError);
}

@attribute("section", "copyin") {
    void copyin(ubyte* dst, ubyte* src, uint nbytes) {
        for (uint i = 0; i < nbytes; i++) {
            dst[i] = src[i];
        }
        auto main = cast(void function()) dst;
        main();
    }
}
