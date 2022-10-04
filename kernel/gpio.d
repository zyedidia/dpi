module kernel.gpio;

version (raspi) public import kernel.board.raspi.gpio;

void write(uint pin, bool v) {
    if (v)
        set_on(pin);
    else
        set_off(pin);
}
