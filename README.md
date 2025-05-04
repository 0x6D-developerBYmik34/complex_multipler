# Complex multipler
**Now**: simple realisation for signed complex multipler
Developing and testing with Vivado 2021.1 (for Windows need WSL)
### Quick start
- run simulation with Vivado:
    ```
    make xsim
    ```
- run synthesis with Vivado (checkpoint in `build/syn_out/post_synth.dcp`):
    ```
    make syn
    ```
    **Note**: for part xcku035 Vivado automatically pull up DSP48E2
- run netlist simulation with Vivado (after running `syn`):
    ```
    make xsim SIM_NET=1
    ```
- for run any commad with gui, add at the end `GUI=1`. Example:
    ```
    make xsim SIM_NET=1 GUI=1
    ```