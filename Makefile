BUILD_DIR := ./build
SRC_DIRS := ./src

SRCS = $(shell find $(SRC_DIRS) -name '*.v')
OUT = $(BUILD_DIR)/verilog_test
VCD = $(BUILD_DIR)/dump.vcd

all: $(VCD)

$(OUT): $(SRCS)
	mkdir -p $(dir $@)
	iverilog -D 'DUMP_FILE="$(VCD)"' -o $(OUT) $^

$(VCD): $(OUT)
	vvp $<

wave: $(VCD)
	gtkwave $<

clean:
	rm -rf $(BUILD_DIR)

run: $(OUT)
	vvp $<

.PHONY: clean run wave
