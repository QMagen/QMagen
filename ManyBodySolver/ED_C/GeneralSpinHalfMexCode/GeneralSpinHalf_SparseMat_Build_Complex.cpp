/*
* GeneralSpinHalf_SparseMat_Build_Complex.cpp - Build (sparse) matrix for general spin-half models (with complex inputs)
* 
* Usage : from MATLAB
*         >> [rows,cols,vals] = GeneralSpinHalf_SparseMat_Count(L, nt2, nt1, 
 *                                                              twosite_index, twosite_coeff, onesite_index, onesite_coeff,
 *                                                              rows, cols, vals)
*
* Inputs: 
 *  [0] system size L;
 *  [1] No. of 2-site terms:        nt2
 *  [2] No. of 1-site terms:        nt1
 *  [3] 2-site term site indeces:   [i,j]
 *  [4] 2-site term coefficients:   [J+-,Jzz,J++,J--,J+z,J-z]
 *  [5] 1-site term site indeces:   [i]
 *  [6] 1-site term coefficients:   [hz,hz2,h+,h+2,h-,h-2]
 *
* Outputs:  (Sparse Matrix)
 *  [7] rows
 *  [8] cols
 *  [9] vals
*
* CC@lzu, 20210713
* CC@lzu, 20210715: myint -> int, save some memory 
*/
#define myint unsigned int

#include <complex.h>
#include <complex>

#include "mex.hpp"
#include "mexAdapter.hpp"

using namespace matlab::data;
using matlab::mex::ArgumentList;

class MexFunction : public matlab::mex::Function 
{
public:
    void operator()(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) 
    {
        matlab::data::ArrayFactory factory;
        
        checkArguments(outputs, inputs);
        
        //std::cout << std::endl << "Build (sparse) matrix for general spin-half models (with complex inputs)..." << std::endl;
        //
        int L = inputs[0][0];
        //std::cout << "L = " << L << std::endl;
        int nt2 = inputs[1][0];
        //std::cout << "nt2 = " << nt2 << std::endl;
        int nt1 = inputs[2][0];
        //std::cout << "nt1 = " << nt1 << std::endl;
        
        // Note: Using T* instead of matlab::data::TypedArray<T> to make code much faster!!!
        // Note: MATLAB uses column major data! Becareful!
        // inputs ==========================================================================
        // twosite_index
        matlab::data::TypedArray<myint> in3 = std::move(inputs[3]);
        buffer_ptr_t<myint> bf3 = in3.release();
        myint* twosite_index = bf3.get();
        // twosite_coeff
        matlab::data::TypedArray<std::complex<double>> in4 = std::move(inputs[4]);
        buffer_ptr_t<std::complex<double>> bf4 = in4.release();
        std::complex<double>* twosite_coeff = bf4.get();
        // onesite_index
        matlab::data::TypedArray<myint> in5 = std::move(inputs[5]);
        buffer_ptr_t<myint> bf5 = in5.release();
        myint* onesite_index = bf5.get();
        // onesite_coeff
        matlab::data::TypedArray<std::complex<double>> in6 = std::move(inputs[6]);
        buffer_ptr_t<std::complex<double>> bf6 = in6.release();
        std::complex<double>* onesite_coeff = bf6.get();
        
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
        
        // outputs ==========================================================================
        // rows
        matlab::data::TypedArray<myint> in7 = std::move(inputs[7]);
        ArrayDimensions dims = in7.getDimensions();
        buffer_ptr_t<myint> bf7 = in7.release();
        myint* rows = bf7.get();
        // cols
        matlab::data::TypedArray<myint> in8 = std::move(inputs[8]);
        buffer_ptr_t<myint> bf8 = in8.release();
        myint* cols = bf8.get();
        // vals
        matlab::data::TypedArray<std::complex<double>> in9 = std::move(inputs[9]);
        buffer_ptr_t<std::complex<double>> bf9 = in9.release();
        std::complex<double>* vals = bf9.get();
        
        GeneralSpinHalf_SparseMat_Build_Compact(L,nt2, nt1, 
                twosite_index,twosite_coeff,onesite_index,onesite_coeff,
                rows,cols,vals,
                Jpz, Jmz, hp, hm);
        //
        
        delete []Jpz;
        delete []Jmz;
        delete []hp;
        delete []hm;
        //
        myint nnz = getNumElements(dims);
        outputs[0] = factory.createArray<myint>(dims, rows, rows+nnz);
        outputs[1] = factory.createArray<myint>(dims, cols, cols+nnz);
        outputs[2] = factory.createArray<std::complex<double>>(dims, vals, vals+nnz);
    }
    
    void GeneralSpinHalf_SparseMat_Build_Compact(int L, int nt2, int nt1,
            myint* twosite_index,
            std::complex<double>* twosite_coeff,
            myint* onesite_index,
            std::complex<double>* onesite_coeff,
            myint* rows, 
            myint* cols, 
            std::complex<double>* vals,
            std::complex<double> *Jpz,
            std::complex<double> *Jmz,
            std::complex<double> *hp,
            std::complex<double> *hm)
    {
        double thrshd = 1e-8;    // abs() smaller than threshold is 0  
        double sz[2];
        sz[0] = -0.5;
        sz[1] = 0.5;
        
        myint Dim = 1<<L;
        myint counts = 0;
        for (myint k = 0; k < Dim; k++)
        {
            // diagonal terms
            std::complex<double> aux_diag = 0;
            // 2-site, SzSz
            for (myint idx = 0; idx < nt2; ++idx)
            {
                int i = twosite_index[idx];
                int j = twosite_index[idx + nt2];
                myint k_i = ((k >> i) & 1);
                myint k_j = ((k >> j) & 1);
                aux_diag += (k_i ^ k_j) ? -0.25 * twosite_coeff[idx + nt2] : 0.25 * twosite_coeff[idx + nt2];
            }
            // 1-site, Sz
            for (myint idx = 0; idx < nt1; ++idx)
            {
                int i = onesite_index[idx];
                myint k_i = ((k >> i) & 1);
                aux_diag += onesite_coeff[idx] * sz[k_i];
            }
            rows[counts] = k;
            cols[counts] = k;
            vals[counts] = aux_diag;
            counts++;
            
            // Offdiagonal 2-site terms: J+-, J++, J--
            for (myint idx = 0; idx < nt2; ++idx)
            {
                int i = twosite_index[idx];
                int j = twosite_index[idx + nt2];
                //
                int ki = (k >> i)&1;
                int kj = (k >> j)&1;
                // S+S- + h.c.
                if (std::abs(twosite_coeff[idx]) > thrshd)
                {
                    // S+S-
                    if ((!ki) && kj) 
                    {
                        myint l = k ^ (1 << i) ^ (1 << j);
                        rows[counts] = k;
                        cols[counts] = l;
                        vals[counts] = twosite_coeff[idx];
                        counts++;
                    }
                    // S-S+
                    if (ki && (!kj)) 
                    {
                        myint l = k ^ (1 << i) ^ (1 << j);
                        rows[counts] = k;
                        cols[counts] = l;
                        vals[counts] = std::conj(twosite_coeff[idx]);
                        counts++;
                    }
                }
                // S+S+
                if (std::abs(twosite_coeff[idx + nt2*2])>thrshd && (!ki) && (!kj))
                {
                    myint l = k ^ (1 << i) ^ (1 << j);
                    rows[counts] = k;
                    cols[counts] = l;
                    vals[counts] = twosite_coeff[idx + nt2*2];
                    counts++;
                }
                // S-S-
                if (std::abs(twosite_coeff[idx + nt2*3])>thrshd && ki && kj) 
                {
                    myint l = k ^ (1 << i) ^ (1 << j);
                    rows[counts] = k;
                    cols[counts] = l;
                    vals[counts] = twosite_coeff[idx + nt2*3];
                    counts++;
                } 
            }
            // compact form for: J+z, h+, J-z, h-
            for (int i = 0; i < L; i++)
            {
                int ki = (k >> i)&1;
                
                // J+z, h+
                std::complex<double> tmp = 0;
                int noz = 0;
                if (!ki)
                {
                    // hp[i] * Sp[i]
                    if (std::abs(hp[i]) > thrshd)
                    {
                        tmp += hp[i];
                        noz++;
                    }
                    // Jpz[i,j] * Sz[j]
                    for (int j = 0; j < L; j++)
                    {
                        if (std::abs(Jpz[i*L + j]) > thrshd)
                        {
                            tmp += Jpz[i*L + j] * sz[(k >> j)&1];
                            noz++;
                        }
                    }
                    if (0 != noz)
                    {
                        myint l = k ^ (1 << i);
                        rows[counts] = k;
                        cols[counts] = l;
                        vals[counts] = tmp;
                        counts++;
                    }
                }
                // J-z, h-
                tmp = 0;
                noz = 0;
                if (ki)
                {
                    // hm[i] * Sm[i]
                    if (std::abs(hm[i]) > thrshd)
                    {
                        tmp += hm[i];
                        noz++;
                    }
                    // Jmz[i,j] * Sz[j]
                    for (int j = 0; j < L; j++)
                    {
                        if (std::abs(Jmz[i*L + j]) > thrshd)
                        {
                            tmp += Jmz[i*L + j] * sz[(k >> j)&1];
                            noz++;
                        }
                    }
                    if (0 != noz)
                    {
                        myint l = k ^ (1 << i);
                        rows[counts] = k;
                        cols[counts] = l;
                        vals[counts] = tmp;
                        counts++;
                    }
                }
            }
        }
        //std::cout << "After build the matrix: nnz = " << counts << std::endl;
    }

    void checkArguments(matlab::mex::ArgumentList outputs, matlab::mex::ArgumentList inputs) {
        // to be modified later
    }
};