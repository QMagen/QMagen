%% SVD_LAPACK
% SVD_LAPACK computes the singular value decomposition of a matrix
% by calling LAPACK subroutines: ZGESVD or ZGESDD.

%% Syntax
%      [U, S, V] = svd_lapack (A)
%      [U, S, V] = svd_lapack (A, ECON)
%      [U, S, V] = svd_lapack (A, ECON, OPT)
%      S = svd_lapack (A, ...)
%      [U, S, V, err] = svd_lapack (A, ...)

%% Description
% Compute the singular value decomposition of a matrix 
%   A = U*S*V'
% where A is complex or real (not necessarily square), 
% U and V are unitary or orthogonal, and
% S is always non-negative real diagonal.
% 
% The singular values reveal the rank of the matrix. Moreover,
% the singular value decomposition may be used to compute a 
% pseudo inverse. 
%
% ECON argument makes S square and unitary matrices compact, 
% where the unnecessary rows or columns of S, U and V are eliminated.
%
% OPT argument selects the lapack routine ZGESVD or ZGESDD by
% assigning 'gesvd' or 'gesdd', where ZGESVD is based on QR iteration,
% and ZGESDD is a divide-and-conquer approach.
%
% When called with one return value, it returns 
% the sinular values S as a column vector.
% 
% When called with 4 return values, it returns the residual error:
%          err = norm(A-U*S*V')/norm(A).
%

%%
% The lapack interface routines come from the work of Tim Toolan.
% See <http://www.mathworks.co.kr/matlabcentral/fileexchange/16777-lapack>


%% Examples

%%
% Generate a matrix with sigular values of [1 3 5 7]:
A = randn(7,4)+i*randn(7,4);
[U,S,V] = svd(A,0);
A = U*diag([1 3 5 7])*V';

%%
% Change format:
format short g

%%
% Compute singular values by selecting 'gesvd' implicitly:
svd_lapack(A)

%%
% Compute the economical form of SVD:
[U,S,V] = svd_lapack(A,0)


%%
% Select the lapack subroutine ZGESVD:
[U,S,V,err] = svd_lapack(A,0,'gesvd')

%%
% Select the lapack subroutine ZGESDD:
[U,S,V,err] = svd_lapack(A,0,'gesdd')

%% Diagnostics
% Lapack, a fortran computational library, has two different subroutines
% for the Singular Value Decompostion (SVD): xGESVD and xGESDD.
% xGESVD is based on an implicit QR iteration and xGESDD uses a 
% divide-and-conquer approach.
% See <http://www.netlib.org/lapack/lug/node32.html> and 
% <http://www.netlib.org/lapack/lug/node53.html> for Lapack subroutines.

%% 
% The source of ZGESVD can be found at
% <http://www.netlib.org/lapack/explore-html/d6/d42/zgesvd_8f.html>.
% ZGESVD calls other lapack subroutines:
%
% * ZBDSQR computes the singular values and, optionally, the right and/or
% left singular vectors from the singular value decomposition (SVD) of
% a real N-by-N (upper or lower) bidiagonal matrix B using the implicit
% zero-shift QR algorithm. See <http://www.netlib.org/lapack/lawnspdf/lawn03.pdf>. 
% * DLARTG generates a plane rotation with real cosine and real sine.
% * ZDROT applies a plane rotation, where the cos and sin (c and s) are real
% and the vectors cx and cy are complex.
% * ZLASR applies a sequence of plane rotations to a general rectangular matrix.
% simplified version needed to compare with.

%%
% The source of ZGESDD can be found at
% <http://www.netlib.org/lapack/explore-html/d8/d54/zgesdd_8f_source.html>.
% ZGESDD calls a subroutine:
%
% * DBDSDC computes the singular value decomposition (SVD) of a real
% N-by-N (upper or lower) bidiagonal matrix B = U * S * VT,
% using a divide and conquer method, where S is a diagonal matrix
% with non-negative diagonal elements (the singular values of B), and
% U and VT are orthogonal matrices of left and right singular vectors,
% respectively.

%%
% Matlab's built-in function svd seems to use the lapack subroutine xGESVD.
% Meanwhile, Octave's built-in function svd support both algorithms
% by using svd_driver().

%%
% If people want to use xGESDD routines in Matlab,
% it is required to write a MEX-file to call the routine.
% See <http://www.mathworks.co.kr/matlabcentral/newsreader/view_thread/250196>
% But, it is not easy to call the lapack properly, because it needs a good
% knowledge of fortran work space.

%%
% *SVD_LAPACK* function provides both routines and the lapack interfaces.
% It could be an example for calling SVD rountine from Lapack interface.
% Although it supports double precision routines, they can be replaced
% by single precision routines without any problem.

%% xGESVD vs. xGESDD
%
% Speaking of performance, xGESDD is faster than xGESVD.
% If only the singular values are needed to calculate,
% both show similar speed. See the following examples:

%%
% Generate a big matrix:
A=randn(1000,1000)+i*randn(1000,1000);

%%
% Measure times when only sinular values are calculated:
tic, S=svd(A,0); toc
tic, S=svd_lapack(A,0,'gesvd'); toc
tic, S=svd_lapack(A,0,'gesdd'); toc

%%
% Measure times when the complete SVD is calculated:
tic, [U,S,V]=svd(A,0); toc
tic, [U,S,V]=svd_lapack(A,0,'gesvd'); toc
tic, [U,S,V]=svd_lapack(A,0,'gesdd'); toc

%%
% In Octave, we can use svd_driver() to select subroutines:
%
%   svd_driver('gesvd'), tic, [U,S,V]=svd(A,0); toc
%   svd_driver('gesdd'), tic, [U,S,V]=svd(A,0); toc


%% Convergence test
%
% SVD has implemented in many numerical libraries such as LINPACK, EISPACK,
% and Lapack. See <http://www.alglib.net/matrixops/general/svd.php>.
% Among them, Lapack's SVD focuses the smallest singular value.
% The following example is to see the small singular values as in
% <http://www.netlib.org/lapack/lawnspdf/lawn03.pdf>:

%%
% Generate a matrix A:
eta = eps(1)/2;
x = eta; % the smallest sigma ~ eta^3 
%x = 0; % the smallest sigma ~ eta^2/sqrt(2) % good test for deflation
A = [eta^2 1 0 0; 0 1 x 0; 0 0 1 1; 0 0 0 eta^2];

%%
% Change format:
format long g

%%
% Calculate SVD using ZGESVD:
[U,S,V,err] = svd_lapack(A,[],'gesvd')

%%
% Calculate SVD using ZGESDD:
[U,S,V,err] = svd_lapack(A,[],'gesdd')


%% Pseudo inverse
% SVD can be used to find a Pseudo inverse.
% For example,

%%
% Change format:
format short g

%%
% Generate A with sigular values of [1 3 5 7]:
A = randn(7,4)+i*randn(7,4);
[U,S,V] = svd(A,0);
A = U*diag([1 3 5 7])*V'

%%
% Calculate SVD:
[U,S,V,err] = svd_lapack(A,0,'gesdd')

%%
% Find the inverse of singular values:
S_diag = diag(S);
idx_non_zero_S_diag = (S_diag ~= 0);
S_diag_inv = S_diag;
S_diag_inv(idx_non_zero_S_diag) = S_diag_inv(idx_non_zero_S_diag).^(-1);
S_inv = [diag(S_diag_inv); zeros(size(S,2)-size(S,1),size(S,1))]

%%
% Find the Pseudo inverse:
A_inv = V*S_inv*U'

%%
% Measure inversion error:
err_inv = norm(A_inv * A  - eye(size(A,2)))


