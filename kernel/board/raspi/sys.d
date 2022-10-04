module kernel.board.raspi.sys;

import uart = kernel.uart;
import mmio = kernel.mmio;
import sys = kernel.barrier;

enum core_freq = 250 * 1000 * 1000;

void reboot() {
    uart.tx_flush();
    sys.dsb();
    uint* pm_rstc = cast(uint*)(mmio.base + 0x10001c);
    uint* pm_wdog = cast(uint*)(mmio.base + 0x100024);

    const pm_password = 0x5a000000;
    const pm_rstc_wrcfg_full_reset = 0x20;

    mmio.st(pm_wdog, pm_password | 1);
    mmio.st(pm_rstc, pm_password | pm_rstc_wrcfg_full_reset);
    while (true) {
    }
}
