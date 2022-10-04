module kernel.uart;

import mmio = kernel.mmio;
import gpio = kernel.gpio;
import sys = kernel.sys;
import bits = kernel.bits;

struct AuxPeriphs {
    uint io;
    uint ier;
    uint iir;
    uint lcr;
    uint mcr;
    uint lsr;
    uint msr;
    uint scratch;
    uint cntl;
    uint stat;
    uint baud;
}

enum enable_uart   = 1;
enum rx_enable     = 1 << 0;
enum tx_enable     = 1 << 1;
enum clear_tx_fifo = 1 << 1;
enum clear_rx_fifo = 1 << 2;
enum clear_fifos   = clear_tx_fifo | clear_rx_fifo;
enum iir_reset     = (0b11 << 6) | 1;

enum aux_enables = cast(uint*) (mmio.base + 0x215004);
enum uart = cast(AuxPeriphs*) (mmio.base + 0x215040);

void init(uint baud) {
    gpio.set_func(gpio.PinType.tx, gpio.FuncType.alt5);
    gpio.set_func(gpio.PinType.rx, gpio.FuncType.alt5);

    mmio.st(aux_enables, mmio.ld(aux_enables) | enable_uart);

    sys.dsb();

    mmio.st(&uart.cntl, 0);
    mmio.st(&uart.ier, 0);
    mmio.st(&uart.lcr, 0b11);
    mmio.st(&uart.mcr, 0);
    mmio.st(&uart.iir, iir_reset | clear_fifos);
    mmio.st(&uart.baud, sys.core_freq / (baud * 8) - 1);
    mmio.st(&uart.cntl, rx_enable | tx_enable);

    sys.dsb();
}

bool rx_empty() {
    return bits.get(mmio.ld(&uart.stat), 0) == 0;
}

bool can_tx() {
    return bits.get(mmio.ld(&uart.stat), 1) != 0;
}

ubyte rx() {
    sys.dsb();
    while (rx_empty()) {}
    ubyte c = mmio.ld(&uart.io) & 0xff;
    sys.dsb();
    return c;
}

void tx(ubyte c) {
    sys.dsb();
    while (!can_tx()) {}
    mmio.st(&uart.io, c & 0xff);
    sys.dsb();
}

bool tx_empty() {
    sys.dsb();
    return bits.get(mmio.ld(&uart.stat), 9) == 1;
}

void tx_flush() {
    while (!tx_empty()) {}
}
