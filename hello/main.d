module hello.main;

import sys = kernel.sys;

static import kernel;

import io = std.stdio;

extern (C) void kmain() {
    kernel.init();

    const x = 42;
    io.write("Hello world", x, "\n");

    sys.reboot();
}
