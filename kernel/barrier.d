module kernel.barrier;

version (AArch64) import barrier = kernel.arch.aarch64.barrier;

version (ARM) import barrier = kernel.arch.arm.barrier;

version (RISCV32) import barrier = kernel.arch.riscv32.barrier;

alias dsb = barrier.dsb;
