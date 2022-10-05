module core.exception;

import io = std.stdio;
import sys = kernel.sys;

void panic(Args...)(Args msg) {
    io.writeln(msg);
    sys.reboot();
    while (true) {
    }
}

extern (C) void _d_assert(string file, uint line) {
    panic(file, ":", line, ": assertion failure");
}

extern (C) void _d_assert_msg(string msg, string file, uint line) {
    panic(file, ":", line, ": ", msg);
}

extern (C) void _d_arraybounds(string file, uint line) {
    panic(file, ":", line, ": out of bounds");
}
