module kernel.sys;

version(raspi)
    public import kernel.board.raspi.sys;
else
    static assert(false, "unknown board");
