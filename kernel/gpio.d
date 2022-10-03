module kernel.gpio;

import mmio = kernel.mmio;

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

const uint base = 0x200000;
const mmio.ptr fsel = mmio.base + base;
const mmio.ptr set = mmio.base + base + 0x1C;
const mmio.ptr clr = mmio.base + base + 0x28;
const mmio.ptr lev = mmio.base + base + 0x34;

void set_func(uint pin, FuncType fn) {
    if (pin >= 32)
        return;
    uint off = (pin % 10) * 3;
    uint idx = pin / 10;

    uint v = mmio.ldi!uint(fsel, idx);
    v &= ~(0b111 << off);
    v |= fn << off;
    mmio.sti!uint(fsel, idx, v);
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
    mmio.st!uint(set, 1 << pin);
}

void set_off(uint pin) {
    if (pin >= 32)
        return;
    mmio.st!uint(clr, 1 << pin);
}

void write(uint pin, bool v) {
    if (v)
        set_on(pin);
    else
        set_off(pin);
}

bool read(uint pin) {
    if (pin >= 32)
        return false;
    return (mmio.ld!uint(lev) >> pin) & 1;
}
