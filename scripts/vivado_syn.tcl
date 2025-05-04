set outputDir ./build/syn_out             
file mkdir $outputDir
set gui_en $env(GUI)
puts $gui_en

set_part xcku035-fbva676-3-e
# set_part xc7a15tcsg325-1

read_verilog  [ glob ./hdl/*.sv ]
read_xdc [ glob ./sdc/*.xdc]

synth_design -top compl_multipler
write_checkpoint -force $outputDir/post_synth
write_verilog -force -mode funcsim $outputDir/post_synth.v
report_utilization -cells [get_cells -hierarchical -filter {REF_NAME == "DSP48E2"}] -file $outputDir/dsp_report.rpt

if {$gui_en} {
    start_gui
    show_schematic [get_nets]
    report_utilization -name compl_multipler_curr_util
}