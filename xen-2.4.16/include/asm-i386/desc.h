#ifndef __ARCH_DESC_H
#define __ARCH_DESC_H

#define __FIRST_TSS_ENTRY 8
#define __TSS(n) ((n) + __FIRST_TSS_ENTRY)

#ifndef __ASSEMBLY__
struct desc_struct {
	unsigned long a,b;
};

extern struct desc_struct gdt_table[];
extern struct desc_struct *idt, *gdt;

struct Xgt_desc_struct {
	unsigned short size;
	unsigned long address __attribute__((packed));
};

#define idt_descr (*(struct Xgt_desc_struct *)((char *)&idt - 2))
#define gdt_descr (*(struct Xgt_desc_struct *)((char *)&gdt - 2))

#define load_TR(n) __asm__ __volatile__("ltr %%ax"::"a" (__TSS(n)<<3))

#define __load_LDT(n) __asm__ __volatile__("lldt %%ax"::"a" ((n)<<3))

extern void set_intr_gate(unsigned int irq, void * addr);
extern void set_tss_desc(unsigned int n, void *addr);

#endif /* !__ASSEMBLY__ */

#endif
