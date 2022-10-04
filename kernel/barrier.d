module kernel.barrier;

version (AArch64) public import kernel.arch.aarch64.barrier;

version (ARM) public import kernel.arch.arm.barrier;
