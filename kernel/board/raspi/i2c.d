module kernel.board.raspi.i2c;

import barrier = kernel.barrier;
import bits = kernel.bits;
import mmio = kernel.mmio;
import timer = kernel.timer;
import device = kernel.board.raspi.device;
import gpio = kernel.board.raspi.gpio;
import sys = kernel.board.raspi.sys;

struct Regs {
    uint ctrl;
    uint status;
    uint data_len;
    uint dev_addr;
    uint data_fifo;
    uint clock_div;
    uint clock_delay;
    uint clock_stretch_timeout;
}

enum ctrl_read = 0x1;
enum ctrl_clear_fifo = 0x10;
enum ctrl_start = 0x80;
enum ctrl_enable = 0x8000;

enum status_transfer_active = 0x1;
enum status_transfer_done = 0x2;
enum status_fifo_need_write = 0x4;
enum status_fifo_need_read = 0x8;
enum status_fifo_can_write = 0x10;
enum status_fifo_can_read = 0x20;
enum status_fifo_empty = 0x40;
enum status_fifo_full = 0x80;
enum status_error_peripheral_ack = 0x100;
enum status_timeout = 0x200;

enum fifo_max_size = 16;

enum i2c = cast(Regs*)(device.base + 0x804000);

void init() {
    gpio.set_func(gpio.PinType.sda, gpio.FuncType.alt0);
    gpio.set_func(gpio.PinType.scl, gpio.FuncType.alt0);
    barrier.dsb();
    mmio.st(&i2c.ctrl, ctrl_enable);
    barrier.dsb();
}

enum norm_delay = 500;

void read(uint dev_addr, char* data, int data_len) {
    // clear out the FIFO
    mmio.st(&i2c.ctrl, mmio.ld(&i2c.ctrl) | ctrl_clear_fifo);
    while (!(mmio.ld(&i2c.status) & status_fifo_empty)) {
    }
    // clear previous transfer's flags
    mmio.st(&i2c.status, mmio.ld(&i2c.status) | status_transfer_done | status_error_peripheral_ack | status_timeout);

    // set device address + data length
    mmio.st(&i2c.dev_addr, dev_addr);
    mmio.st(&i2c.data_len, data_len);
    int data_index = 0;

    // begin read
    mmio.st(&i2c.ctrl, mmio.ld(&i2c.ctrl) | ctrl_read | ctrl_start);

    timer.delay_us(norm_delay);
    // keep reading until transfer is complete
    while ((mmio.ld(&i2c.status) & status_fifo_can_read) &&
            (!(mmio.ld(&i2c.status) & status_transfer_done) ||
             (data_index < data_len))) {
        timer.delay_us(40);
        data[data_index++] = cast(ubyte) mmio.ld(&i2c.data_fifo);
    }
}

void write(uint dev_addr, char *data, int data_len) {
    // clear out the FIFO
    mmio.st(&i2c.ctrl, mmio.ld(&i2c.ctrl) | ctrl_clear_fifo);
    while (!(mmio.ld(&i2c.status) & status_fifo_empty)) {
    }
    // clear previous transfer's flags
    mmio.st(&i2c.status, mmio.ld(&i2c.status) | status_transfer_done | status_error_peripheral_ack | status_timeout);

    // set peripheral address + data length
    mmio.st(&i2c.dev_addr, dev_addr);
    mmio.st(&i2c.data_len, data_len);
    int data_index = 0;

    // write first 16 chunks into FIFO
    while ((data_index < fifo_max_size) &&
            (data_index < data_len)) {
        mmio.st(&i2c.data_fifo, data[data_index++]);
    }

    // begin write
    mmio.st(&i2c.ctrl, mmio.ld(&i2c.ctrl) & ~ctrl_read);
    mmio.st(&i2c.ctrl, mmio.ld(&i2c.ctrl) | ctrl_start);

    // as fifo clears up, continue transferring until done
    while (!(mmio.ld(&i2c.status) & status_transfer_done) &&
            (mmio.ld(&i2c.status) & status_fifo_can_write) &&
            (data_index < data_len)) {
        mmio.st(&i2c.data_fifo, data[data_index++]);
    }

    // wait until the FIFO's contents are emptied by the peripheral
    while (!(mmio.ld(&i2c.status) & status_fifo_empty)) {
    }
}
