.code16
.globl _start

sector1:
    _start:
        movw $0x0201, %ax
        movw $0x0002, %cx
        movw $0x0080, %dx
        movw $extra_sectors, %bx
        int $0x13
        call reset

        movw $0x0400, %dx

      top2:
      top:
        movb $0x00, %ah
        int $0x16
        movb %al, key
        movw $0x1300, %ax
        movw $0x0002, %bx
        movw $0x000E, %cx
        movw $you_entered, %bp
        int $0x10
        incb %dh
        cmpb $0x14, %dh
        jl top

        movb $0x04, %dh
        addb $0x10, %dl
        andb $0x30, %dl
        jnz top2
        push %dx
        call reset
        pop %dx
        jmp top2

        cli
        hlt

    reset:
        movw $0x0003, %ax
        int $0x10

        movb %al, key
        movw $0x1300, %ax
        movw $0x0002, %bx
        movw $0x000C, %cx
        movw $0x0222, %dx
        movw $press_a_key, %bp
        int $0x10

        movb $0x02, %ah
        movb $0x00, %bh
        movw $0x2500, %dx
        int $0x10
        ret

    . = sector1 + 0x1FE
    .byte 0x55, 0xAA

extra_sectors:

sector2:
    number:
        .word 0
    press_a_key:
        .ascii "Press a key!"
    you_entered:
        .ascii "You entered: "
    key:
        .byte 'K
    . = sector2 + 0x200
