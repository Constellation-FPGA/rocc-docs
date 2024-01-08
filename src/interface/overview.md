# RoCC Interface Overview

The RoCC interface has a basic set of signals that are generally necessary for accelerators.
We refer to these as the default RoCC interface.
However, the RoCC interface also provides some configurable extensions which may be required by accelerators depending on their functionality.
We refer to these as the extended RoCC interface.

The [***default*** RoCC interface](./interface/default.md) signals may be classified into the following groups of signals
  1. Core control (CC): for co-ordination between an accelerator and Rocket core
  2. Register mode (Core): for exchange of data between an accelerator and Rocket core
  3. Memory mode (Mem): for communication between an accelerator and L1-D Cache

The [***extended*** RoCC interface](./interface/extended.md) can provide for the following groups of signals
  1. Uncached Tile Link (UTL): for communication between an accelerator & L2 memory
  2. Floating Point Unit (FPU): for an accelerator to send and receive data from an FPU
  3. Control Status Register (CSR): used by Linux on the core to recognize the accelerator
  4. Page Table Walker (PTW): for address translation from an accelerator

The system-level diagram in Figure 1 shows the RoCC interface for an accelerator.
We prefix acronyms assigned above to subgroups in verilog signal names through rest of the document.

![Highlighted RoCC Interface Figure](images/highlight-rocc-interface.svg)
