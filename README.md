# Advanced UVM-Inspired ALU Verification Environment

A complete **class-based constrained-random verification environment** for a pipelined Arithmetic Logic Shift Unit (ALU) developed in SystemVerilog.

## Overview

This project demonstrates a robust verification architecture for a complex ALU supporting multiple operations including addition, multiplication, logical operations, shift, rotate, reduction, bypass, and invalid cases. The environment follows **UVM-inspired** methodology using object-oriented SystemVerilog.

### Key Features

- **UVM-style Architecture**: Generator, Driver, Monitor, Scoreboard, Coverage, and Environment classes
- **Constrained Random Stimulus** with intelligent constraints
- **Self-checking Scoreboard** with golden reference model
- **Comprehensive Functional Coverage** with cross-coverage
- **SystemVerilog Assertions (SVA)** for protocol and corner case checking
- **Mailbox-based Transaction Communication**
- **Virtual Interfaces** with proper modport handling
- **2-cycle pipeline latency** handling

## Project Structure
ALU_Verification/
├── ALU.sv                  # Design Under Test (DUT)

├── Interface.sv            # ALU Interface with modports

├── Transction.sv           # Transaction class

├── Generator.sv

├── Driver.sv

├── Monitor.sv

├── Score_Board.sv

├── Coverage.sv

├── Enviroment.sv

├── SVA.sv                  # SystemVerilog Assertions

├── TB.sv                   # Testbench

├── TOP.sv                  # Top module

└── Packages/               # All packages
text## Verification Achievements

- **100% Code Coverage**
- High Functional Coverage (coverpoints + cross coverage for overflow, reduction, shift/rotate, etc.)
- Robust verification of corner cases and invalid operations
- Proper handling of synchronous reset and 2-cycle output latency

## Tools Used

- **Simulator**: QuestaSim
- **Language**: SystemVerilog (IEEE 1800)
- **Methodology**: UVM-Inspired Class-Based Verification

## How to Run

do do.txt

## Contact
zioza2002@gmail.com

Feel free to modify the content according to your specific repository and projects!
