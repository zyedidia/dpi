module kernel.sys;

const core_freq = 250 * 1000 * 1000;

void dsb() {
    asm {
        "dsb sy";
    }
}
