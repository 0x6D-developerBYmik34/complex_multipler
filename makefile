
ifeq ($(origin OS),environment)
  WSL_PREFIX = "wsl"
else
  WSL_PREFIX = ""
endif

VIVADO_BACK_ARG = -log ./build/vivado_run.log -journal ./build/vivado_run.jou

.PHONY: xsim
xsim:
	-@$(WSL_PREFIX) mkdir build
	-@$(WSL_PREFIX) mkdir build/sim_out
	cd ./build/sim_out && \
	xvlog --sv "./../../hdl/compl_multipler.sv" "./../../tb/tb.sv" && \
	xelab -debug typical -top tb -snapshot tb_snapshot && \
	xsim tb_snapshot -gui -tclbatch "./../../scripts/xsim_wave.tcl" && \
	cd ./../..

.PHONY: syn
syn:
	-@$(WSL_PREFIX) mkdir build
	vivado -mode batch -source "scripts/vivado_syn.tcl" $(VIVADO_BACK_ARG)
