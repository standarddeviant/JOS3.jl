# JOS3.jl
This project contains Julia implementations of functions or scripts from books by Julius Orion Smith III.  These books are available online:
1. [Mathematics of the Discrete Fourier Transform (DFT)](https://ccrma.stanford.edu/~jos/mdft/)
2. [Introduction to Digital Filters](https://ccrma.stanford.edu/~jos/filters/)
3. [Physical Audio Signal Processing](https://ccrma.stanford.edu/~jos/pasp/)
4. [Spectral Audio Signal Processing](https://ccrma.stanford.edu/~jos/sasp/)

This project aims to faithfully translate MATLAB functions from these books to Julia.

## Getting Started

To use the Julia functions
1. Clone this repository
2. run TBD / FIXME

To design a minimum phase spectrum
```
s = randn(1024,1) + im*randn(1024);
s_minphase = mps(s);
```

### Installing
TBD

## Running the tests

To run the tests, the required software is
* MATLAB ( >= R2016a )
* Julia ( >= 0.6 )
* mexjulia

mexjulia must be installed and configured in MATLAB. Please see [mexjulia](https://github.com/twadleigh/mexjulia) for instructions. 

Via the MATLAB terminal:
1. Add path to mexjulia, wherever it is located on your machine
    * `addpath('C:\path\to\mexjulia')`
2. Change directory to a particular JOS3.jl book
    * `cd('C:\path\to\JOS3.jl\filters')`
3. Run runtests.m
    * `run('runtests.m')`

This runs a test for each function that compares the original copy/pasted MATLAB function
and the translated Julia function. 
If all returned elements of the MATLAB and Julia matrices are within a tolerance, the test is passed.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details

## Acknowledgments

* Julius Orion Smith III for writing wonderful books and the original matlab implementations
* Tracy Wadleigh and other contributors of mexjulia for making testing much easier
