from nxpython import *

# clk_i : 100MHz
p.createClock(name = "Clock", period = 10, target = "getClockNet(clk_i)")
