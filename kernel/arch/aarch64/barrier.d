module kernel.arch.aarch64.barrier;

void dsb() {
    asm {
        "dsb sy";
    }
}
