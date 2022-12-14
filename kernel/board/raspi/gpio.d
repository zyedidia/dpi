module kernel.board.raspi.gpio;

import mmio = kernel.mmio;
import device = kernel.board.raspi.device;

enum PinType {
    tx = 14,
    rx = 15,
    sda = 2,
    scl = 3,
}

enum FuncType {
    input = 0,
    output = 1,
    alt0 = 4,
    alt1 = 5,
    alt2 = 6,
    alt3 = 7,
    alt4 = 3,
    alt5 = 2,
}

enum base = 0x200000;
enum fsel = cast(uint*)(device.base + base);
enum set = cast(uint*)(device.base + base + 0x1C);
enum clr = cast(uint*)(device.base + base + 0x28);
enum lev = cast(uint*)(device.base + base + 0x34);

void set_func(uint pin, FuncType fn) {
    if (pin >= 32)
        return;
    uint off = (pin % 10) * 3;
    uint idx = pin / 10;

    uint v = mmio.ld(&fsel[idx]);
    v &= ~(0b111 << off);
    v |= fn << off;
    mmio.st(&fsel[idx], v);
}

void set_output(uint pin) {
    set_func(pin, FuncType.output);
}

void set_input(uint pin) {
    set_func(pin, FuncType.input);
}

void set_on(uint pin) {
    if (pin >= 32)
        return;
    mmio.st(set, 1 << pin);
}

void set_off(uint pin) {
    if (pin >= 32)
        return;
    mmio.st(clr, 1 << pin);
}

bool read(uint pin) {
    if (pin >= 32)
        return false;
    return (mmio.ld(lev) >> pin) & 1;
}
