module kernel.sys;

version (raspi) import sys = kernel.board.raspi.sys;

alias gpu_freq = sys.gpu_freq;
alias core_freq = sys.core_freq;
alias reboot = sys.reboot;
