function [varargout] = svd_lapack (varargin)
% SVD_LAPACK computes the singular value decomposition of a matrix
% by calling LAPACK subroutines: ZGESVD or ZGESDD.
%
% [U, S, V] = svd_lapack (A)
% [U, S, V] = svd_lapack (A, ECON)
% [U, S, V] = svd_lapack (A, ECON, OPT)
% S = svd_lapack (A, ...)
% [U, S, V, err] = svd_lapack (A, ...)
%
% Compute the singular value decomposition of a matrix A:
%          A = U*S*V'
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
% See also: svd.
% See LAPACK subroutines ZGESVD or ZGESDD.

% Author: Sung Eun Jo (sungeun.jo+matlab@gmail.com)
% Suwon, Korea. 2014.

% lapack interface routines come from the work of Tim Toolan.
% See http://www.mathworks.co.kr/matlabcentral/fileexchange/16777-lapack

if nargin<1,
	varargout = {};
	help svd_lapack;
	return;
end
if nargin>0,
	A = varargin{1};
end
if nargin>1 && ~isempty(varargin{2}),
	flag_econ = 1;
else
	flag_econ = 0;
end
if nargin>2,
	opt = varargin{3};
else
	opt = [];
end
if isempty(opt)
	flag_gesvd = 1;
	flag_gesdd = 0;
elseif isequal(opt,'gesvd')
	flag_gesvd = 1;
	flag_gesdd = 0;
elseif isequal(opt,'gesdd')
	flag_gesvd = 0;
	flag_gesdd = 1;
else
	flag_gesvd = 0;
	flag_gesdd = 0;
	display(' OPT is not known!');
	return
end

if nargout<2,
	flag_sing_only = 1;
else
	flag_sing_only = 0;
end

% setup flags:
% flag_econ
% flag_gesvd
% flag_gesdd
% flag_sing_only

% find size
[m,n] = size(A);
% check m and n
if m<n, 
	flag_transpose = 1;
	A = A';
	[m,n]=size(A);
	% A' = V*S'*U' or AT = UAT * SAT * VAT'
	% S = SAT', U = VAT, V = UAT.
else
	flag_transpose = 0;
	% A = U*S*V'
end

if flag_sing_only == 0 && flag_econ == 0
	JOBZ='A';
elseif flag_sing_only == 0 && flag_econ == 1
	JOBZ='S';
else
	JOBZ='N';
end

if flag_gesdd == 1,
	% lapack call - ZGESDD 
	[S,U,VT,INFO] = lapack_ZGESDD(JOBZ,A);
else
	% lapack call - ZGESVD 
	[S,U,VT,INFO] = lapack_ZGESVD(JOBZ,JOBZ,A);
end 

% reshape S
if flag_sing_only == 0 && flag_econ == 0
	% Assume m >= n
	S = [diag(S); zeros([(m-n), n])]; 
elseif flag_sing_only == 0 && flag_econ == 1
	S = diag(S);
else
	% S is a vector
end

% assign output
if nargout==3,
	if flag_transpose==0,
		varargout(1) = {U};
		varargout(2) = {S};
		varargout(3) = {VT'};
	else
		varargout(1) = {VT'};
		varargout(2) = {S'}; 
		varargout(3) = {U};
	end
elseif nargout==4,
	if flag_transpose==0,
		varargout(1) = {U};
		varargout(2) = {S};
		varargout(3) = {VT'};
		varargout(4) = {norm(A-U*S*VT)/norm(A)};
	else
		varargout(1) = {VT'};
		varargout(2) = {S'};
		varargout(3) = {U};
		varargout(4) = {norm(A'-VT'*S'*U')/norm(A)};
	end
else
	if flag_transpose==0,
		varargout(1) = {S};
	else
		varargout(1) = {S'};
	end
end

return

%%
function [S,U,VT,INFO] = lapack_ZGESDD(JOBZ,A)
% lapack call 
[m,n] = size(A);
mn_min = min(m,n);
%
LDU = m;
if JOBZ=='A'
	UCOL = m;
	LDVT = n;
elseif JOBZ=='S'
	UCOL = mn_min;
	LDVT = mn_min;
elseif JOBZ=='N'
	UCOL = m;
	LDVT = n;
end
%
C = lapack('zgesdd', ...
	JOBZ, ... % JOBZ options : 'A' all col; 'S' minimal col; 'N' no col.
	m, n, A, m, ... % M N A LDA
	zeros(mn_min,1), ... % S singular values
	zeros(LDU,UCOL), LDU, ... % U LDU
	zeros(LDVT,n), LDVT, ... % VT LDVT
	0, ... % WORK
	-1, ... % LWORK
	0, ... % RWORK
	0, ... % IWORK
	0); ... % INFO
WORK = C{11}; % find optimal size
LWORK = WORK(1);
if JOBZ=='N'
	LRWORK = 5*mn_min;
else
	LRWORK = mn_min*max(5*mn_min+7,2*max(m,n)+2*mn_min+1);
end
C = lapack('zgesdd', ...
	JOBZ, ... % JOBZ options : 'A' all col; 'S' minimal col; 'N' no col.
	m, n, A, m, ... % M N A LDA
	zeros(mn_min,1), ... % S singular values
	zeros(LDU,UCOL), LDU, ... % U LDU
	zeros(LDVT,n), LDVT, ... % VT LDVT
	zeros(LWORK,1), ... % WORK
	LWORK, ... % LWORK
	zeros(LRWORK,1), ... % RWORK
	zeros(8*mn_min,1), ... % IWORK
	0); ... % INFO
%
[S,U,VT,INFO] = C{[6,7,9,15]};
return

%%
function [S,U,VT,INFO] = lapack_ZGESVD(JOBU,JOBVT,A)
% lapack call 
[m,n] = size(A);
mn_min = min(m,n);
%
LDU = m;
if JOBU=='A'
	UCOL = m;
elseif JOBU=='S'
	UCOL = mn_min;
elseif JOBU=='N'
	UCOL = 0;
end
%
if JOBVT=='A'
	LDVT = n;
elseif JOBVT=='S'
	LDVT = mn_min;
elseif JOBVT=='N'
	LDVT = n;
end
%
C = lapack('zgesvd', ...
	JOBU, ... % JOBU options : 'A' all col; 'S' minimal col; 'N' no col.
	JOBVT, ... % JOBVT options : 'A' all rows; 'S' minimal rows; 'N' no row.
	m, n, A, m, ... % M N A LDA
	zeros(mn_min,1), ... % S singular values
	zeros(LDU,UCOL), LDU, ... % U LDU
	zeros(LDVT,n), LDVT, ... % VT LDVT
	0, ... % WORK
	-1, ... % LWORK
	0, ... % RWORK
	0); ... % INFO
WORK = C{12}; % find optimal size
LWORK = WORK(1);
LRWORK = 5*mn_min;
%
C = lapack('zgesvd', ...
	JOBU, ... % JOBU options : 'A' all col; 'S' minimal col; 'N' no col.
	JOBVT, ... % JOBVT options : 'A' all rows; 'S' minimal rows; 'N' no row.
	m, n, A, m, ... % M N A LDA
	zeros(mn_min,1), ... % S singular values
	zeros(LDU,UCOL), LDU, ... % U LDU
	zeros(LDVT,n), LDVT, ... % VT LDVT
	zeros(LWORK,1), ... % WORK
	LWORK, ... % LWORK
	zeros(LRWORK,1), ... % RWORK
	0); ... % INFO
%
[S,U,VT,INFO] = C{[7,8,10,15]};
return

