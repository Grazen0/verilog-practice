# Verilog Practice

Verilog sources for practicing for my Computer Architecture class.

## Usage

You'll need [Icarus Verilog](https://steveicarus.github.io/iverilog/) installed
on your system. You can compile and run a particular testbench like this:

```bash
make run TB=week_1/mux21_tb
```

If you have [GTKWave](https://gtkwave.sourceforge.net/) on your system, you can
run, dump and visualize a testbench with the `wave` target, like this:

```bash
make wave TB=week_1/mux21_tb
```
