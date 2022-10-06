module kernel.arch.arm.vm;

/* import std.bitmanip; */

/* struct pte_1mb_t { */
/*     mixin(bitfields!( */
/*         uint, "tag",           2, */
/*         uint, "b",             1, */
/*         uint, "c",             1, */
/*         uint, "xn",            1, */
/*         uint, "domain",        4, */
/*         uint, "p",             1, */
/*         uint, "ap",            2, */
/*         uint, "tex",           3, */
/*         uint, "apx",           1, */
/*         uint, "s",             1, */
/*         uint, "ng",            1, */
/*         uint, "super",         1, */
/*         uint, "_sbz1",         1, */
/*         uint, "sec_base_addr", 12 */
/*     )); */
/* } */
/*  */
/* static assert(pte_1mb_t.sizeof == 4); */
