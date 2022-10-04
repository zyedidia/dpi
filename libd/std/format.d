module std.format;

extern (C) void init_printf(void*, void*);

void init(void function(ubyte) putc) {
    init_printf(null, putc);
}
