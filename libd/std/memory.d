module std.memory;

extern (C):

void* memcpy(void* dst, void* src, size_t n) nothrow {
    char* s = cast(char*) src;
    for (char* d = cast(char*) dst; n > 0; --n, ++s, ++d) {
        *d = *s;
    }
    return dst;
}

void* memmove(void* dst, void* src, size_t n) nothrow {
    char* s = cast(char*) src;
    char* d = cast(char*) dst;
    if (s < d && s + n > d) {
        s += n, d += n;
        while (n-- > 0) {
            *--d = *--s;
        }
    } else {
        while (n-- > 0) {
            *d++ = *s++;
        }
    }
    return dst;
}

void* memset(void* v, char c, size_t n) nothrow {
    for (char* p = cast(char*) v; n > 0; ++p, --n) {
        *p = cast(char) c;
    }
    return v;
}

size_t strlen(const(char)* s) nothrow {
    size_t n;
    for (n = 0; *s != '\0'; ++s) {
        ++n;
    }
    return n;
}
