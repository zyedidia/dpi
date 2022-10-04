module kernel.timer;

version(AArch64)
    public import timer = kernel.arch.aarch64.timer;
version(ARM)
    public import timer = kernel.arch.arm.timer;
version(RISCV64)
    public import timer = kernel.arch.riscv64.timer;

void delay_ms(uint ms) {
    timer.delay_us(ms * 1000);
}
