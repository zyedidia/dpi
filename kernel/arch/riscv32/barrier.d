module kernel.arch.riscv32.barrier;

void dsb() {
    asm {
        "fence";
    }
}
