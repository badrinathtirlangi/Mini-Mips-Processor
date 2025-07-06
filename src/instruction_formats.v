`define OPCODE_WIDTH 6
`define RS_WIDTH 5
`define RT_WIDTH 5
`define RD_WIDTH 5
`define SHAMT_WIDTH 5
`define FUNCT_WIDTH 6
`define IMM_WIDTH 16
`define ADDR_WIDTH 26

// Opcode
`define OP_R_TYPE    6'b000000  // R-type Instruction
`define OP_LOAD_TYPE    6'b100011  // Load Instruction
`define OP_STORE_TYPE    6'b101011  // Store Instruction
`define OP_BRANCH_TYPE    6'b000100  // Branch Instruction
`define OP_JUMP_TYPE    6'b000010  // Jump Instruction
`define OP_JAL_TYPE 6'b000011   

// Function codes for R-type instructions
`define FUNCT_ADD    6'b100000  // Add (Corrected)
`define FUNCT_SUB    6'b100010  // Subtract
`define FUNCT_ADDU   6'b100001  // Add unsigned
`define FUNCT_SUBU   6'b100011  // Subtract unsigned
`define FUNCT_AND    6'b100100  // And
`define FUNCT_OR     6'b100101  // Or
`define FUNCT_XOR    6'b100110  // Xor
`define FUNCT_NOT    6'b101010  // Not (if defined)
`define FUNCT_SLL    6'b000000  // Shift left logical
`define FUNCT_SRL    6'b000010  // Shift right logical
`define FUNCT_SLA    6'b000100  // Shift left arithmetic
`define FUNCT_SRA    6'b000111  // Shift right arithmetic
`define FUNCT_SLT    6'b101010  // Set less than
`define FUNCT_MADD   6'b000000  // Multiply and add
`define FUNCT_MADDU  6'b000001  // Multiply and add unsigned
`define FUNCT_MUL    6'b000010  // Multiply


// Floating point function codes
`define FUNCT_FP_ADD 6'b000001  // Floating point add
`define FUNCT_FP_SUB 6'b000010  // Floating point subtract
`define FUNCT_FP_EQ  6'b000011  // Floating point equal
`define FUNCT_FP_LE  6'b000100  // Floating point less than or equal
`define FUNCT_FP_LT  6'b000101  // Floating point less than
`define FUNCT_FP_GE  6'b000110  // Floating point greater than or equal
`define FUNCT_FP_GT  6'b000111  // Floating point greater than
`define FUNCT_FP_MOV 6'b001000  // Floating point move 