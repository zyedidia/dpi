module kernel.gpio;

import mmio = kernel.mmio;

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

immutable uint base = 0x200000;

private uint* fsel() { return cast(uint*) (mmio.base + base); }
private uint* set()  { return cast(uint*) (mmio.base + base + 0x1C); }
private uint* clr()  { return cast(uint*) (mmio.base + base + 0x28); }
private uint* lev()  { return cast(uint*) (mmio.base + base + 0x34); }

void set_func(uint pin, FuncType fn) {
    if (pin >= 32)
        return;
    uint off = (pin % 10) * 3;
    uint idx = pin / 10;

    uint v = mmio.ld(fsel() + idx);
    v &= ~(0b111 << off);
    v |= fn << off;
    mmio.st(fsel() + idx, v);
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
    mmio.st(set(), 1 << pin);
}

void set_off(uint pin) {
    if (pin >= 32)
        return;
    mmio.st(clr(), 1 << pin);
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
    return (mmio.ld(lev()) >> pin) & 1;
}
