module kernel.sys;

import uart = kernel.uart;
import mmio = kernel.mmio;

const core_freq = 250 * 1000 * 1000;

void dsb() {
    asm {
        "dsb sy";
    }
}

void reboot() {
    uart.tx_flush();
    dsb();
    uint* pm_rstc = cast(uint*) (mmio.base + 0x10001c);
    uint* pm_wdog = cast(uint*) (mmio.base + 0x100024);

    const pm_password = 0x5a000000;
    const pm_rstc_wrcfg_full_reset = 0x20;

    mmio.st(pm_wdog, pm_password | 1);
    mmio.st(pm_rstc, pm_password | pm_rstc_wrcfg_full_reset);
    while (true) {}
}
