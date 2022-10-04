ENTRY(_start)

SECTIONS
{
    .boot 0x80000 : {
        KEEP(*(.text.boot))
        KEEP(*(.text.cstart))
        . = ALIGN(8);
    }
    . = 0x0;
    .text : AT (ADDR(.boot) + SIZEOF(.boot)) {
        *(.text*) 
        . = ALIGN(8);
    }
    .data : {
        *(.rodata*)
        *(.data*) 
        . = ALIGN(4);
    } 
    PROVIDE(_boot_start = LOADADDR(.text));
    PROVIDE(_boot_size = .);
    .bss : {
        . = ALIGN(4);
        _bss_start = .;
        *(.bss*)
        *(COMMON)
        . = ALIGN(8);
        _bss_end = .;
        . = ALIGN(8);
    }
}
