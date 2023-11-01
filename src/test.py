import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_mvm(dut):

    dut._log.info("start")

    clock = Clock(dut.clk, 1, units= 'ns')
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut.ena.value = 1

    VALUES = [32,14,15,7]
    ROWS = [0,1,1,2]
    COLS = [2,0,2,1]
    i = 0
    j = 0
    num = 0

    list = [0]*8
    list[7] = 0
    list[6] = 0
    list[5] = 1
    list[4] = 0
    list[3] = 1
    list[2] = 0
    list[1] = 0
    list[0]= 0

    for j in range(8):
        num = (list[j]*(2^j)) + num

    dut.ui_in.value = VALUES[i]
    dut.uio_in.value = num
    dut._log.info(list)

    await ClockCycles(dut.clk, 1)

    list[3] = 0
    for j in range(8):
        num = (list[j]*(2^j)) + num
    dut.uio_in.value = num

    await ClockCycles(dut.clk, 10)
    
    i=1
    j=0

    list[7] = 0
    list[6] = 1
    list[5] = 0
    list[4] = 0
    list[3] = 1
    list[2] = 0
    list[1] = 0
    list[0]= 0
    
    for j in range(8):
        num = (list[j]*(2^j)) + num
    
    dut.ui_in.value = VALUES[i]
    dut.uio_in.value = num
    
    await ClockCycles(dut.clk, 1)

    list[3] = 0
    for j in range(8):
        num = (list[j]*(2^j)) + num
    dut.uio_in.value = num

    await ClockCycles(dut.clk, 10)

    i=2
    j=0

    list[7] = 0
    list[6] = 1
    list[5] = 1
    list[4] = 0
    list[3] = 1
    list[2] = 0
    list[1] = 0
    list[0]= 0
    
    for j in range(8):
        num = (list[j]*(2^j)) + num

    dut.ui_in.value = VALUES[i]
    dut.uio_in.value = num

    await ClockCycles(dut.clk, 1)

    list[3] = 0
    for j in range(8):
        num = (list[j]*(2^j)) + num
    dut.uio_in.value = num

    await ClockCycles(dut.clk, 10)

    i=3
    j=0

    list[7] = 1
    list[6] = 0
    list[5] = 0
    list[4] = 1
    list[3] = 1
    list[2] = 0
    list[1] = 0
    list[0]= 0
    
    for j in range(8):
        num = (list[j]*(2^j)) + num


    dut.ui_in.value = VALUES[i]
    dut.uio_in.value = num

    await ClockCycles(dut.clk, 1)

    list[3] = 0
    for j in range(8):
        num = (list[j]*(2^j)) + num
    dut.uio_in.value = num

    await ClockCycles(dut.clk, 10)

    j=0

    list[2] = 1
    for j in range(8):
        num = (list[j]*(2^j)) + num

    dut.ui_in.value = 5
    dut.uio_in.value = num


    for _ in range(100):    # runs for 100 clk cycles
        await RisingEdge(dut.clk)
    
    dut._log.info("Finished Test!")


