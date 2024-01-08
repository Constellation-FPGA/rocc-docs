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
The core control signals listed below ensure co-ordination between the core and accelerator.
All the signal names are prefixed with `cc_` to denote the group they belong to.

| Direction | Signal Name    | Default Value | Description                                                                                    |
|-----------|----------------|---------------|------------------------------------------------------------------------------------------------|
| Output    | `cc_busy`      | `false.B`     | The accelerator has memory requests in-flight and cannot be interrupted.                       |
| Input     | `cc_status`    | `false.B`     | Set when a privileged process is running on the core.                                          |
| Output    | `cc_interrupt` | `false.B`     | Set by the accelerator to indicate a problem.                                                  |
| Input     | `cc_exception` | `false.B`     | Set by the core to signal an exception has occured.                                            |
| Input     | `host_id`      | hart ID       | Used to distinguish which command comes from which hart.<br>NOTE: Bit width = log2(num_harts) |

## Register mode (Core)
The Register mode signals are composed of the RoCC Command and Response subgroups.
All the signal names are prefixed with `core_` to denote their source.

### Accelerator Requests
The RoCC Command signals are used by the core to send instructions to the accelerator and are driven directly by the RoCC Instruction of the RISC-V ISA.
The RoCC instruction is shown in Figure 2 which indicates bit widths and positions above and below the respective fields within the instruction.

| Direction    | Signal Name            | Default Value              | Description                                                                               |
|--------------|------------------------|----------------------------|-------------------------------------------------------------------------------------------|
| Output       | `core_cmd_ready`       | `false.B`                  | Is the accelerator ready to accept a command?                                             |
| Input        | `core_cmd_valid`       | `false.B`                  | Is the command sent by the main core valid?                                               |
| Input [6:0]  | `core_cmd_inst_funct`  | funct7                     | Distinguishes accelerator instructions. The value is set by the designer.                 |
| Input [4:0]  | `core_cmd_inst_rs1`    | `rs1`                      | Register number of source register 1.                                                     |
| Input [4:0]  | `core_cmd_inst_rs2`    | `rs2`                      | Register number of source register 2.                                                     |
| Input [4:0]  | `core_cmd_inst_rd`     | `rd`                       | Register number of destination register.                                                  |
| Input        | `core_cmd_inst_xs1`    | `xs1`                      | Should source register 1 and its contents should be used?                                 |
| Input        | `core_cmd_inst_xs2`    | `xs2`                      | Should source register 2 and its contents should be used?                                 |
| Input        | `core_cmd_inst_xd`     | `xd`                       | Should the destionation register be written to?                                           |
| Input [6:0]  | `core_cmd_inst_opcode` | `1.U`, `2.U`, `3.U`, `4.U` | Custom instruction opcode to distinguish which accelerator this instruction should go to. |
| Input [63:0] | `core_cmd_rs1`         | `rs1` Data                 | Contents of source register 1.                                                            |
| Input [63:0] | `core_cmd_rs2`         | `rs2` Data                 | Contents of source register 2.                                                            |

### Accelerator Responses
An RoCC response to the command (if expected) is sent by the accelerator using the response interface.

| Direction     | Signal Name       | Default Value | Description                                                                                                          |
|---------------|-------------------|---------------|----------------------------------------------------------------------------------------------------------------------|
| Input         | `core_resp_ready` | `false.B`     | Is the core ready to receive a response from the accelerator?                                                        |
| Output        | `core_resp_valid` | `false.B`     | Is the response sent by the accelerator valid?                                                                       |
| Output [4:0]  | `core_resp_rd`    | `rd`          | Register number of destination register.<br>NOTE: Should match the destination register sent in accelerator command! |
| Output [63:0] | `core_resp_data`  | `rd` Data     | Data to write back into the destination register.                                                                    |

## Memory mode (Mem)
The memory interface is composed of Memory request and Memory response subgroups.
All the signal names are prefixed with `mem_` to denote the group they belong to.

### Memory Requests **from** Accelerator
Memory requests from the accelerator are sent out using the signals described below.

| Direction                                              | Signal Name     | Default Value | Description                                                                                           |
|--------------------------------------------------------|-----------------|---------------|-------------------------------------------------------------------------------------------------------|
| Input                                                  | `mem_req_ready` | `false.B`     | Is the memory subsystem ready to accept a memory request?                                             |
| Output                                                 | `mem_req_valid` | `false.B`     | Is the accelerator's memory request valid?                                                            |
| Output [`coreMaxAddrBits`]                             | `mem_req_addr`  | Address       | Memory address to load from/store to.                                                                 |
| Output [`dcacheReqTagBits + log2Ceil(dcacheArbPorts)`] | `mem_req_tag`   | Tag           | Tag to uniquely identify every memory request. Needed because data is returned out-of-order.          |
| Output [`MemoryOpConstants.M_SZ`]                      | `mem_req_cmd`   | Command       | One of the bit patterns from Rocket's `MemoryOpConstants` to denote what memory operation to perform. |
| Output [`log2Ceil((coreDataBytes.log2) + 1)`]          | `mem_req_size`  | Size          | How many bytes for this memory operation? Use `log2Ceil(numBytes).U` for your code.                   |
| Output                                                 | `mem_req_phys`  | `true.B`      | Set to `false.B` if addresses are virtual and need to be translated for the accelerator.              |
| Output [63:0]                                          | `mem_req_data`  | Data          | Data to store.<br>NOTE: This must be set for **all** requests. It can be set to `0.U` for loads.      |

### Memory Responses **to** Accelerator
Memory responses to the accelerator are passed through signal interface described below.
There is a response for **both** load and store requests.
Usually an accelerator may use just the tag and data fields from the response.

<div class="warning">
There is no <code>ready</code> signal from the accelerator to acknowledge the acceptance of memory responses, which means it is expected that accelerator will be ready to accept data in every cycle.
</div>

| Direction                                    | Signal Name                 | Default Value | Description                                                                   |
|----------------------------------------------|-----------------------------|---------------|-------------------------------------------------------------------------------|
| Input                                        | `mem_resp_valid`            | `false.B`     | Is this memory reponse valid?                                                 |
| Input [`coreMaxAddrBits`]                    | `mem_resp_addr`             | Address       | Memory address of this reponse.                                               |
| Input [`MemoryOpConstants.M_SZ`]             | `mem_resp_cmd`              | Command       | The command requested that caused this response.                              |
| Input [`log2Ceil((coreDataBytes.log2) + 1)`] | `mem_resp_size`             | Size          | How many bytes of data this response contains.                                |
| Input [63:0]                                 | `mem_resp_data`             | Data          | Data response to a load request. Will be undefined for stores.                |
| Input                                        | `mem_resp_has_data`         | `false.B`     | Does this response have data?<br>NOTE: Will be `false.B` for store responses! |
|----------------------------------------------|-----------------------------|---------------|-------------------------------------------------------------------------------|
| Input                                        | `mem_resp_nack`             | `false.B`     | Currently unknown.                                                            |
| Input                                        | `mem_resp_replay`           | `false.B`     | Currently unknown.                                                            |
| Input [63:0]                                 | `mem_resp_data_word_bypass` | Bypass Data   | A store may be bypassed to a read response in the same cycle.                 |
| Input [63:0]                                 | `mem_resp_store_data`       | Store Data    | The data that was stored by the store request.                                |
