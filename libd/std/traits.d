module std.traits;

template Unqual(T : const U, U) {
    static if (is(U == shared V, V))
        alias Unqual = V;
    else
        alias Unqual = U;
}

static assert(is(Unqual!int == int));
static assert(is(Unqual!(const int) == int));
static assert(is(Unqual!(immutable int) == int));
static assert(is(Unqual!(shared int) == int));
static assert(is(Unqual!(shared(const int)) == int));

enum isByte(T) = is(Unqual!T == byte) || is(Unqual!T == ubyte);
enum isShort(T) = is(Unqual!T == short) || is(Unqual!T == ushort);
enum isInt(T) = is(Unqual!T == int) || is(Unqual!T == uint);
enum isLong(T) = is(Unqual!T == long) || is(Unqual!T == ulong);
enum isNumber(T) = isByte!T || isShort!T || isInt!T || isLong!T;
