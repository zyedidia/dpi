module object;

nothrow:
@safe:

alias string = immutable(char)[];
alias size_t = typeof(int.sizeof);
alias ptrdiff_t = typeof(cast(void*) 0 - cast(void*) 0);

bool _xopEquals(in void*, in void*) {
    return false;
}
