BUILDDIR  = ./build
FPGA_TYPE = hx1k
FPGA_PKG  = vq100
PCF = ice40hx1k-evb.pcf
RMDIR = rmdir

SRCS = $(wildcard *.v)
TOP = blinky
TB = $(basename $(wildcard *_tb.v))

SIMOUT = $(BUILDDIR)/sim.vvp
WAVE = $(BUILDDIR)/$(TB).vcd


# Targets
all: $(BUILDDIR)/$(TOP).rpt $(BUILDDIR)/$(TOP).bin

$(BUILDDIR)/$(TOP).json: $(SRCS)
	@mkdir -p $(@D)
	yosys -ql $(BUILDDIR)/$(TOP).log -p 'synth_ice40 -abc9 -device u -top $(TOP) -json $@' $(SRCS)


$(TOP).asc: $(BUILDDIR)/$(TOP).json
	nextpnr-ice40 --$(FPGA_TYPE) --package $(FPGA_PKG) --json $< --pcf $(PCF) --asc $@

$(BUILDDIR)/$(TOP).bin: $(TOP).asc
	icepack $< $@

$(BUILDDIR)/$(TOP).rpt: $(TOP).asc
	icetime -d $(FPGA_TYPE) -mtr $@ $<

$(SIMOUT): $(SRCS)
	@mkdir -p $(dir $@)
	iverilog -g2012 -o $@ $(SRCS)

sim: $(SIMOUT)
	vvp $(SIMOUT)
	gtkwave $(WAVE)


clean:
	rm -f $(BUILDDIR)/*.asc $(BUILDDIR)/*.bin $(BUILDDIR)/*.rpt $(BUILDDIR)/*.log $(BUILDDIR)/*.json $(BUILDDIR)/*.vcd $(BUILDDIR)/*.vvp $(TOP).asc
	$(RMDIR) $(BUILDDIR)

# Uncomment this line if you want to keep the intermediate .json and .asc files
# .PRECIOUS: $(BUILDDIR)/%.json %.asc

.PHONY: all prog clean all
