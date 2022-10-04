module kernel.sys;

version(Raspi)
    public import kernel.board.raspi.sys;
else
    static assert(false, "unknown board");
