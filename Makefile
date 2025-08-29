BUILD_DIR := ./build
SRC_DIRS := ./src

SRCS = $(shell find $(SRC_DIRS) -name '*.v')
OUT = $(BUILD_DIR)/sim.out
VCD = $(BUILD_DIR)/dump.vcd

all: $(VCD)

$(OUT): $(SRCS)
	mkdir -p $(dir $@)
	iverilog -o $(OUT) $^

$(VCD): $(OUT)
	vvp $^

wave: $(VCD)
	gtkwave $(VCD) &

clean:
	rm -rf $(BUILD_DIR)

.PHONY: clean
