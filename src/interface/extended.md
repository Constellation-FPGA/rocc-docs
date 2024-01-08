# Extended Interface
These signals are included only if RoCC is configured to include them.
Please note the below list of signals is not comprehensive but only for representational purposes.

## TileLink
There are two type of TileLink connections: arbitrated and non-arbitrated, and both are not handled by the cache subsystem of Rocket.
Arbitrated uncached tilelink is abbreviated aUTL.
The unarbitrated uncached tilelink is abbreviated UTL.
The UTL group is composed of 2 subgroups namely aUTL which is arbitrated uncached tile link signals and UTL signals.

### Arbitrated Uncached TileLink (aUTL)
aUTL is arbitrated with the I-cache link to L2 memory system.
The aUTL set of signals is composed of AUTL acquire and grant subgroups as listed below.
All aUTL tables are prefixed with `autl_`.

#### aUTL Acquire/Request
| Direction      | Signal Name                         | Default Value | Description                                                |
|----------------|-------------------------------------|---------------|------------------------------------------------------------|
| Input          | `autl_acquire_ready`                | `false.B`     | Is the aUTL acquire system ready to receive a request?     |
| Output         | `autl_acquire_valid`                | `false.B`     | Is the aUTL acquire request made by the accelerator valid? |
| Output [25:0]  | `autl_acquite_bits_addr_block`      |               | Currently unknown.                                         |
| Output [2:0]   | `autl_acquire_bits_clients_xact_id` |               | Currently unknown.                                         |
| Output [1:0]   | `autl_acquire_bits_addr_beat`       |               | Currently unknown.                                         |
| Output         | `autl_acquire_bits_is_builtin_type` |               | Currently unknown.                                         |
| Output [2:0]   | `autl_acquire_bits_a_type`          |               | Currently unknown.                                         |
| Output [16:0]  | `autl_acquire_bits_union`           |               | Currently unknown.                                         |
| Output [127:0] | `autl_acquire_bits_data`            |               | Currently unknown.                                         |

#### aUTL Grant/Response
| Direction     | Signal Name                       | Default Value | Description                                                |
|---------------|-----------------------------------|---------------|------------------------------------------------------------|
| Output        | `autl_grant_ready`                | `false.B`     | Is the accelerator ready to accept an aUTL grant response? |
| Input         | `autl_grant_valid`                | `false.B`     | Is the aUTL grant response valid?                          |
| Input [1:0]   | `autl_grant_bits_addr_beat`       |               | Currently unknown.                                         |
| Input [2:0]   | `autl_grant_bits_client_xact`     |               | Currently unknown.                                         |
| Input [3:0]   | `autl_grant_bits_manager_xact`    |               | Currently unknown.                                         |
| Input         | `autl_grant_bits_is_builtin_type` |               | Currently unknown.                                         |
| Input [3:0]   | `autl_grant_bits_g_type`          |               | Currently unknown.                                         |
| Input [127:0] | `autl_grant_bits_data`            |               | Currently unknown.                                         |

### Uncached TileLink (UTL)
The UTL signals are a vector of signals of the same type as aUTL.
The size of the UTL vector is equal to the number of independent memory channels, which is configurable in the rocket core.
However these signals have yet to be investigated and added to this document.

## Floating Point Unit (FPU)
This interface may be used by the accelerator if it has a floating point unit attached to it.
All the signal names are prefixed with `fpu_` to denote the group they belong to.
The interface is composed of FP request and FP response sub-bundles, as shown below.

### Floating-Point Request
| Direction         | Signal Name          | Default Value | Description                                         |
|-------------------|----------------------|---------------|-----------------------------------------------------|
| Input             | `fpu_req_ready`      | `false.B`     | Is the FPU ready to accept a request?               |
| Output            | `fpu_req_valid`      | `false.B`     | Is the accelerator's FPU request valid?             |
| Output [1:0]      | `fpu_req_fmaCmd`     |               | Currently unknown.                                  |
| Output [1:0]      | `fpu_req_typ`        |               | Currently unknown.                                  |
| Output [1:0]      | `fpu_req_fmt`        |               | Currently unknown.                                  |
| Output [`fLen+1`] | `fpu_req_in1`        | `0.U`         | Input value 1 to FPU.                               |
| Output [`fLen+1`] | `fpu_req_in2`        | `0.U`         | Input value 2 to FPU.                               |
| Output [`fLen+1`] | `fpu_req_in3`        | `0.U`         | Input value 3 to FPU.                               |
| Output            | `fpu_req_ldst`       | `false.B`     | Currently unknown.                                  |
| output            | `fpu_req_wen`        | `false.B`     | Currently unknown.                                  |
| Output            | `fpu_req_ren1`       | `false.B`     | Read `in1` data for use?                            |
| Output            | `fpu_req_ren2`       | `false.B`     | Read `in2` data for use?                            |
| Output            | `fpu_req_ren3`       | `false.B`     | Read `in3` data for use?                            |
| Output            | `fpu_req_swap12`     | `false.B`     | Swap `in1` and `in2` data?                          |
| Output            | `fpu_req_swap23`     | `false.B`     | Swap `in2` and `in3` data?                          |
| Output [1:0]      | `fpu_req_typeTagIn`  | `0.U`         | Currently unknown.                                  |
| Output [1:0]      | `fpu_req_typeTagOut` | `0.U`         | Currently unknown.                                  |
| Output            | `fpu_req_fromint`    | `false.B`     | Convert input data from integer to floating-point?  |
| Output            | `fpu_req_toint`      | `false.B`     | Convert input data from floating-point to integer?  |
| Output            | `fpu_req_fastpipe`   | `false.B`     | Currently unknown.                                  |
| Output            | `fpu_req_fma`        | `false.B`     | Perform fused multiply-accumulate? **CONFIRM THIS** |
| Output            | `fpu_req_div`        | `false.B`     | Perform division? **CONFIRM THIS**                  |
| Output            | `fpu_req_sqrt`       | `false.B`     | Perform a square root? **CONFIRM THIS**             |
| Output            | `fpu_req_wflags`     | `false.B`     | Currently unknown.                                                    |

### Floating-Point Response
| Direction                      | Signal Name          | Default Value | Description                                                 |
|--------------------------------|----------------------|---------------|-------------------------------------------------------------|
| Output                         | `fpu_resp_ready`     | `false.B`     | Is the accelerator ready to accept a response from the FPU? |
| Input                          | `fpu_resp_valid`     | `false.B`     | Is the response sent by the FPU valid?                      |
| Input [`fLen+1`]               | `fpu_resp_bits_data` | Data          | Value computed by FPU.                                      |
| Input [`FPConstants.FLAGS_SZ`] | `fpu_resp_bits_exc`  | `0.U`         | Currently unknown.                                          |

## Control Status Register (CSR)
Control status registers may be used optionally within the accelerator.
If they exist, the interface signals in Table 10 can be used by the operating system on the core to memory map the accelerator.
Its mechanism is to be added and will be discussed in later versions of the document.
All the signal names are prefixed with `csr_` to denote the group they belong to.

| Direction            | Signal Name | Default Value | Description                                                                                   |
|----------------------|-------------|---------------|-----------------------------------------------------------------------------------------------|
| Input [`CSR.ADDRSZ`] | `csr_waddr` | Address       | Address of the CSR to write to.                                                               |
| Input [63:0]         | `csr_wdata` | Data          | Data to write into a CSR.<br>NOTE: Must be present for every request. Can be `0.U` for reads. |
| Input                | `csr_wen`   | `false.B`     | Write-enable. Should data be written to the CSR?                                              |
| Output [63:0]        | `csr_rdata` | Data          | Contents of the CSR read from.                                                                |

## Page Table Walker (PTW)
The page table walker signals are used for address translation from the accelerator (if the core isn’t already handling it).
These signals will be added as a part of future work.
All the signal names will be prefixed with `ptw_` to denote the group they belong to.

Please stay tuned for updates.
