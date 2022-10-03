module std.typecons;

struct Typedef(T, T init = T.init, string cookie=null)
{
    private T Typedef_payload = init;

    // https://issues.dlang.org/show_bug.cgi?id=18415
    // prevent default construction if original type does too.
    static if ((is(T == struct) || is(T == union)) && !is(typeof({T t;})))
    {
        @disable this();
    }

    this(T init)
    {
        Typedef_payload = init;
    }

    this(Typedef tdef)
    {
        this(tdef.Typedef_payload);
    }

    // We need to add special overload for cast(Typedef!X) exp,
    // thus we can't simply inherit Proxy!Typedef_payload
    T2 opCast(T2 : Typedef!(T, Unused), this X, T, Unused...)()
    {
        return T2(cast(T) Typedef_payload);
    }

    auto ref opCast(T2, this X)()
    {
        return cast(T2) Typedef_payload;
    }
}
