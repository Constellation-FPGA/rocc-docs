# Default Interface

The default RoCC interface is composed of 3 subgroups, namely the Control, Register and Memory mode signals.

<div class="warning">
A comprehensive list of the signals, with short descriptions and their default values, is provided from a designers’ and accelerators point of view!
This means:
<ul>
<li>Input is data FROM the main core TO the accelerator.</li>
<li>Output is data FROM the accelerator TO the main core.</li>
</ul>
</div>

## Core control (CC)
The core control signals listed in Table 1 ensure co-ordination between the core and accelerator.
All the signal names are prefixed with `cc_` to denote the group they belong to.

## Register mode (Core)
The Register mode signals are composed of the RoCC Command and Response subgroups.
All the signal names are prefixed with `core_` to denote their source.

The RoCC Command signals are used by the core to send instructions to the accelerator and are driven directly by the RoCC Instruction of the RISC-V ISA.
The RoCC instruction is shown in Figure 2 which indicates bit widths and positions above and below the respective fields within the instruction.
Table 2 contains a description of signals in the RoCC Command subgroup.

An RoCC response to the command (if expected) is sent by the accelerator using the response interface.
The response signals are described in Table 3.

## Memory mode (Mem)
The memory interface is composed of Memory request and Memory response subgroups.
All the signal names are prefixed with `mem_` to denote the group they belong to.

Memory requests from the accelerator are sent out using signal described in Table 4.

Memory responses to the accelerator are passed through interface described in Table 5.
There is a response for both load and store requests.
Usually an accelerator may use just the tag and data fields from the response.
Please note that there is no `ready` signal from the accelerator to acknowledge the acceptance of memory responses, which means its is expected that accelerator should be ready to accept data in every cycle.
