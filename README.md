# IITK-Mini-MIPS Processor

This project implements a simplified MIPS processor called IITK-Mini-MIPS, designed as part of the CS220 course assignment. The processor supports both integer and floating-point operations, with a focus on educational purposes.

## Features

- 32-bit word and instruction size
- Separate instruction and data memories (4KB each)
- 32 general-purpose registers
- 32 floating-point registers
- Support for R-type, I-type, and J-type instructions
- Basic integer arithmetic and logical operations
- IEEE 754 single-precision floating-point operations
- Branch and jump instructions
- Load and store operations

## Project Structure

```
├── src/
│ ├── alu.v 
│ ├── data_memory.v 
│ ├── fpalu.v
│ ├── instruction_decode.v 
│ ├── instruction_fetch.v 
│ ├── instruction_formats.v 
│ ├── instruction_memory.v 
│ ├── iitk_mini_mips.v 
│ └── registers.v 
│
├── testbench/
│ ├── iitk_mini_mips_tb.v 
│ ├── assembly.txt
│ ├── instructions.mem 
│ ├── run_test.do 
│ ├── mips_to_machinecode.py 
│ ├── run_simulations.do 
│ └── run_test.sh 
│
├── example_assembly.txt
├── README.md
├── .gitignore

```


## Implementation Details

### Memory System
- 4KB instruction memory (4096 x 32-bit words)
- 4KB data memory (4096 x 32-bit words)
- Word-aligned memory access
- Byte-addressable memory interface

### Register File
- 32 general-purpose registers (R0–R31)
- 32 floating-point registers (F0–F31)
- Special-purpose registers: `PC`, `HI`, `LO`
- Register R0 is hardwired to zero
- Synchronous write with write-enable

### Instruction Formats
- **R-type**: `opcode (6) | rs (5) | rt (5) | rd (5) | shamt (5) | funct (6)`
- **I-type**: `opcode (6) | rs (5) | rt (5) | immediate (16)`
- **J-type**: `opcode (6) | address (26)`

### ALU Operations
- Integer: `add`, `sub`, `mul`
- Logical: `and`, `or`, `xor`, `not`
- Shifts: `sll`, `srl`, `sla`, `sra`
- Comparison: `slt`
- Overflow and carry detection

### Floating-Point ALU
- IEEE 754 single-precision format
- Operations: `add.s`, `sub.s`, `mul.s`, `cmp.s`, `eq.s`, `lt.s`, `le.s`, `gt.s`, `ge.s`
- Handles normalized values, overflow, and underflow
- Partial handling of NaN and infinity cases


## Getting Started

### Step 1: Write your Program

Write your assembly code in the file: [`testbench/assembly.txt`](testbench/assembly.txt)

You can refer to the sample: [`example_assembly.txt`](example_assembly.txt)

Each instruction must be written on a separate line, using only the supported instruction set (see below).

### Step 2: Assemble

Run the Python-based assembler:

```bash
python3 assembler.py
```

This will convert `assembly.txt` to binary and save it in `testbench/instructions.mem`.

### Step 3: Simulate

   1. Using ModelSim:

      ```bash
      vsim -do testbench/run_simulations.do
      ```
      or 

      ```bash
      vsim -do testbench/run_test.do
      ```
      To view the waveform output:
      ```bash
      view wave
      ```
   2. Using Icarus Verilog + GTKWave:

      ```bash
      cd testbench
      ./run_test
      ```
      To view the waveform output:
      ```bash
      gtkwave dump.vcd
      ```

### Supported Instruction Set
1. Integer R-type:
   - `ADD`, `SUB`, `AND`, `OR`, `XOR`, `NOT`
   - `SLT`, `MADD`, `MUL`
2. Shifts: 
   - `SLL`, `SRL`, `SRA`, `SLA`
3. Integer I-type:
   - `ADDI`, `ANDI`, `ORI`, `XORI`
4. Load word:
   - `LW`
5. Store word:
   - `SW`
6. Branch type:
   - `BEQ`
6. J-type:
   - `JUMP`, `JAL`
7. Floating-Point Operations:
   - `FP_ADD`, `FP_SUB`, `FP_MUL`
   - Comparisons: `FP_EQ`, `FP_LT`, `FP_LE`, `FP_GT`, `FP_GE`, `FP_CMP`
8. Special:
   - `FINISH` — Halts the processor

### Example Program
- See [`example_assembly.txt`](example_assembly.txt) for a complete working sample.

### Requirements
- Python 3
- ModelSim
- Or Icarus Verilog and GTKWave

## Usage

1. Clone the repository
2. Write your program in `testbench/assembly.txt`
3. Run `python3 assembler.py` to generate `instructions.mem`
4. Simulate using `ModelSim` or `Icarus Verilog`
5. Modify test programs to explore various instructions

## Contributing

This is an educational project. Feel free to use and modify the code for learning purposes.

## License

This project is part of the CS220: Computer Architecture coursework at IIT Kanpur and should be used in accordance with academic integrity policies. 