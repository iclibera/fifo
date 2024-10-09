# Asynchronous FIFO Module and Testbench
## Example simulation on Questa/ModelSim
### On Windows Command Prompt
```
git clone https://github.com/iclibera/fifo.git
cd fifo/
```
```
vsim -c -do sim/questa/questa.do
```
### Explanation
There are one RTL and 1 testbench file: \
\
RTL = `hdl/fifo.sv` \
Testbench = `sim/tb_fifo.sv` \
\
`questa.do` file is run on Questa/ModelSim to create and run a simulation. \
\
Testbench wrapps RTL and stimulus/checker files under it. \
\
Apply different seed values to the simulator, if different randomization set needed (via -sv_seed = $random or such).
## Usage on Verilator
Not supported yet. (some progress)
## Usage on Vivado Simulator (XSim)
Not supported yet. (some progress)
## HDL and simulation folders
### hdl
FIFO module lives under hdl/
### sim
Testbench and other files regarding simulation live under sim/ folder
## Snapshot of waves