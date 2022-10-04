module kernel.timer;

void delay_us(uint us) {
    ulong f, t, r;
    // get the current counter frequency
    asm {
        // read the current counter
        "mrs %0, cntfrq_el0" : "=r"(f);
        // calculate expire value for counter
        "mrs %0, cntpct_el0" : "=r"(t);
    }
    t += ((f / 1000) * us) / 1000;
    do {
        asm {
            "mrs %0, cntpct_el0" : "=r"(r);
        }
    }
    while (r < t);
}

void delay_ms(uint ms) {
    delay_us(ms * 1000);
}
