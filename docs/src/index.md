# FreeRay : Bellhop for Outdoor Sound Propagation

```@raw html
<p align="center">
    <img width=500 height=400 src="../../plot.PNG">
</p>
```

FreeRay.jl is a library for outdoor noise propagation. Numerical ray tracing models are implemented using Bellhop ray tracing program written in Fortran by Michael Porter. FreeRay.jl provides utilities for

1. Prepare input files, run Bellhop and plot output.
2. Run Bellhop parallel.

## Installation
### FreeRay.jl package

Download [Julia 1.5](https://julialang.org/) or later.

FreeRay.jl is under development and thus is not registered. To install it simply open a julia REPL and do

```Julia
`] add https://github.com/ducphucnguyen/FreeRay.jl.git`.
```

### Installation Bellhop
Before we can use FreeRay, we need to install Bellhop first. The source code can be download from this website [Bellhop](http://oalib.hlsresearch.com/AcousticsToolbox/). installation details are provided in the website. If you have no experience with programming languages such as C or Fortran, it will take sometime to install Bellhop!

To check if Bellhop is successfully installed, we run this command in Julia REPL. If we can see the bellow error, this means that we successfully install Bellhop.  Congratulation!

```julia
run(`bellhop`)

STOP Fatal Error: Check the print file for details
Process(`bellhop`, ProcessExited(0))
```


## Supporting and Citing

This software was developed as part of academic research. If you would like to help support it, please star the repository. If you use this software as part of your research, teaching, or other activities, we would be grateful if you could cite:

```
@article{nguyen2020machine,
  title={A machine learning approach for detecting wind farm noise amplitude modulation},
  author={Nguyen, Duc Phuc and Hansen, Kristy and Lechat, Bastien and Catcheside, Peter and Zajamsek, Branko},
  year={2020},
  publisher={Preprints}
}
```

## Contribution Guidelines

This package is written and maintained by [Duc Phuc Nguyen](https://github.com/ducphucnguyen). Please fork and
send a pull request or create a [GitHub issue](https://github.com/ducphucnguyen/FreeRay.jl/issues) for
bug reports. If you are submitting a pull request make sure to follow the official
[Julia Style Guide](https://docs.julialang.org/en/v1/manual/style-guide/index.html) and please use
4 spaces and NOT tabs.


## Contents

### Home

```@contents
Pages = [
    "index.md"
]
Depth = 2
```

### Getting Started Tutorials

```@contents
Pages = [
    "benchmark_case.md",
    "getting_started/inverse_lighting.md",
    "getting_started/optim_compatibility.md"
]
Depth = 2
```

### API Documentation

```@contents
Pages = [
    "api/utilities.md",
    "api/differentiation.md",
    "api/scene.md",
    "api/optimization.md",
    "api/renderers.md",
    "api/accelerators.md"
]
Depth = 2
```

## Index

```@index
```
