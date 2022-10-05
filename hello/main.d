module hello.main;

import core.bitop;

import timer = kernel.timer;
import uart = kernel.uart;
import sys = kernel.sys;

import io = std.stdio;

extern (C) void kmain() {
    uart.init(115200);

    io.write("Hello world", 42, "\n");

    sys.reboot();
}
