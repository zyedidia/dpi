module boot.main;

import timer = kernel.timer;
import uart = kernel.uart;
import crc = boot.crc32;

enum BootFlags {
    BootStart = 0xFFFF0000,

    GetProgInfo   = 0x11112222,
    PutProgInfo   = 0x33334444,

    GetCode        = 0x55556666,
    PutCode        = 0x77778888,

    BootSuccess    = 0x9999AAAA,
    BootError      = 0xBBBBCCCC,

    BadCodeAddr   = 0xdeadbeef,
    BadCodeCksum  = 0xfeedface,
}

uint get_uint() {
    union recv {
        char[4] b;
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

void* boot() {
    while (true) {
        put_uint(BootFlags.GetProgInfo);
        timer.delay_ms(200);

        if (!uart.rx_empty() && get_uint() == BootFlags.PutProgInfo) {
            break;
        }
    }

    char* base = cast(char*) get_uint();
    uint nbytes = get_uint();
    uint crc_recv = get_uint();

    put_uint(BootFlags.GetCode);
    put_uint(crc_recv);

    if (get_uint() != BootFlags.PutCode) {
        return null;
    }

    for (uint i = 0; i < nbytes; i++) {
        base[i] = uart.rx();
    }
    uint crc_calc = crc.crc32(base, nbytes);
    if (crc_calc != crc_recv) {
        put_uint(BootFlags.BadCodeCksum);
        return null;
    }
    put_uint(BootFlags.BootSuccess);

    uart.tx_flush();
    return cast(void*)base;
}

void boot_start() {
    uart.init(115200);

    void* code = boot();
    uart.tx_flush();
    if (code) {
        auto main = cast(void function()) code;
        main();
    }
}
