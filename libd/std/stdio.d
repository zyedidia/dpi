module std.stdio;

import uart = kernel.uart;

import std.trait;
import std.algorithm;

string itoa(S)(S num, char[] buf, uint base = 10) if (isNumber!S) {
    auto n = itoa(num, buf.ptr, buf.length, base);
    return cast(string) buf[n .. $];
}

size_t itoa(S)(S num, char* buf, size_t len, uint base = 10) if (isNumber!S) {
    size_t pos = len;
    bool sign = false;

    static if (S.min < 0) {
        if (num < 0) {
            sign = true;
            num = -num;
        }
    }

    do {
        auto rem = num % base;
        buf[--pos] = cast(char)((rem > 9) ? (rem - 10) + 'a' : rem + '0');
        num /= base;
    }
    while (num);

    if (sign) {
        buf[--pos] = '-';
    }

    return pos;
}

struct File {
public:
    void function(ubyte) putc;

    void write(Args...)(Args args) {
        foreach (arg; args) {
            write(arg);
        }
    }

    void flush() {
        if (size > 0) {
            for (size_t i = 0; i < size; i++) {
                putc(buffer[i]);
            }
            size = 0;
        }
    }

private:
    char[256] buffer;
    size_t size;

    void write(char ch) {
        if (size >= buffer.length) {
            flush();
        }
        buffer[size++] = ch;
    }

    void write(string s) {
        while (s.length > 0) {
            auto a = min(s.length, buffer.length - size);
            buffer[size .. size + a] = s;
            s = s[a .. $];
            size += a;

            if (size >= buffer.length) {
                flush();
            }
        }
    }

    void write(bool b) {
        write(b ? "true" : "false");
    }

    void write(S = long)(S value, uint base = 10) if (isNumber!S) {
        char[S.sizeof * 8] buf;
        write(itoa(value, buf, base));
    }
}

__gshared File uartf = {putc: &uart.tx};

void write(Args...)(Args args) {
    uartf.write(args);
    uartf.flush();
}

void writeln(Args...)(Args args) {
    uartf.write(args, '\n');
    uartf.flush();
}
