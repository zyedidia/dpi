module object;

alias string = immutable(char)[];
alias size_t = typeof(int.sizeof);
alias ptrdiff_t = typeof(cast(void*) 0 - cast(void*) 0);

bool _xopEquals(in void*, in void*) {
    return false;
}

extern (C) void[] _d_arraycopy(size_t size, void[] from, void[] to) {
    import std.memory : memmove;

    memmove(to.ptr, from.ptr, from.length * size);
    return to;
}
