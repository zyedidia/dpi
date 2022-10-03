module kernel.main;

import core.bitop;

import gpio = kernel.gpio;
import timer = kernel.timer;

void kmain() {
    gpio.set_output(21);
    bool v = true;
    while (true) {
        gpio.write(21, v);
        v = !v;
        timer.delay_ms(500);
    }
}
