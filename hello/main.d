module hello.main;

import core.bitop;

import timer = kernel.timer;
import uart = kernel.uart;
import sys = kernel.sys;

void hello() {
    uart.init(115200);

    uart.tx('H');
    uart.tx('e');
    uart.tx('l');
    uart.tx('l');
    uart.tx('o');
    uart.tx('\n');

    sys.reboot();
}

extern(C) void kmain() {
    hello();
}
