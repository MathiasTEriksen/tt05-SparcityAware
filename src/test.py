import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, Timer, ClockCycles

@cocotb.test()
async def test_mvm(dut):

    dut._log.info("TEST CASE 1")

    clock = Clock(dut.clk, 1, units= 'ns')
    cocotb.start_soon(clock.start())

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut.uio_in.value = 0b00101000

    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00100000
    await ClockCycles(dut.clk, 10)

    

    VALUES = [32,14,15,7]
    ROWS = [0,1,1,2]
    COLS = [2,0,2,1]

    dut.ui_in.value = VALUES[0]
    dut.uio_in.value = 0b00101000
    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00100000
    await ClockCycles(dut.clk, 10)

    i=1
    
    dut.ui_in.value = VALUES[1]
    dut.uio_in.value = 0b01001000
    

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00100000
    await ClockCycles(dut.clk, 10)

    i=2
    
    dut.ui_in.value = VALUES[2]
    dut.uio_in.value = 0b01101000

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00100000
    await ClockCycles(dut.clk, 10)

    i=3

    
    dut.ui_in.value = VALUES[3]
    dut.uio_in.value = 0b10011000

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00100000
    await ClockCycles(dut.clk, 10)

    dut.ui_in.value = 0b101
    dut.uio_in.value = 0b00001100

    dut.ena.value = 0


    for _ in range(100):    # runs for 100 clk cycles
        await RisingEdge(dut.clk)


    
    dut._log.info("TEST CASE 2")

    dut.rst_n.value = 0
    await ClockCycles(dut.clk, 10)
    dut.rst_n.value = 1
    dut.uio_in.value = 0b00101000

    dut.uio_in.value = 0b00101000
    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00100000
    await ClockCycles(dut.clk, 10)

    VALUES = [9, 8, 7, 6, 5, 4, 3, 2, 1]
    ROWS = [0, 0, 0, 1, 1, 1, 2, 2, 2,]
    COLS = [0, 0, 0, 1, 1, 1, 2, 2, 2,]

    dut.ui_in.value = VALUES[0]
    dut.uio_in.value = 0b00001000
    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 10)

    dut.ui_in.value = VALUES[1]
    dut.uio_in.value = 0b00001000
    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 10)

    dut.ui_in.value = VALUES[2]
    dut.uio_in.value = 0b00001000
    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 10)

    dut.ui_in.value = VALUES[3]
    dut.uio_in.value = 0b01011000
    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 10)

    dut.ui_in.value = VALUES[4]
    dut.uio_in.value = 0b01011000
    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 10)

    dut.ui_in.value = VALUES[5]
    dut.uio_in.value = 0b01011000
    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 10)

    dut.ui_in.value = VALUES[6]
    dut.uio_in.value = 0b10101000
    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 10)

    dut.ui_in.value = VALUES[7]
    dut.uio_in.value = 0b10101000
    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 10)

    dut.ui_in.value = VALUES[8]
    dut.uio_in.value = 0b10101000
    dut.ena.value = 1

    await ClockCycles(dut.clk, 1)
    dut.uio_in.value = 0b00000000
    await ClockCycles(dut.clk, 10)

    dut.ui_in.value = 0b111
    dut.uio_in.value = 0b00001100

    await ClockCycles(dut.clk, 5)

    temp = dut.uio_out.value

    # assert  dut.uo_out.value == 6, "Failed first number"
    
    dut._log.info(temp)

    dut.ena.value = 0

    for _ in range(100):    # runs for 100 clk cycles
        await RisingEdge(dut.clk)
 

    
    dut._log.info("Finished Test!")



