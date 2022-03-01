/*
* GeneralSpinHalf_SparseMat_Count.cpp - Count No. of nonzero elements of the (sparse) matrix for general spin-half models
* 
* Usage : from MATLAB
*         >> nnz = GeneralSpinHalf_SparseMat_Count(L, nt2, nt1, twosite_index, twosite_coeff, onesite_index, onesite_coeff);
*
* Inputs: 
 *  [0] system size L;
 *  [1] No. of 2-site terms:        nt2
 *  [2] No. of 1-site terms:        nt1
 *  [3] 2-site term site indeces:   [i,j]
 *  [4] 2-site term coefficients:   [J+-,Jzz,J++,J--,J+z,J-z]
 *  [5] 1-site term site indeces:   [i]
 *  [6] 1-site term coefficients:   [hz,h+,h-]
 *
* CC@lzu, 20210713
*/

#define myint unsigned int

#include <complex.h>
//#include <complex>

#include "mex.hpp"
#include "mexAdapter.hpp"

using namespace matlab::data;
using matlab::mex::ArgumentList;

class MexFunction : public matlab::mex::Function 
{
public:
    void operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) 
    {
        checkArguments(outputs, inputs);
        
        //std::cout << std::endl << "Count No. of nonzero elements of the (sparse) matrix for general spin-half models..." << std::endl;
        //
        int L = inputs[0][0];
        //std::cout << "L = " << L << std::endl;
        int nt2 = inputs[1][0];
        //std::cout << "nt2 = " << nt2 << std::endl;
        int nt1 = inputs[2][0];
        //std::cout << "nt1 = " << nt1 << std::endl;
        //
        // Note: Using T* instead of matlab::data::TypedArray<T> to make code much faster!!!
        // Note: MATLAB uses column major data! Becareful!
        // inputs ==========================================================================
        // twosite_index
        matlab::data::TypedArray<myint> in3 = std::move(inputs[3]);
        ArrayDimensions dims = in3.getDimensions();
        buffer_ptr_t<myint> bf3 = in3.release();
        myint* twosite_index = bf3.get();
        //std::cout << "get twosite_index" << std::endl;
        // twosite_coeff
        matlab::data::TypedArray<std::complex<double>> in4 = std::move(inputs[4]);
        buffer_ptr_t<std::complex<double>> bf4 = in4.release();
        std::complex<double>* twosite_coeff = bf4.get();
        //std::cout << "get twosite_coeff" << std::endl;
        // onesite_index
        matlab::data::TypedArray<myint> in5 = std::move(inputs[5]);
        buffer_ptr_t<myint> bf5 = in5.release();
        myint* onesite_index = bf5.get();
        //std::cout << "get onesite_index" << std::endl;
        // onesite_coeff
        matlab::data::TypedArray<std::complex<double>> in6 = std::move(inputs[6]);
        buffer_ptr_t<std::complex<double>> bf6 = in6.release();
        std::complex<double>* onesite_coeff = bf6.get();
        //std::cout << "get onesite_coeff" << std::endl;
        
        // new version: recollect repeated nonzero elements
        // J+z, J-z, h+, h- can contribute terms with same indeces
        std::complex<double> *Jpz = new std::complex<double> [L*L];
        std::complex<double> *Jmz = new std::complex<double> [L*L];
        for (myint i = 0; i < L*L; i++) 
        {
            Jpz[i] = 0;
            Jmz[i] = 0;
        }
        for (myint idx = 0; idx < nt2; ++idx)
        {
            int i = twosite_index[idx];
            int j = twosite_index[idx + nt2];
            Jpz[i*L + j] = twosite_coeff[idx + nt2*4];
            Jpz[i + j*L] = twosite_coeff[idx + nt2*4];
            Jmz[i*L + j] = twosite_coeff[idx + nt2*5];
            Jmz[i + j*L] = twosite_coeff[idx + nt2*5];
        }
        std::complex<double> *hp = new std::complex<double> [L];
        std::complex<double> *hm = new std::complex<double> [L];
        for (myint i = 0; i < L; i++)
        {
            hp[i] = 0;
            hm[i] = 0;
        }
        for (myint idx = 0; idx < nt1; ++idx)
        {
            int i = onesite_index[idx];
            hp[i] = onesite_coeff[idx + nt1];
            hm[i] = onesite_coeff[idx + nt1*2];
        }
        //
        
        myint nnz = XXZ_SparseMat_Counts_Compact(L,nt2, nt1,
                twosite_index,twosite_coeff,onesite_index,onesite_coeff,
                Jpz,Jmz,hp,hm);
        
        //std::cout << "nnz = " << nnz << std::endl;
        delete []Jpz;
        delete []Jmz;
        delete []hp;
        delete []hm;
        //
        matlab::data::ArrayFactory factoryObject;
        matlab::data::TypedArray<myint> allocatedDataArray = factoryObject.createScalar<myint>(nnz);
        outputs[0] = allocatedDataArray;
    }
    
    myint XXZ_SparseMat_Counts_Compact(int L, int nt2, int nt1,
            myint* twosite_index,
            std::complex<double>* twosite_coeff,
            myint* onesite_index,
            std::complex<double>* onesite_coeff,
            std::complex<double> *Jpz,
            std::complex<double> *Jmz,
            std::complex<double> *hp,
            std::complex<double> *hm)
    {
        double thrshd = 1e-8;    // abs() smaller than threshold is 0  
        
        myint Dim = 1<<L;
        myint counts = 0;
        for (myint k = 0; k < Dim; k++)
        {
            // consider each diagonal term as nonzero 
            // Jzz, hz
            counts++;
            // Offdiagonal 2-site terms: J+-, J++, J--
            for (myint idx = 0; idx < nt2; ++idx)
            {
                int i = twosite_index[idx];
                int j = twosite_index[idx + nt2];
                //
                int ki = (k >> i)&1;
                int kj = (k >> j)&1;
                // S+S-, S-S+
                if (std::abs(twosite_coeff[idx])>thrshd && ki^kj) 
                {
                    counts++;
                }
                // S+S+
                if (std::abs(twosite_coeff[idx + nt2*2])>thrshd && (!ki) && (!kj))
                {
                    counts++;
                }
                // S-S-
                if (std::abs(twosite_coeff[idx + nt2*3])>thrshd && ki && kj) 
                {
                    counts++;
                } 
            }
            // compact form for: J+z, h+, J-z, h-
            for (int i = 0; i < L; i++)
            {
                int ki = (k >> i)&1;
                // J+z, h+
                int noz = 0;
                if (!ki)
                {
                    if (std::abs(hp[i]) > thrshd)
                    {
                        noz++;
                    }
                    for (int j = 0; j < L; j++)
                    {
                        if (std::abs(Jpz[i*L + j]) > thrshd)
                        {
                            noz++;
                        }
                    }
                    if (0 != noz)
                    {
                        counts++;
                    }
                }
                // J-z, h-
                noz = 0;
                if (ki)
                {
                    if (std::abs(hm[i]) > thrshd)
                    {
                        noz++;
                    }
                    for (int j = 0; j < L; j++)
                    {
                        if (std::abs(Jmz[i*L + j]) > thrshd)
                        {
                            noz++;
                        }
                    }
                    if (0 != noz)
                    {
                        counts++;
                    }
                }
            }
        }
        return counts;
    }

    void checkArguments(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) {
        // to be modified later
    }
};