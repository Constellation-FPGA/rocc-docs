# Extended Interface
These signals are included only if RoCC is configured to include them.
Please note the below list of signals is not comprehensive but only for representational purposes.

## Uncached Tile Link (UTL)
The UTL group is composed of 2 subgroups namely aUTL which is arbitrated uncached tile link signals and UTL signals.

aUTL is arbitrated with the I-cache link to L2 memory system.
The aUTL signals composed of AUTL acquire and grant subgroups as listed in Table 6 and 7 respectively are prefixed with `autl_` to denote the group they belong to.

The UTL signals are a vector of signals of the same type as aUTL.
The size of the UTL vector is equal to the number of independent memory channels, which is configurable in the rocket core.
However these signals are yet to be added in the document.

## Floating Point Unit (FPU)
This interface may be used by the accelerator if it has a floating point unit attached to it.
All the signal names are prefixed with `fpu_` to denote the group they belong to.
The interface is composed of FP request and FP response sub-groups as listed in Table 8 and Table 9 respectively.

## Control Status Register (CSR)
Control status registers may be used optionally within the accelerator.
If they exist, the interface signals in Table 10 can be used by the operating system on the core to memory map the accelerator.
Its mechanism is to be added and will be discussed in later versions of the document.
All the signal names are prefixed with `csr_` to denote the group they belong to.

## Page Table Walker (PTW)
The page table walker signals are used for address translation from the accelerator (if the core isn’t already handling it).
These signals will be added as a part of future work.
All the signal names will be prefixed with `ptw_` to denote the group they belong to.

Please stay tuned for updates.
