module std.bitmanip;

import std.traits;

version (GNU) {
    import gcc.builtins;

    size_t msb(uint x) {
        return x ? x.sizeof * 8 - __builtin_clz(x) : 0;
    }

    size_t msb(ulong x) {
        return x ? x.sizeof * 8 - __builtin_clzll(x) : 0;
    }
}

version (LDC) {
    import ldc.intrinsics;

    size_t msb(uint x) {
        return x ? x.sizeof * 8 - llvm_ctlz!uint(x, true) : 0;
    }

    size_t msb(ulong x) {
        return x ? x.sizeof * 8 - llvm_ctlz!ulong(x, true) : 0;
    }
}

