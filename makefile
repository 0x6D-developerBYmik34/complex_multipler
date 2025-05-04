SIM_NET ?= 0
export GUI = 0

NETLIST_V = build/syn_out/post_synth.v

VIVADO_BACK_ARG = -log ./build/vivado_run.log -journal ./build/vivado_run.jou

ifeq ($(SIM_NET),1)
  XSIM_TARGET = xsim_netlist
else
  XSIM_TARGET = xsim_regul
endif

ifeq ($(GUI),1)
  GUI_SIM = -gui
else
  GUI_SIM =
endif

ifeq ($(origin OS),environment)
  WSL_PREFIX = "wsl"
else
  WSL_PREFIX = ""
endif

.PHONY: xsim
xsim: $(XSIM_TARGET)

.PHONY: xsim_regul
xsim_regul:
	-@$(WSL_PREFIX) mkdir build
	-@$(WSL_PREFIX) mkdir build/sim_out
	cd ./build/sim_out && \
	xvlog --sv "./../../hdl/compl_multipler.sv" "./../../tb/tb.sv" && \
	xelab -debug typical -top tb -snapshot tb_snapshot && \
	xsim tb_snapshot $(GUI_SIM) -tclbatch "./../../scripts/xsim_wave.tcl" && \
	cd ./../..

.PHONY: xsim_netlist
xsim_netlist: $(NETLIST_V)
	-@$(WSL_PREFIX) mkdir build/sim_net_out
	cd ./build/sim_net_out && \
	xvlog --sv "./../../$(NETLIST_V)" "./../../tb/tb.sv" && \
	xelab -debug typical -L unisims_ver -top tb glbl -snapshot tb_net_snapshot && \
	xsim tb_net_snapshot $(GUI_SIM) -tclbatch "./../../scripts/xsim_wave.tcl" && \
	cd ./../..

.PHONY: syn
syn:
	-@$(WSL_PREFIX) mkdir build
	vivado -mode batch -source "scripts/vivado_syn.tcl" $(VIVADO_BACK_ARG)
