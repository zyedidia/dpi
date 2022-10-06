module test.main;

import uart = kernel.uart;
import sys = kernel.sys;
import ktests = kernel.tests;

import io = std.stdio;

void runtests(tests...)() {
    io.writeln("running ", tests.length, " tests...");

    foreach (i, t; tests) {
        io.writeln("test ", i + 1, "...");
        t();
    }

    io.writeln("all tests done!");
}

extern (C) void kmain() {
    uart.init(115200);

    alias tests = __traits(getUnitTests, ktests);
    runtests!tests();

    sys.reboot();
}
