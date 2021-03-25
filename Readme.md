# QMagen (v0.1.0)
## Introduction ##
QMagen is a package for the finite-temperature many-body simulations and an advanced tool for thermal data analysis of magnetic quantum materials.
The package consists of two main parts: 
### Many-Body Sovlers ###
* Exact diagonalization (ED, as a high-*T* solver);
* Linearized tensor renormalization group (LTRG, as a low-*T* solver for 1D spin chain);
* Exponential tensor renormalization group (XTRG, as a low-*T* solver for 2D system).
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
  the first column is temperature in Kelvin and
  the second column is corresponding specific heat with
  J mol^-1 K^-1.
* **CmDataTRange = {[T1, T2]; ...}**\
  To set the fitting temperature range of corresponding data.
* **CmDataField = {[B1x, B1y, B1z]; ...}**\
  To give the magentic field strength (in Tesla) of experimental data.
* **CmDatagInfo = {gNum1; ...}**
  To set use which Lande factor to converse unit. Only required
  when the Lande factors are not given along *Sx, Sy, Sz* direction. 
* **ChiDataFile = {'FileName1'; ...}**\
  To set the file name of susceptibility data.\
  The file should only cantains a N-by-2 array where
  the firsl column is temperature with Kelvin and
  the second column is corresponding susceptibility with
  cm^3 mol^-1 under SI unit.
* **ChiDataTRange = {[T1, T2]; ...}**\
  To set the fitting temperature range of corresponding data.
* **ChiDataField = {[B1x, B1y, B1z]; ...}**\
  To give the magentic field strength (Tesla) of experimental data.
* **ChiDatagInfo = {gNum1; ...}**
  To set use which Lande factor to converse unit. Only required
  when the Lande factors are not given along *Sx, Sy, Sz* direction. 
### Model Information ###
The lattice geometry and parameter optimization range should be set in
**SpinModel/SpinModel_XXX.m**.
* **Lattice**\
  To set the lattice geometry information as **.Lx**, **.Ly**, **.BCX**, **.BCY** for 2D system or
  **.L = Inf** for 1D system.
* **ModelConf.Para_Range{i}**\
  To set the range of **ModelConf.Para_Name{i}** as an interval **[a, b]**
  or as a fixed value **a**, or keep it the same as another model parameter **'J'**.
* **ModelConf.gFactor_Range{i}**\
  To set the range of **ModelConf.gFactor_Name{i}** like above.
### Runtime parameters ###
For beginners, we do not recommend changing the relevant parameters.
* **RunScript/ImportMBSolverPara.m**\
  To change the parameter of many-body solver.
* **RunScript/ImportBOPara.m**\
  To change the parameter of Bayesian optimization.
### Loss Function ###
We have provided several forms of the loss function, which one needs to select in **RunScript/RunOpt.m**.
* **LossConf.WeightList**\
  To set the weights of different experimental data.
* **LossConf.Type**\
  To choose the form of loss function.
* **LossConf.Design**\
  To design loss function by constitute a composite function.
### Save Settings ###
* **Setting.PLOTFLAG**\
  To decide whether plots result in each iteration.
* **Setting.SAVEFLAG**\
  To decide whether save thermal result of each iteration calculated by many-body solver.
* **Setting.SAVENAME**\
  To set the name of save folder.
### Result ###
The Bayesian optimization will be stored in **Tmp** after the program is finished. The result contains a 
class **BayesianOptimization** called **res** which include parameters??value and corresponding loss 
function objective value of each iterations. To get the landscape predicted by Bayesian optimization one can use **PlotScript/LandscapePlot.m**.
## Maintainer ##
* Yuan Gao, Beihang university\
  *mail*: 17231064@buaa.edu.cn
* Bin-Bin Chen, Beihang university\
  *mail*:
* Wei Li, Institute of Theoretical Physics, Chinese Academy of Sciences\
  *mail*: w.li@buaa.edu.cn
## Citation
If you use QMagen in teaching and research, please cite our work:

```bib
@article{QMagenFramework2020,
  title={Learning Effective Spin Hamiltonian of Quantum Magnet},
  author={Sizhuo Yu, Yuan Gao, Bin-Bin Chen and Wei Li},
  journal={arXiv preprint arXiv:2011.12282},
  year={2020}
}
```
```bib
@article{LTRG2011,
  title = {Linearized Tensor Renormalization Group Algorithm for the Calculation of Thermodynamic Properties of Quantum Lattice Models},
  author = {Li, W. and Ran, S.-J. and Gong, S.-S. and Zhao, Y. and Xi, B. and Ye, F. and Su, G.},
  journal = {Phys. Rev. Lett.},
  volume = {106},
  issue = {12},
  pages = {127202},
  numpages = {4},
  year = {2011},
  month = {Mar},
  publisher = {American Physical Society},
  doi = {10.1103/PhysRevLett.106.127202},
  url = {https://link.aps.org/doi/10.1103/PhysRevLett.106.127202}
}
```
```bib
@article{BilayerLTRG2017,
	Author = {Dong, Y.-L. and Chen, L. and Liu, Y.-J. and Li, W.},
	Doi = {10.1103/PhysRevB.95.144428},
	Issue = {14},
	Journal = {Phys. Rev. B},
	Month = {Apr},
	Numpages = {10},
	Pages = {144428},
	Publisher = {American Physical Society},
	Title = {Bilayer linearized tensor renormalization group approach for thermal tensor networks},
	Url = {https://link.aps.org/doi/10.1103/PhysRevB.95.144428},
	Volume = {95},
	Year = {2017},
	Bdsk-Url-1 = {https://link.aps.org/doi/10.1103/PhysRevB.95.144428},
	Bdsk-Url-2 = {http://dx.doi.org/10.1103/PhysRevB.95.144428}
}
```
```bib
@article{SETTN2017,
	Author = {Chen, B.-B. and Liu, Y.-J. and Chen, Z. and Li, W.},
	Doi = {10.1103/PhysRevB.95.161104},
	Issue = {16},
	Journal = {Phys. Rev. B},
	Month = {Apr},
	Numpages = {5},
	Pages = {161104(R)},
	Publisher = {American Physical Society},
	Title = {Series-expansion thermal tensor network approach for quantum lattice models},
	Url = {https://link.aps.org/doi/10.1103/PhysRevB.95.161104},
	Volume = {95},
	Year = {2017},
	Bdsk-Url-1 = {https://link.aps.org/doi/10.1103/PhysRevB.95.161104},
	Bdsk-Url-2 = {http://dx.doi.org/10.1103/PhysRevB.95.161104}
}
```
```bib
@Article{XTRG2018,
  title = {Exponential Thermal Tensor Network Approach for Quantum Lattice Models},
  author = {Chen, B.-B. and Chen, L. and Chen, Z. and Li, W. and Weichselbaum, A.},
  journal = {Phys. Rev. X},
  volume = {8},
  issue = {3},
  pages = {031082},
  numpages = {29},
  year = {2018},
  publisher = {American Physical Society},
  doi = {10.1103/PhysRevX.8.031082},
  url = {https://link.aps.org/doi/10.1103/PhysRevX.8.031082}
}
```