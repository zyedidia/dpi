module kernel.timer;

version (AArch64) public import kernel.arch.aarch64.timer;

version (ARM) public import kernel.arch.arm.timer;

version (RISCV64) public import kernel.arch.riscv64.timer;

void delay_ms(uint ms) {
    delay_us(ms * 1000);
}
