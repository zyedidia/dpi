module kernel.board.raspi.mmio;

version(Raspi1ap)
    enum base = 0x20000000;
version(Raspi3b)
    enum base = 0x3f000000;
version(Raspi4b)
    enum base = 0xfe000000;
