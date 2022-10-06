module kernel.sys;

version (raspi1ap) import sys = kernel.board.raspi.sys;

version (raspi3b) import sys = kernel.board.raspi.sys;

version (raspi4b) import sys = kernel.board.raspi.sys;

alias gpu_freq = sys.gpu_freq;
alias core_freq = sys.core_freq;
alias reboot = sys.reboot;
