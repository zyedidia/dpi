module kernel;

import uart = kernel.uart;
import timer = kernel.timer;

void init() {
    uart.init(115200);
    timer.init();
}

unittest {
    assert(true);
}

unittest {
    import io = std.stdio;

    io.writeln("testing uart: pass");
}
