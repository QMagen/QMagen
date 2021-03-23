# QMagen_Matlab # 
## Introduction ##
QMagen is a package for the finite-temperature many-body simulations and an advanced tool for thermal data analysis of magnetic quantum materials.
The program consists of two main parts: 
### Many-Body Sovlers ###
* Exact diagonalization (ED, as a high-*T* solver);
* Linearized tensor renormalization group (LTRG, as a full-*T* solver for 1D spin chain);
* Exponential tensor renormalization group (XTRG, as a full-*T* solver for 2D system).
### Optimizer ###
* Bayesian optimization.

## Try Your First QMagen Program ##
This program be used in the following two typical circumstances (and possibly others):
* Learning model Hamiltonian according to thermodynamic experimental data by Bayesian optimization: \
  **RunScript/RunOpt.m**;
* Carrying out many-body calculation on specific model: \
  **RunScript/RunMBSolver.m**.

Hera we give an example of automatic parameter searching.
### Basic Configuration ###
To start a QMagen job, one needs to firstly set the following parameters in **RunScript/RunOpt.m**
* **Para.ManyBodySolver**\
  To choose the many-body solver as **'ED'**, **'iLTRG'** or **'XTRG'**;
* **Para.ModelName**\
  To choose the model of material, all the available models are given in **SpinModel**;
* **Para.Mode = 'OPT'**\
  To choose the working mode as paremeter searching.
### Experimental Data ###
Import specific data and susceptibility data.
* **CmDataFile = {'FileName1'; ...}**\
  To set the file name of specific heat data.\
  The file should only cantains a N-by-2 array where
  the firsl column is temperature with Kelvin and
  the second column is corresponding specific heat with
  J mol^-1 K^-1.
* **CmDataTRange = {[T1l, T1u]; ...}**\
  To set the fitting temperature range of corresponding data.
* **CmDataField = {[B1x, B1y, B1z]; ...}**\
  To give the magentic field strength (Tesla) of experimental data.
* **CmDatagInfo = {gNum1; ...}**
  To set use which Lande factor to converse unit. Only required
  when the Lande factors are not given along *Sx, Sy, Sz* direction. 
* **ChiDataFile = {'FileName1'; ...}**\
  To set the file name of susceptibility data.\
  The file should only cantains a N-by-2 array where
  the firsl column is temperature with Kelvin and
  the second column is corresponding susceptibility with
  cm^3 mol^-1 under SI unit.
* **ChiDataTRange = {[T1l, T1u]; ...}**\
  To set the fitting temperature range of corresponding data.
* **ChiDataField = {[B1x, B1y, B1z]; ...}**\
  To give the magentic field strength (Tesla) of experimental data.
* **ChiDatagInfo = {gNum1; ...}**
  To set use which Lande factor to converse unit. Only required
  when the Lande factors are not given along *Sx, Sy, Sz* direction. 
