module kernel.uart;

version (raspi) import uart = kernel.board.raspi.uart;

alias init = uart.init;
alias rx = uart.rx;
alias tx = uart.tx;
alias tx_flush = uart.tx_flush;
