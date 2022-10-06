module kernel.arch.riscv32.csr;

// A common interface for accessing RISC-V CSRs.

enum Reg {
    mcycle = 0xb00,
    mcycleh = 0xb80,
}

template Csr(Reg reg) {
    uintptr read() {
        uintptr r;
        asm {
            "csrr %0, %1" : "=r"(r) : "i"(reg);
        }
        return r;
    }

    void write(uintptr val) {
        asm {
            "csrw %0, %1" :: "i"(reg) "r"(val);
        }
    }
}
