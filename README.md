# LBIST Function Implementation

## Overview

This project implements a Logic Built-In Self-Test (LBIST) architecture using Verilog HDL. The design generates test patterns using an LFSR, applies them through a scan chain, and compresses responses using a MISR for fault detection.

## Features

* LFSR-based Pseudo Random Pattern Generator (PRPG)
* Clock Divider for slow scan clock generation
* Segment Counter and Segment Decoder
* Scan Chain for test data shifting
* MISR (Multiple Input Signature Register) for signature analysis
* Droop Control Logic
* Complete LBIST Top Module

## Modules

* lfsr
* clock_divider
* segment_counter
* segment_decoder
* scan_chain
* misr
* droop_controller
* lbist_top

## Tools Used

* Verilog HDL
* Xilinx Vivado 2025.2

## Simulation

The design was successfully simulated using Vivado Behavioral Simulation.

## Applications

* VLSI Testing
* Built-In Self-Test (BIST)
* Fault Detection and Diagnosis
* Digital IC Verification

## Author

Hima Bindhu
