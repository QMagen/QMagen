# QMagen_Matlab # 
## Introduction ##
QMagen is a package for the finite-temperature many-body simulations and an advanced tool for thermal data analysis of magnetic quantum materials.
The program consists of two main parts: 
### Many-Body Sovlers ###
* Exact diagonalization (ED, as a high-T solver);
* Linearized tensor renormalization group (LTRG, as a full-T solver for 1D spin chain);
* Exponential tensor renormalization group (XTRG, as a full-T solver for 2D system).
### Optimizer ###
* Bayesian optimization.

## Try Your First QMagen Program ##
This program be used in the following two typical circumstances (and possibly others):
* Learning model Hamiltonian according to thermodynamic experimental data by Bayesian optimization: \
  **RunScript/RunOpt.m**;
* Carrying out many-body calculation on specific model: \
  **RunScript/RunMBSolver.m**.
