# SystemVerilog Non-Pipelined & Pipelined CPU Architectures

This repository contains SystemVerilog implementations of a custom 16-bit RISC-like CPU architecture, featuring both a **Single-Cycle (Non-Pipelined)** reference design and a **4-Stage Pipelined** CPU implementation.

---

## 📌 Context & Acknowledgments

* **Reference Baseline:** The single-cycle non-pipelined CPU (`Nonpipelined_cpu.sv`) is based on the reference design from the SystemVerilog Digital Design workshop materials developed by **Abarajithan (aba)** for CSE 140 Digital Design.
* **Upstream Workshop Repository:** [abarajithan11/digital-design](https://github.com/abarajithan11/digital-design) ([abapages.com/digital-design](https://abapages.com/digital-design/))
* **EDA & Tooling Support:** 
  * **FPGA:** Intel Quartus Prime (Targeting Intel Cyclone IV E FPGA).
  * **ASIC Flow:** OpenROAD Flow Scripts (ORFS), Yosys, and KLayout via Docker for GDSII layout generation.

---

## 🏗 System Architecture

### 1. Single-Cycle (Non-Pipelined) CPU (`Nonpipelined_cpu.sv`)
* Single-cycle execution architecture.
* 8-bit instruction & data memory addressing (`imem_addr`, `dmem_addr`).
* 16-bit instruction format with 16 general-purpose 16-bit registers (`regs[0..15]`).
* **Supported Opcodes:**
  * `LOAD` (`4'd0`): Load data from memory into a register.
  * `STORE` (`4'd1`): Store data from a register into memory.
  * `MOVE` (`4'd2`): Register-to-register data transfer.
  * `ADD` (`4'd3`), `SUB` (`4'd4`), `MUL` (`4'd5`): Arithmetic logic operations.
  * `JNZ` (`4'd6`): Jump to address if register value is non-zero.

---

### 2. 4-Stage Pipelined CPU (`Pcpu.sv`)
The 4-stage pipelined architecture decouples instruction processing across pipeline stage buffers (`Pbuffer.sv`):

```
+---------------+     +-----------+     +----------------+     +-----------+     +-----------------+     +-----------+     +-------------------+
|  Pfetch.sv    | --> | Pbuffer1  | --> |  Pdecode.sv    | --> | Pbuffer2  | --> |  Pexecute.sv    | --> | Pbuffer3  | --> |  Pwriteback.sv    |
| (Instruction) |     |  (24-bit) |     | (Reg Read/Dec) |     |  (24-bit) |     | (ALU & DMem En) |     |  (24-bit) |     | (Reg Write-Back)  |
+---------------+     +-----------+     +----------------+     +-----------+     +-----------------+     +-----------+     +-------------------+
```

#### Module Hierarchy & Description:
* [`Nonpipelined_cpu.sv`](Nonpipelined_cpu.sv): Reference single-cycle processor model.
* [`Pcpu.sv`](Pcpu.sv): Top-level pipelined processor module connecting pipeline stages and register state.
* [`Pfetch.sv`](Pfetch.sv): Program Counter (PC) increment/branch logic and instruction fetch stage.
* [`Pdecode.sv`](Pdecode.sv): Opcode and operand field instruction decoder.
* [`Pexecute.sv`](Pexecute.sv): Register operand fetching, ALU computations, memory write signals, and branch condition testing.
* [`Pwriteback.sv`](Pwriteback.sv): Write-back stage determining register write data and write enable (`wb_en`).
* [`Pbuffer.sv`](Pbuffer.sv): Generic 24-bit parameterized pipeline register buffer.

---

## 🛠 FPGA Synthesis (Intel Quartus Prime)

* **Project File:** [`piplined_cpu.qpf`](piplined_cpu.qpf)
* **Settings File:** [`piplined_cpu.qsf`](piplined_cpu.qsf)
* **Target Device:** Cyclone IV E (`EP4CE75F29I8L`)

To compile the project in Quartus Prime:
1. Open [`piplined_cpu.qpf`](piplined_cpu.qpf) in Intel Quartus Prime.
2. Run **Start Compilation** (Ctrl+L) to synthesize, place, and route for Cyclone IV E.

---

## 🔬 ASIC Synthesis & Physical Layout (GDSII)

You can run logic synthesis and physical place-and-route to generate an ASIC GDSII stream using the OpenROAD / Yosys Docker environment from the digital-design workshop.

### Step-by-Step ASIC Flow

#### 1. Clone & Setup the Docker Workshop Environment
```bash
git clone https://github.com/abarajithan11/digital-design.git
cd digital-design
```

#### 2. Start and Enter the Container
```bash
# Pull/start the Docker environment (requires Docker Desktop / WSL2)
make fresh

# Enter the interactive shell inside the container
make enter
```

#### 3. Copy CPU SystemVerilog Files
Copy your SystemVerilog files into `material/rtl/cpu/`:
- `Pcpu.sv`, `Pfetch.sv`, `Pdecode.sv`, `Pexecute.sv`, `Pwriteback.sv`, `Pbuffer.sv`

#### 4. Create Design Filelist (`.f` file)
Create `material/designs/cpu/pcpu.f` specifying your source files:
```text
rtl/cpu/Pcpu.sv
rtl/cpu/Pfetch.sv
rtl/cpu/Pdecode.sv
rtl/cpu/Pexecute.sv
rtl/cpu/Pwriteback.sv
rtl/cpu/Pbuffer.sv
```

#### 5. Execute ASIC Flow (OpenROAD & Yosys)
Inside the container (`make enter`), execute:
```bash
# Build for default ASAP7 (7nm predictive PDK)
make gds DESIGN=pcpu

# Alternatively, target SkyWater 130nm PDK (Sky130)
make gds DESIGN=pcpu PDK=sky130hd
```

**Flow Steps Executed Automatically:**
1. **RTL Synthesis:** Synthesizes SystemVerilog into gate netlists (`1_2_yosys.v`) using Yosys.
2. **Floorplanning & Power Distribution:** Defines chip die area and power grids.
3. **Placement & CTS:** Standard cell placement and Clock Tree Synthesis.
4. **Routing & STA:** Detailed routing and Static Timing Analysis.
5. **GDSII Stream Export:** Final mask layout saved to `material/openroad/work/results/<PDK>/Pcpu/base/6_final.gds`.

#### 6. Layout Inspection & Visualization
```bash
# View synthesized gate-level netlist
make show_syn_netlist DESIGN=pcpu

# View 2D GDS layout in KLayout (requires GUI/VNC enabled)
make show_layout DESIGN=pcpu

# View 3D chip model in OpenSCAD
make show_3d DESIGN=pcpu
```

---

## 📜 Credits & License

* The single-cycle baseline reference design and open-source ASIC Docker workflow are adapted from **Abarajithan's (aba)** [SystemVerilog Digital Design Course / Workshop](https://github.com/abarajithan11/digital-design).
* The 4-stage pipelined architecture implementation (`Pcpu.sv`) and modular pipeline stages were developed as part of Digital System Design (DSD) coursework.
