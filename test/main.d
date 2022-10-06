module test.main;

import sys = kernel.sys;

static import kernel;

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
    kernel.init();

    alias tkernel = __traits(getUnitTests, kernel);
    runtests!tkernel();

    sys.reboot();
}
