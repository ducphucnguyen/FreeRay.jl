# Bellhop and FreeRay.jl

As we may already know, Bellhop is open-source software to perform both 2D and 3D ray tracing. Bellhop is a highly efficient ray tracing program written in Fortran by Michael Porter. Bellhop is widely-used for predicting acoustic pressure fields in ocean environments. We here will see how to adapt this program to outdoor sound propagation problems in atmospheric environments.

To run Bellhop, we need to write input files and then read output files for plotting. These things sometimes are inconvenient for those who are not often working with low-level programming languages. In this tutorial, we will use FreeRay.jl package to model fundamental outdoor sound propagations problems. FreeRay can be used to write input files, run Bellhop, read and plot output such as ray tracing and transmission loss plots. We will also see how to use FreeRay for parallel modelling sound propagation problems.

# Install Bellhop

Before we can use FreeRay, we need to install Bellhop first. The source code can be download from this website (http://oalib.hlsresearch.com/AcousticsToolbox/). installation details are provided in the website. If you have no experience with programming languages such as C or Fortran, it will take sometime to install Bellhop!

# Check successful installation

To check if Bellhop is successfully installed, we run this command in Julia REPL. If we can see the bellow error, this means that we successfully install Bellhop.  Congratulation!

```julia
run(`bellhop`)

STOP Fatal Error: Check the print file for details
Process(`bellhop`, ProcessExited(0))
```
