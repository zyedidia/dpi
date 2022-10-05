module hello.main;

import core.bitop;

import timer = kernel.timer;
import uart = kernel.uart;
import sys = kernel.sys;

import io = std.stdio;

extern (C) void kmain() {
    uart.init(115200);

    const x = 42;
    io.write("Hello world", x, "\n");

    sys.reboot();
}
