![](../../workflows/gds/badge.svg) ![](../../workflows/docs/badge.svg) ![](../../workflows/test/badge.svg)


MVM Accelerator for CSR Format
==============================
**Author:** *Mathias Eriksen*

# What is Tiny Tapeout?

TinyTapeout is an educational project that aims to make it easier and cheaper than ever to get your digital designs manufactured on a real chip.

My project is described below, including a 2D view of the die layout created by the Openlan .v to GDSII process. 

To learn more and get started, visit https://tinytapeout.com.

## What this Project Does

This project takes in a 3x3 weight matrix in Compressed Sparse Row format,
with the weight values being quantized and 8 bits long. It also takes in the corresponding
temporal 3 bit spike train. It then computes the matrix vector multiplication
product and outputs the resulting vector on the output line.

## How it Works

Uses a set of registers and flags from the CPU to fetch the weight matrix in CSR format 
as well as the spike train. The values are passed in one at a time, and the entire matrix
is loaded into registers that are internal to the IC.

Once the full sparse matrix and spike train are loaded in, an algorithm is used to compute
the resultant vector of the matrix vector multiplication of the weight matrix and the spike train.

Finally, the output vector is transmitted on the output line, along with a flag bit which flips
each time a new value is sent out.

## How to Test

After reset, send values in CSR format using the input bits described below. Send a value by toggling
he sending CPU flag for one clock cycle while the values are in their respective registers. Repeat
for the entire matrix, toggling the sending CPU flag low between each value. Then, check the return
values by waiting for the sending out flag from the IC to flip. After the first flip, the other
two values will be sent on each clock edge. 

## Pinout

# Input (ui_in bits 0-7):  
    - Input Value bit 0             
    - Input Value bit 1
    - Input Value bit 2
    - Input Value bit 3
    - Input Value bit 4
    - Input Value bit 5
    - Input Value bit 6
    - Input Value bit 7
# Output (uo_out bits 0-7)
    - Output Value bit 0
    - Output Value bit 1 
    - Output Value bit 2
    - Output Value bit 3
    - Output Value bit 4
    - Output Value bit 5
    - Output Value bit 6
    - Output Value bit 7
# bidirectional (uio_out 0-7):
    - FETCH Ready flag (out)
    - Sending out flag  (out)
    - Done sending flag (in)
    - Sending CPU flag (in)
    - Column Value bit 0
    - Column Value bit 1
    - Row Value bit 0
    - Row Value bit 1

# 2D IC view

![2D](Images/ICView.png)

