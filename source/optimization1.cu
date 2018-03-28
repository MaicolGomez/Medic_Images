#include<bits/stdc++.h>
using namespace std;
#define pi (2.0*acos(0.0))
#define eps 1e-6
#define ll long long
#define inf (1<<29)
#define vi vector<int>
#define vll vector<ll>
#define sc(x) scanf("%d",&x)
#define scl(x) scanf("%lld",&x)
#define all(v) v.begin() , v.end()
#define me(a,val) memset( a , val ,sizeof(a) )
#define pb(x) push_back(x)
#define pii pair<int,int> 
#define mp(a,b) make_pair(a,b)
#define Q(x) (x) * (x)
#define L(x) ((x<<1) + 1)
#define R(x) ((x<<1) + 2)
#define M(x,y) ((x+y)>>1)
#define fi first
#define se second
#define MOD 1000000007
#define ios ios::sync_with_stdio(0)
#define TRADITIONAL 1
#define N 1024

clock_t tStart;

typedef struct MatrixStruct {
	double **data;
	int height, width;
} Matrix;

typedef struct CudaMatrixStruct {
	double *data;
	int height, width;
} CudaMatrix;


void nrerror(string s){
	printf("Numerical Recipes run-time error...\n");
	printf("%s\n",s.c_str());
	printf("...now exiting to system...\n");
	exit(1);
}

double *dvector(int nl, int nh){
	double *v;
	v = (double *) calloc((unsigned) (nh-nl+1), sizeof(double));
	if (!v) nrerror("allocation failure in dvector()");
	return v-nl;
}

float *vector(int nl, int nh){
	float *v;
	v = (float *) calloc((unsigned) (nh-nl+1), sizeof(float));
	if (!v) nrerror("allocation failure in dvector()");
	return v-nl;
}

void free_dvector(double *v, int nl, int nh){
	free((char*) (v+nl));
}

void free_vector(float *v, int nl, int nh){
	free((char*) (v+nl));
}

float **matrix(int nrl,int nrh,int ncl,int nch){
	float **m;
	m = (float **) malloc((unsigned) (nrh-nrl+1)*sizeof(float*));
	if (!m) nrerror("allocation failure 1 in matrix()");
	m -= nrl;
	for(int i = nrl ; i <= nrh ; i++){
		m[i]=(float *) malloc((unsigned) (nch-ncl+1)*sizeof(float));
		if (!m[i]) nrerror("allocation failure 2 in matrix()");
		m[i] -= ncl;
	}
	return m;
}

void free_matrix(float **m,int nrl,int nrh,int ncl,int nch){
	for(int i = nrh ; i >= nrl ; i--) free((char*) (m[i]+ncl));
	free((char*) (m+nrl));
}

double **dmatrix(int nrl, int nrh, int ncl, int nch){
	double **m;
	m = (double **) calloc((unsigned) (nrh-nrl+1), sizeof(double*));
	if (!m) nrerror("allocation failure 1 in dmatrix()");
	m -= nrl;
	for(int i = nrl ; i <= nrh ; i++){
		m[i] = (double *) calloc((unsigned) (nch-ncl+1), sizeof(double));
		if (!m[i]) nrerror("allocation failure 2 in dmatrix()");
		m[i] -= ncl;
	}
	return m;
}

void free_dmatrix(double **m, int nrl, int nrh, int ncl, int nch){
	for(int i = nrh ; i >= nrl ; i--) free((char*) (m[i]+ncl));
	free((char*) (m+nrl));
}

/*
double log2(double x){
	return log10(x) / log10( 2.0 );
}
*/

void CreateMatrix(Matrix **M, int hei, int wid){
	Matrix *tmp;

	tmp = (Matrix *) calloc(1, sizeof(Matrix)); 
	tmp->data = (double **) calloc(hei, sizeof(double *));
	
	if (!(tmp->data)) {
		nrerror("allocation failure in CreateMatrix()");
		exit(1);
	}

	for (int h = 0 ; h < hei ; h++) {
		tmp->data[h] = (double *) calloc(wid, sizeof(double));
		if (!(tmp->data[h])) {
			nrerror("allocation failure in CreateMatrix()");
			exit(1);
		}
	}

	tmp->height = hei;
	tmp->width = wid;
	*M = tmp;
}

void FreeMatrix(Matrix *M){
	int hei = M->height;
	for(int h = 0 ; h < hei ; h++){
	     free(M->data[h]);
	}
	free(M->data);
	free(M);
}


void four1(double *data, int nn, int isign){
	int n, mmax, m, j, istep, i;
	double wtemp, wr, wpr, wpi, wi, theta;
	double tempr, tempi;
	n = nn << 1;
	j = 1;
	for (i=1;i<n;i+=2) {
		if (j > i) {
			swap(data[j],data[i]);
			swap(data[j+1],data[i+1]);
		}
		m = n >> 1;
		while (m >= 2 && j > m) {
			j -= m;
			m >>= 1;
		}
		j += m;
	}
	mmax = 2;
	while (n > mmax) {
		istep = 2*mmax;
		theta = 6.28318530717959/(isign*mmax);
		wtemp = sin(0.5*theta);
		wpr = -2.0*wtemp*wtemp;
		wpi = sin(theta);
		wr = 1.0;
		wi = 0.0;
		for (m=1;m<mmax;m+=2) {
			for (i=m;i<=n;i+=istep) {
				j = i+mmax;
				tempr = wr*data[j]-wi*data[j+1];
				tempi = wr*data[j+1]+wi*data[j];
				data[j] = data[i]-tempr;
				data[j+1] = data[i+1]-tempi;
				data[i] += tempr;
				data[i+1] += tempi;
			}
			wr = (wtemp=wr)*wpr-wi*wpi+wr;
			wi = wi*wpr+wtemp*wpi+wi;
		}
		mmax = istep;
	}
}

void four2(double **fftr, double **ffti, double **rdata, double **idata, int rs, int cs, int isign){
/************************************************************ 

   2-D fourier transform of data with real part stored in
   "rdata" and imaginary part in "idata" with size "rs" x
   "cs". The result is in "fftr" and "ffti". The isign is
   "isign" =  1 forward, and "isign" = -1 inverse 

*************************************************************/
        double **T, *tmp1, *tmp2;
        int i, j;

        tmp1 = dvector(1,2*cs);
        tmp2 = dvector(1,2*rs);
        T = dmatrix(1,2*rs,1,cs);

        for (i=1;i<=rs;i++) {
            for (j=1;j<=cs;j++) {
                tmp1[j*2-1] = rdata[i][j];
                tmp1[j*2] = idata[i][j];
            }
            four1(tmp1, cs, isign);
            for (j=1;j<=cs;j++) {
                T[i*2-1][j] = tmp1[j*2-1];
                T[i*2][j] = tmp1[j*2];
            }
        }

        for (i=1;i<=cs;i++) {
            for (j=1;j<=rs;j++) {
                tmp2[j*2-1] = T[j*2-1][i];
                tmp2[j*2] = T[j*2][i];
            }
            four1(tmp2,rs,isign);
            for (j=1;j<=rs;j++) {
                fftr[j][i] = tmp2[j*2-1];
                ffti[j][i] = tmp2[j*2];
            }
        }
        free_dvector(tmp1, 1, 2*cs);
        free_dvector(tmp2, 1, 2*rs);
        free_dmatrix(T, 1, 2*rs, 1, cs); 
}

void Mat_FFT2(Matrix *Output_real, Matrix *Output_imag, Matrix *Input_real, Matrix *Input_imag){
	int xs, ys, i, j;
	double **R, **I, **Fr, **Fi;

	xs = Input_real->height;
	ys = Input_real->width;

    R  = dmatrix(1,xs,1,ys);
    I  = dmatrix(1,xs,1,ys);
    Fr = dmatrix(1,xs,1,ys);
    Fi = dmatrix(1,xs,1,ys);
		
    for (i=1;i<=Input_real->height;i++) 
        for (j=1;j<=Input_real->width;j++) {
            R[i][j] = Input_real->data[i-1][j-1];
            I[i][j] = Input_imag->data[i-1][j-1];
        }

    four2(Fr, Fi, R, I, xs, ys, 1);         /* 2-D FFT */

    for (i=1;i<=Input_real->height;i++) 
        for (j=1;j<=Input_real->width;j++) {
            Output_real->data[i-1][j-1] = Fr[i][j];
            Output_imag->data[i-1][j-1] = Fi[i][j];
        }

    free_dmatrix(R,1,xs,1,ys);
    free_dmatrix(I,1,xs,1,ys);   
    free_dmatrix(Fr,1,xs,1,ys);
    free_dmatrix(Fi,1,xs,1,ys);   
}

void Mat_IFFT2(Matrix *Output_real, Matrix *Output_imag, Matrix *Input_real, Matrix *Input_imag){
	int xs, ys, i, j;
	double **R, **I, **Fr, **Fi, NN;

	xs = Input_real->height;
	ys = Input_real->width;

    R  = dmatrix(1,xs,1,ys);
    I  = dmatrix(1,xs,1,ys);
    Fr = dmatrix(1,xs,1,ys);
    Fi = dmatrix(1,xs,1,ys);

    for (i=1;i<=Input_real->height;i++) 
        for (j=1;j<=Input_real->width;j++) {
            R[i][j] = Input_real->data[i-1][j-1];
            I[i][j] = Input_imag->data[i-1][j-1];
        }

    four2(Fr, Fi, R, I, xs, ys, -1);         /* 2-D IFFT */

	NN = (double) (xs*ys);

    for (i=1;i<=Input_real->height;i++) 
        for (j=1;j<=Input_real->width;j++) {
            Output_real->data[i-1][j-1] = Fr[i][j]/NN;
            Output_imag->data[i-1][j-1] = Fi[i][j]/NN;
        }

    free_dmatrix(R,1,xs,1,ys);
    free_dmatrix(I,1,xs,1,ys);   
    free_dmatrix(Fr,1,xs,1,ys);
    free_dmatrix(Fi,1,xs,1,ys);   
}

void Mat_Copy(Matrix *A, Matrix *B, int h_target, int w_target, int h_begin, int w_begin, int h_end, int w_end){
	int i, j, h, w, h_done, w_done;
	if ((h_target >= 0)&&(h_target < A->height)&&(w_target >= 0)&&(w_target < A->width)) {
		if ((h_begin >= 0)&&(h_begin < B->height)&&(w_begin >= 0)&&(w_begin < B->width)) {
			h = h_end-h_begin+1;
			w = w_end-w_begin+1;
			if ((h >= 1)&&(w >= 1)) {
				h_done = h_target+h-1;
				w_done = w_target+w-1;
				if ((h_done < A->height)&&(w_done < A->width)) {
					for (i=0;i<h;i++) {
						for (j=0;j<w;j++) {
							A->data[i+h_target][j+w_target] = B->data[i+h_begin][j+w_begin];
						}
					}
				}
			}
		}
	}
	else {
		printf("matrix dimension error!\n");
		exit(1);
	}
}


void Mat_Product(Matrix *A, Matrix *B, Matrix *C){
	for(int h = 0 ; h < A->height ; h++)
		for(int w = 0 ; w < A->width ; w++)
			A->data[h][w] = B->data[h][w]*C->data[h][w];
}

void Mat_Sum(Matrix *A, Matrix *B, Matrix *C){
	for(int h = 0 ; h < A-> height ; h++)
		for(int w = 0 ; w < A->width ; w++)
			A->data[h][w] = B->data[h][w]+C->data[h][w];
}

void Mat_Substract(Matrix *A, Matrix *B, Matrix *C){
	for(int h = 0 ; h < A->height ; h++)
		for(int w = 0 ; w < A->width ; w++)
			A->data[h][w] = B->data[h][w]-C->data[h][w];
}

void Gabor(Matrix *Gr, Matrix *Gi, int s, int n, double Ul, double Uh, int scale, int orientation, int flag);

__device__ void CudaPrintMatrix(CudaMatrix *A){
	printf("CudaMatrix->height: %d  CudaMatrix->width: %d\n", A->height, A->width);
	printf("Elementos de CudaMatrix:\n");
	for(int i = 0; i < A->height * A->width; i++)
		if(fabs(A->data[i]) > 1e-6) printf("ERROR: %.1lf ", A->data[i]);
	printf("\n");	
}

void PrintMatrix(Matrix *A){
	printf("Matrix->height: %d  Matrix->width: %d\n", A->height, A->width);
	printf("Elementos de Matrix:\n");
	for(int i = 0; i < A->height ; i++)
		for(int j = 0 ; j < A->width ; j++)
			printf("%.1lf ", A->data[i][j] );
	printf("\n");		
}

void CudaCreateMatrix(CudaMatrix *&AA,int hei,int wid){	
	CudaMatrix *A = new CudaMatrix();
	A->width = wid;
	A->height = hei;

	cudaMalloc((void **)&AA, sizeof(CudaMatrix));
	double * data;
	cudaMalloc((void **) &data, sizeof(double) * hei * wid);

	cudaMemcpy(AA, A, sizeof(CudaMatrix), cudaMemcpyHostToDevice);
	cudaMemcpy(&(AA->data), &data, sizeof(double *), cudaMemcpyHostToDevice);
}

__global__ void PrintD(double *dev, int a){
	
	/*for(int i = 0 ; i < a ; i++)
		if(fabs(dev[i]) > 1e-6) printf("tmr: %.1lf ",dev[i]);
		
	printf("\n");*/
}

__global__ void Print(CudaMatrix *dev){
	printf("%d - %d\n",dev->height,dev->width);
	for(int i = 0 ; i < dev->height * dev->width ; i++)
		if(fabs(dev->data[i]) > 1e-6) printf("HORROR2!!: %.1lf ",dev->data[i]);
		
	printf("\n");
}

void CudaCopyMatrix(CudaMatrix *&AA,Matrix *B, int flag = 0){
	CudaMatrix *A = new CudaMatrix();
	A->width = B->width;
	A->height = B->height;

	cudaMalloc((void **)&AA, sizeof(CudaMatrix));
	double *data , *dataB;
	dataB = (double *)malloc( sizeof(double) * B->height * B->width );
	for(int i = 0 ; i < B->height ; i++)
		for(int j = 0 ; j < B->width ; j++)
			dataB[ i * B->width + j ] = B->data[i][j];
	//if(flag){	
		//for(int i = 1000; i <  2000; i++) printf("%.1lf ", dataB[i]);
		//printf("\n"); 
	//}
	
	cudaMalloc((void **) &data, sizeof(double) * B->height * B->width );
	cudaMemcpy( data , dataB , sizeof(double) * B->height * B->width , cudaMemcpyHostToDevice );
	
	//if(flag)PrintD<<<1,1>>>(data, B->height * B->width);
	
	/*double * data2;
	data2 = (double *)malloc( sizeof(double) * B->height * B->width );
	cudaMemcpy( data2 , data , sizeof(double) * B->height * B->width , cudaMemcpyDeviceToHost );
	
	for(int i = 0; i < B->height * B->width ; i++) if(fabs(data2[i] - dataB[i]) > 1e-6) printf("HORROR!! ");
	*/
	//cudaFree(data);
	
	cudaMemcpy(AA, A, sizeof(CudaMatrix), cudaMemcpyHostToDevice);
	cudaMemcpy(&(AA->data), &data, sizeof(double *), cudaMemcpyHostToDevice);
	
	//if(flag) Print<<<1,1>>>(AA);
	
	//cudaFree(AA);
}

__device__ void CudaGabor(CudaMatrix *Gr, CudaMatrix *Gi, int s, int n, double Ul, double Uh, int scale, int orientation, int flag){
	double base, a, u0, z, Uvar, Vvar, Xvar, Yvar, X, Y, G, t1, t2, m;
	int x, y, side;

	base = Uh/Ul;
	a = pow(base, 1.0/(double)(scale-1));

	u0 = Uh/pow(a, (double) scale-s);

	Uvar = (a-1.0)*u0/((a+1.0)*sqrt(2.0*log(2.0)));

	z = -2.0*log(2.0)*(Uvar*Uvar)/u0;
	Vvar = tan(pi/(2*orientation))*(u0+z)/sqrt(2.0*log(2.0)-z*z/(Uvar*Uvar));

        Xvar = 1.0/(2.0*pi*Uvar);
        Yvar = 1.0/(2.0*pi*Vvar);

	t1 = cos(pi/orientation*(n-1.0));
	t2 = sin(pi/orientation*(n-1.0));

	side = (int) (Gr->height-1)/2;

	//CUDA
	for (x=0;x<2*side+1;x++) {
		for (y=0;y<2*side+1;y++) {
			X = (double) (x-side)*t1+ (double) (y-side)*t2;
			Y = (double) -(x-side)*t2+ (double) (y-side)*t1;
			G = 1.0/(2.0*pi*Xvar*Yvar)*pow(a, (double) scale-s)*exp(-0.5*((X*X)/(Xvar*Xvar)+(Y*Y)/(Yvar*Yvar)));
			Gr->data[x * (2*side+1) + y] = G*cos(2.0*pi*u0*X);
			Gi->data[x * (2*side+1) + y] = G*sin(2.0*pi*u0*X);
		}
	}

	/* if flag = 1, then remove the DC from the filter */
	

	if (flag == 1) {
	
		//CUDA - logn
		m = 0;
		for (x=0;x<2*side+1;x++)
			for (y=0;y<2*side+1;y++)
				m += Gr->data[x * (2*side+1) + y];

		m /= pow((double) 2.0*side+1, 2.0);
		
		
		//CUDA
		for (x=0;x<2*side+1;x++)
			for (y=0;y<2*side+1;y++)
				Gr->data[x * (2*side+1) + y] -= m;
	}	
}

__device__ void CudaMat_Copy(CudaMatrix *A, CudaMatrix *B, int h_target, int w_target, int h_begin, int w_begin, int h_end, int w_end){
	int i, j, h, w, h_done, w_done;
	if ((h_target >= 0)&&(h_target < A->height)&&(w_target >= 0)&&(w_target < A->width)) {
		if ((h_begin >= 0)&&(h_begin < B->height)&&(w_begin >= 0)&&(w_begin < B->width)) {
			h = h_end-h_begin+1;
			w = w_end-w_begin+1;
			if ((h >= 1)&&(w >= 1)) {
				h_done = h_target+h-1;
				w_done = w_target+w-1;
				if ((h_done < A->height)&&(w_done < A->width)) {
					for (i=0;i<h;i++) {
						for (j=0;j<w;j++) {
						
							A->data[(i+h_target) * w + (j+w_target)] = B->data[(i+h_begin) * w + (j+w_begin)];
						}
					}
				}
			}
		}
	}
	else {
		printf("matrix dimension error!\n");
		//exit(1);
	}
}

__device__  void CudaMat_Product(CudaMatrix *A, CudaMatrix *B, CudaMatrix *C){
	for(int h = 0 ; h < A->height ; h++)
		for(int w = 0 ; w < A->width ; w++)
			A->data[h * A->width + w] = B->data[h * A->width + w] * C->data[h * A->width + w];
}

__device__  void CudaMat_Sum(CudaMatrix *A, CudaMatrix *B, CudaMatrix *C){
	for(int h = 0 ; h < A-> height ; h++)
		for(int w = 0 ; w < A->width ; w++)
			A->data[h * A->width + w] = B->data[h * A->width + w] + C->data[h * A->width + w];
}

__device__  void CudaMat_Substract(CudaMatrix *A, CudaMatrix *B, CudaMatrix *C){
	for(int h = 0 ; h < A->height ; h++)
		for(int w = 0 ; w < A->width ; w++)
			A->data[h * A->width + w] = B->data[h * A->width + w] - C->data[h * A->width + w];
}

__device__ void Cudadmatrix(double *&A, int nrl, int nrh, int ncl, int nch){
	A = (double *)malloc( sizeof(double) * (nrh + 1) * (nch + 1) );
	
	//A = new double[(nrh + 1) * (nch + 1)];
}

__device__ void Cudafree_dmatrix(double *&m, int nrl, int nrh, int ncl, int nch){
	//cudaFree(m);
	
	free(m);
}

__device__ void Cudadvector(double * &A, int nl, int nh){
	A = (double *)malloc( sizeof(double) * (nh  + 1) );
	//A = new double[nh + 1];

}

__device__ void Cudafree_dvector(double *&v, int nl, int nh){
	free(v);
}

__device__ inline void Cudaswap(double &x, double &y){
	double tmp;
	tmp = y; y = x; x = tmp;
}
__device__ void Cudafour1(double *data, int nn, int isign){
	int n, mmax, m, j, istep, i;
	double wtemp, wr, wpr, wpi, wi, theta;
	double tempr, tempi;
	
	printf("dunk 1\n");
	n = nn << 1;
	j = 1;
	for (i=1;i<n;i+=2) {
		if (j > i) {
			Cudaswap(data[j],data[i]);
			Cudaswap(data[j+1],data[i+1]);
		}
		m = n >> 1;
		while (m >= 2 && j > m) {
			j -= m;
			m >>= 1;
		}
		j += m;
	}
	mmax = 2;
	while (n > mmax) {
		istep = 2*mmax;
		theta = 6.28318530717959/(isign*mmax);
		wtemp = sin(0.5*theta);
		wpr = -2.0*wtemp*wtemp;
		wpi = sin(theta);
		wr = 1.0;
		wi = 0.0;
		for (m=1;m<mmax;m+=2) {
			for (i=m;i<=n;i+=istep) {
				j = i+mmax;
				tempr = wr*data[j]-wi*data[j+1];
				tempi = wr*data[j+1]+wi*data[j];
				data[j] = data[i]-tempr;
				data[j+1] = data[i+1]-tempi;
				data[i] += tempr;
				data[i+1] += tempi;
			}
			wr = (wtemp=wr)*wpr-wi*wpi+wr;
			wi = wi*wpr+wtemp*wpi+wi;
		}
		mmax = istep;
	}
	printf("dunk 2\n");
}

__device__ void Cudafour2(double *fftr, double *ffti, double *rdata, double *idata, int rs, int cs, int isign){
/************************************************************ 

   2-D fourier transform of data with real part stored in
   "rdata" and imaginary part in "idata" with size "rs" x
   "cs". The result is in "fftr" and "ffti". The isign is
   "isign" =  1 forward, and "isign" = -1 inverse 

*************************************************************/
        double *T, *tmp1, *tmp2;
        int i, j;
		
		printf("this 1\n");
        Cudadvector(tmp1, 1,2*cs);
        Cudadvector(tmp2, 1,2*rs);

        Cudadmatrix(T, 1,2*rs,1,cs);
		
		for(int i = 0 ; i < 10 ; i++)
			T[i] = 
		
		printf("\n");
		
        for (i=1;i<=rs;i++) {
            for (j=1;j<=cs;j++) {
                tmp1[j*2-1] = rdata[i * (cs + 1) + j];
                tmp1[j*2] = idata[i * (cs + 1) + j];
            }
            printf("this 2\n");
            Cudafour1(tmp1, cs, isign);
            printf("this 3\n");
            for (j=1;j<=cs;j++){
            	printf("-> %d\n",j);
            	printf("mul: %d %.5lf\n", (i*2) * (cs + 1) + j , T[0] );
                T[(i*2-1) * (cs + 1) + j] = tmp1[j*2-1];
                T[(i*2) * (cs + 1) + j] = tmp1[j*2];
            }
        }
        printf("this 4\n");

        for (i=1;i<=cs;i++) {
            for (j=1;j<=rs;j++) {
                tmp2[j*2-1] = T[(j*2-1) * (cs + 1) + i];
                tmp2[j*2] = T[(j*2) * (cs + 1) + i];
            }
            Cudafour1(tmp2,rs,isign);
            for (j=1;j<=rs;j++) {
                fftr[j * (cs + 1) + i] = tmp2[j*2-1];
                ffti[j * (cs + 1) + i] = tmp2[j*2];
            }
        }
        
        Cudafree_dvector(tmp1, 1, 2*cs);
        Cudafree_dvector(tmp2, 1, 2*rs);
        Cudafree_dmatrix(T, 1, 2*rs, 1, cs); 
}

__device__ void CudaMat_FFT2(CudaMatrix *Output_real, CudaMatrix *Output_imag, CudaMatrix *Input_real, CudaMatrix *Input_imag){
	int xs, ys, i, j;
	//double **R, **I, **Fr, **Fi;
	double *R, *I, *Fr, *Fi;

	xs = Input_real->height;
	ys = Input_real->width;
	
	printf("here 1\n");
    Cudadmatrix(R, 1,xs,1,ys);
    Cudadmatrix(I, 1,xs,1,ys);
    Cudadmatrix(Fr, 1,xs,1,ys);
    Cudadmatrix(Fi, 1,xs,1,ys);
	
	
    for (i=1;i<=Input_real->height;i++) 
        for (j=1;j<=Input_real->width;j++) {
            R[i * (Input_real->width + 1) + j] = Input_real->data[(i-1) * Input_real->width + (j-1)];
            I[i * (Input_real->width + 1) + j] = Input_imag->data[(i-1) * Input_real->width + (j-1)];
        }
	
	
    Cudafour2(Fr, Fi, R, I, xs, ys, 1);         /* 2-D FFT */
	
	printf("here 2\n");
	
    for (i=1;i<=Input_real->height;i++) 
        for (j=1;j<=Input_real->width;j++) {
            Output_real->data[(i-1) * Input_real->width + (j-1)] = Fr[i * (Input_real->width + 1) + j];
            Output_imag->data[(i-1) * Input_real->width + (j-1)] = Fi[i * (Input_real->width + 1) + j];
        }

    Cudafree_dmatrix(R,1,xs,1,ys);
    Cudafree_dmatrix(I,1,xs,1,ys);   
    Cudafree_dmatrix(Fr,1,xs,1,ys);
    Cudafree_dmatrix(Fi,1,xs,1,ys);   
}

__device__ void CudaMat_IFFT2(CudaMatrix *Output_real, CudaMatrix *Output_imag, CudaMatrix *Input_real, CudaMatrix *Input_imag){
	int xs, ys, i, j;
	double *R, *I, *Fr, *Fi, NN;

	xs = Input_real->height;
	ys = Input_real->width;

    Cudadmatrix(R, 1,xs,1,ys);
    Cudadmatrix(I, 1,xs,1,ys);
    Cudadmatrix(Fr, 1,xs,1,ys);
    Cudadmatrix(Fi, 1,xs,1,ys);

    for (i=1;i<=Input_real->height;i++) 
        for (j=1;j<=Input_real->width;j++) {
            R[i * (Input_real->width + 1) + j] = Input_real->data[(i-1) * Input_real->width + (j-1)];
            I[i * (Input_real->width + 1) + j] = Input_imag->data[(i-1) * Input_real->width + (j-1)];
        }

    Cudafour2(Fr, Fi, R, I, xs, ys, -1);         /* 2-D IFFT */

	NN = (double) (xs*ys);

    for (i=1;i<=Input_real->height;i++) 
        for (j=1;j<=Input_real->width;j++) {
            Output_real->data[(i-1) * Input_real->width + (j-1)] = Fr[i * (Input_real->width + 1) + j]/NN;
            Output_imag->data[(i-1) * Input_real->width + (j-1)] = Fi[i * (Input_real->width + 1) + j]/NN;
        }

    Cudafree_dmatrix(R,1,xs,1,ys);
    Cudafree_dmatrix(I,1,xs,1,ys);   
    Cudafree_dmatrix(Fr,1,xs,1,ys);
    Cudafree_dmatrix(Fi,1,xs,1,ys);   
}

__device__ void CudaCopyMatrixValues(CudaMatrix *&A, CudaMatrix *B){
	
	A = new CudaMatrix();
	A->width = 3;//B->width;
	A->height = 3;//B->height;
	
	//A->data = new double[B->width * B->height];
	
	A->data = (double *)malloc(A->width * A->height * sizeof(double));
	
	printf("aw: %d ah: %d\n", A->width, A->height);
	
	for(int i = 0; i < A->width * A->height; i++){
		A->data[i] = B->data[i];
		if(i < 12) printf("%d: %.1lf %.1lf\n", i, A->data[i], B->data[i]);
	}
	printf("\n");
}

__global__ void f(CudaMatrix *Gr ,CudaMatrix *Gi ,double Ul ,double Uh ,int scale ,int orientation ,int flag ,CudaMatrix *F_1 ,CudaMatrix *F_2 ,int side ,
				  CudaMatrix *G_real ,CudaMatrix *G_imag ,CudaMatrix *Tmp_1 ,CudaMatrix *Tmp_2, CudaMatrix *F ,double *features , CudaMatrix *F_real,
				  CudaMatrix *F_imag , CudaMatrix *IMG , CudaMatrix *IMG_imag , int hei, int wid, CudaMatrix *FilteredImg_real, CudaMatrix *FilteredImg_imag){
				  
	int s = blockIdx.x;
	int n = threadIdx.x;
	printf("f: %d %d\n", s, n);
	
	//if( s == 1 && n == 0 ){
	/*CudaMatrix * dev_IMG;
	
	CudaCopyMatrixValues(dev_IMG, IMG);

	printf("Matrix_dev_IMG\n");
	//CudaPrintMatrix(dev_IMG);
	
	free(dev_IMG);
	//}
	*/
	
	CudaGabor(Gr, Gi, s, n, Ul, Uh, scale, orientation, flag);
	
	CudaMat_Copy(F_1, Gr, 0, 0, 0, 0, 2*side, 2*side);//CUDA
	CudaMat_Copy(F_2, Gi, 0, 0, 0, 0, 2*side, 2*side);//CUDA
	
	printf("por cua1?\n");
				
	CudaMat_FFT2(G_real, G_imag, F_1, F_2);//CUDA-no definido
	
	printf("por cua2?\n");
	
	if( s == 0 && n == 0 ){
		double ans = 0;
		for(int i = 0 ; i < F_1->height ; i++)
			for(int j = 0 ; j < F_1->width ; j++)
				ans += F_1->data[ i * F_1->width + j];
		printf("GPU ---> %.5lf\n",ans);
	}
	
	CudaMat_Product(Tmp_1, G_real, F_real);//CUDA
	CudaMat_Product(Tmp_2, G_imag, F_imag);//CUDA
	CudaMat_Substract(IMG, Tmp_1, Tmp_2);//CUDA
	
	
	CudaMat_Product(Tmp_1, G_real, F_imag);//CUDA
	CudaMat_Product(Tmp_2, G_imag, F_real);//CUDA
	CudaMat_Sum(IMG_imag, Tmp_1, Tmp_2);//CUDA
	
	CudaMat_IFFT2(Tmp_1, Tmp_2, IMG, IMG_imag);//CUDA-no definido
	
	//CUDA - logn
	int base = scale * orientation;
	
	double m = 0;
	for (int h=0;h<hei;h++)
		for (int w=0;w<wid;w++) {
			F->data[h * wid + w] = sqrt(pow(IMG->data[h * wid + w], 2.0)+pow(IMG_imag->data[h * wid + w], 2.0));
			m += F->data[h * wid + w];
		}

	m /= (double) (hei*wid);
	features[s*orientation+n] = (float) m;
	
	//CUDA - logn
	double v = 0;
	for (int h=0;h<hei;h++)
		for (int w=0;w<wid;w++)
			v += (F->data[h * wid + w]-m)*(F->data[h * wid + w]-m);
	
	v /= (double) (hei*wid);
	features[base+s*orientation+n] = (float) sqrt(v);
    
	CudaMat_Copy(FilteredImg_real, Tmp_1, s*hei, n*wid, 2*side, 2*side, hei+2*side-1, wid+2*side-1);//CUDA
	CudaMat_Copy(FilteredImg_imag, Tmp_2, s*hei, n*wid, 2*side, 2*side, hei+2*side-1, wid+2*side-1);//CUDA
	
}

void GaborFilteredImg(Matrix *FilteredImg_real, Matrix *FilteredImg_imag, Matrix *img, int side, double Ul, double Uh, int scale, int orientation, int flag){
	int h, w, xs, ys, border, r1, r2, r3, r4, hei, wid, s, n, base;
	Matrix *IMG, *IMG_imag, *Gr, *Gi, *Tmp_1, *Tmp_2, *F_1, *F_2, *G_real, *G_imag, *F_real, *F_imag,*F;
	double m, v;
	
	base = scale*orientation;
	double *features; //exact memory
	features = (double *)malloc( 2 * scale * orientation * sizeof(double) );

	border = side;
	hei = img->height;
	wid = img->width;

	/* FFT2 */
	xs = (int) pow(2.0, ceil(log2((double)(img->height+2.0*border))));
	ys = (int) pow(2.0, ceil(log2((double)(img->width+2.0*border))));

	CreateMatrix(&IMG, xs, ys);

	r1 = img->width+border;
	r2 = img->width+2*border;
	for (h=0;h<border;h++) {
		for (w=0;w<border;w++)
			IMG->data[h][w] = img->data[border-1-h][border-1-w];
		for (w=border;w<r1;w++)
			IMG->data[h][w] = img->data[border-1-h][w-border];
		for (w=r1;w<r2;w++)
			IMG->data[h][w] = img->data[border-1-h][2*img->width-w+border-1];
	}

	r1 = img->height+border;
	r2 = img->width+border;
	r3 = img->width+2*border;
	for (h=border;h<r1;h++) {
		for (w=0;w<border;w++)
			IMG->data[h][w] = img->data[h-border][border-1-w];
		for (w=border;w<r2;w++)
			IMG->data[h][w] = img->data[h-border][w-border];
		for (w=r2;w<r3;w++)
			IMG->data[h][w] = img->data[h-border][2*img->width-w+border-1];
	}

	r1 = img->height+border;
	r2 = img->height+2*border;
	r3 = img->width+border;
	r4 = img->width+2*border;
	for (h=r1;h<r2;h++) {
		for (w=0;w<border;w++)
			IMG->data[h][w] = img->data[2*img->height-h+border-1][border-1-w];
		for (w=border;w<r3;w++)
			IMG->data[h][w] = img->data[2*img->height-h+border-1][w-border];
		for (w=r3;w<r4;w++)
			IMG->data[h][w] = img->data[2*img->height-h+border-1][2*img->width-w+border-1];
	}
	
	CreateMatrix(&F_real, xs, ys);
	CreateMatrix(&F_imag, xs, ys);
	CreateMatrix(&IMG_imag, xs, ys);

	
	Mat_FFT2(F_real, F_imag, IMG, IMG_imag);
	
	//Declaring variables for CUDA process
	CudaMatrix *dev_Gr, *dev_Gi, *dev_Tmp1, *dev_Tmp2, *dev_F_1, *dev_F_2, *dev_G_real, *dev_G_imag, *dev_F, *dev_F_real , *dev_F_imag, *dev_IMG, *dev_IMG_imag, *dev_FilteredImg_real, *dev_FilteredImg_imag;
	
	//Coping all the matrix
	CudaCopyMatrix( dev_F_real , F_real );
	CudaCopyMatrix( dev_F_imag , F_imag );
	CudaCopyMatrix( dev_IMG , IMG);
	CudaCopyMatrix( dev_IMG_imag , IMG_imag );
	CudaCopyMatrix( dev_FilteredImg_real, FilteredImg_real);
	CudaCopyMatrix( dev_FilteredImg_imag, FilteredImg_imag);
	
	//Print<<<1,1>>>( dev_IMG );
	
	//Debug
	
	//PrintMatrix(IMG);
	//printf("\n\n");
	//Print<<<1,1>>>( dev_IMG );
	
	/////
	
	//Creating Matrix for CUDA and free
	CudaCreateMatrix( dev_Gr , 2 * side + 1 , 2 * side + 1 );
	CudaCreateMatrix( dev_Gi , 2 * side + 1 , 2 * side + 1 );
	CudaCreateMatrix( dev_Tmp1 , xs , ys );
	CudaCreateMatrix( dev_Tmp2 , xs , ys );
	CudaCreateMatrix( dev_F_1 , xs , ys );
	CudaCreateMatrix( dev_F_2 , xs , ys );
	CudaCreateMatrix( dev_G_real , xs , ys );
	CudaCreateMatrix( dev_G_imag , xs , ys );
	CudaCreateMatrix( dev_F , hei , wid );
	
	double *dev_features;
	cudaMalloc( &dev_features , 2 * scale * orientation * sizeof(double) );
	cudaMemset( (void *)dev_features , 0.0 , 2 * scale * orientation * sizeof(double) );

	f<<< 1 , 1 >>>( dev_Gr , dev_Gi , Ul , Uh , scale , orientation, flag, dev_F_1 , dev_F_2 , side , dev_G_real , dev_G_imag , dev_Tmp1 , dev_Tmp2 , dev_F ,
					dev_features , dev_F_real, dev_F_imag , dev_IMG , dev_IMG_imag , hei , wid, dev_FilteredImg_real, dev_FilteredImg_imag);
	
	double *features2 = new double [2 * scale * orientation];
	
	cudaMemcpy(features2, dev_features, 2 * scale * orientation * sizeof(double), cudaMemcpyDeviceToHost);
	
	for(int i = 0 ; i < 2 * scale * orientation ; i++)
		printf("%.2lf ",features2[i]);
	printf("\n");
	
	//LIBERA LA MATRIZ CREADA (de paso tambien libera "data" de la funcion creo)
	cudaFree(dev_F_real);
	cudaFree(dev_F_imag);
	cudaFree(dev_Gr);
	cudaFree(dev_Gi);
	cudaFree(dev_Tmp1);
	cudaFree(dev_Tmp2);
	cudaFree(dev_F_1);
	cudaFree(dev_F_2);
	cudaFree(dev_G_real);
	cudaFree(dev_G_imag);
	cudaFree(dev_F);	
	cudaFree(dev_features);
	cudaFree(dev_FilteredImg_real);
	cudaFree(dev_FilteredImg_imag);
	cudaFree(dev_IMG);
	cudaFree(dev_IMG_imag);
	
	/////////////////////////
	
	/* ----------- compute the Gabor filtered output ------------- */
	CreateMatrix(&Gr, 2*side+1, 2*side+1);   
	CreateMatrix(&Gi, 2*side+1, 2*side+1);
	CreateMatrix(&Tmp_1, xs, ys);
	CreateMatrix(&Tmp_2, xs, ys);
	CreateMatrix(&F_1, xs, ys);
	CreateMatrix(&F_2, xs, ys);
	CreateMatrix(&G_real, xs, ys);
	CreateMatrix(&G_imag, xs, ys);
    CreateMatrix(&F, hei, wid);
    
	for (s=0;s<scale;s++){
		for (n=0;n<orientation;n++){
			if( s != 0 or n != 0 ) continue;
			Gabor(Gr, Gi, s+1, n+1, Ul, Uh, scale, orientation, flag);//CUDA- 2 normales y logn
			
			double x = 0 , y = 0;
			for(int i = 0 ; i < Gr->height ; i++)
					for(int j = 0 ; j < Gr->width ; j++)
						x += Gr->data[i][j] , y += Gi->data[i][j];
			
			printf("CPU x and y: %.25lf %.25lf\n", x , y );
			
			Mat_Copy(F_1, Gr, 0, 0, 0, 0, 2*side, 2*side);//CUDA
			Mat_Copy(F_2, Gi, 0, 0, 0, 0, 2*side, 2*side);//CUDA
				
			double ac_F_1 = 0;
			for(int i = 0; i <= 2 * side; i++)
				for(int j = 0; j <= 2 * side; j++)
					ac_F_1 += F_1->data[i][j];
	
			printf("CPU ac_F_1: %.40lf\n", ac_F_1);	
			
			Mat_FFT2(G_real, G_imag, F_1, F_2);//CUDA-no definido
			
			double ans = 0;
			for(int i = 0 ; i < F_1->height ; i++)
				for(int j = 0 ; j < F_1->width ; j++)
					ans += F_1->data[i][j];
			printf("CPU ---> %.5lf\n",ans);
			
			
			Mat_Product(Tmp_1, G_real, F_real);//CUDA
			Mat_Product(Tmp_2, G_imag, F_imag);//CUDA
			Mat_Substract(IMG, Tmp_1, Tmp_2);//CUDA

			Mat_Product(Tmp_1, G_real, F_imag);//CUDA
			Mat_Product(Tmp_2, G_imag, F_real);//CUDA
			Mat_Sum(IMG_imag, Tmp_1, Tmp_2);//CUDA

			Mat_IFFT2(Tmp_1, Tmp_2, IMG, IMG_imag);//CUDA-no definido
			
			if( s == 0 && n == 0 ){
				double im = 0;
				for(int i = 0 ; i < IMG->height ; i++)
				for(int j = 0 ; j < IMG->width ; j++)
					im += fabs(IMG->data[i][j]);

				printf("CPU im: %.50lf\n", im );
			
				double ac_Tmp_2 = 0;
				for(int i = 0 ; i < xs ; i++)
					for(int j = 0 ; j < ys ; j++)
						ac_Tmp_2 += Tmp_2->data[i][j];
			
				printf("CPU ac_Tmp_2: %.50lf\n", ac_Tmp_2 );
			}
			//CUDA - logn
			m = 0;
			for (h=0;h<hei;h++)
				for (w=0;w<wid;w++) {
					F->data[h][w] = sqrt(pow(IMG->data[h][w], 2.0)+pow(IMG_imag->data[h][w], 2.0));
					m += F->data[h][w];
				}

			m /= (double) (hei*wid);
			features[s*orientation+n] = (float) m;
			
			//CUDA - logn
			v = 0;
			for (h=0;h<hei;h++)
				for (w=0;w<wid;w++)
					v += (F->data[h][w]-m)*(F->data[h][w]-m);

			v /= (double) (hei*wid);
			features[base+s*orientation+n] = (float) sqrt(v);
            
            if( s == 0 && n == 0 ) printf("CPU m: %.20lf  v: %.20lf\n",m ,v); 
            
			Mat_Copy(FilteredImg_real, Tmp_1, s*hei, n*wid, 2*side, 2*side, hei+2*side-1, wid+2*side-1);//CUDA
			Mat_Copy(FilteredImg_imag, Tmp_2, s*hei, n*wid, 2*side, 2*side, hei+2*side-1, wid+2*side-1);//CUDA
			
		}
	}
	
	for(int i = 0 ; i < 2 * scale * orientation ; i++)
		printf("%.2lf ",features[i]);
	printf("\n");

	FreeMatrix(Gr);
	FreeMatrix(Gi);
	FreeMatrix(Tmp_1);
	FreeMatrix(Tmp_2);
	FreeMatrix(F_1);
	FreeMatrix(F_2);
	FreeMatrix(G_real);
	FreeMatrix(G_imag);
	FreeMatrix(F_real);
	FreeMatrix(F_imag);
	FreeMatrix(IMG);
	FreeMatrix(IMG_imag);
}

/* ------------------------------------------------------------------------------------------------------
The Gabor function generates a Gabor filter with the selected index 's' and 'n' (scale and orientation, 
respectively) from a Gabor filter bank. This filter bank is designed by giving the range of spatial 
frequency (Uh and Ul) and the total number of scales and orientations used to partition the spectrum. 

The returned filter is stored in 'Gr' (real part) and 'Gi' (imaginary part).
--------------------------------------------------------------------------------------------------------*/
void Gabor(Matrix *Gr, Matrix *Gi, int s, int n, double Ul, double Uh, int scale, int orientation, int flag){
	double base, a, u0, z, Uvar, Vvar, Xvar, Yvar, X, Y, G, t1, t2, m;
	int x, y, side;

	base = Uh/Ul;
	a = pow(base, 1.0/(double)(scale-1));

	u0 = Uh/pow(a, (double) scale-s);

	Uvar = (a-1.0)*u0/((a+1.0)*sqrt(2.0*log(2.0)));

	z = -2.0*log(2.0)*(Uvar*Uvar)/u0;
	Vvar = tan(pi/(2*orientation))*(u0+z)/sqrt(2.0*log(2.0)-z*z/(Uvar*Uvar));

        Xvar = 1.0/(2.0*pi*Uvar);
        Yvar = 1.0/(2.0*pi*Vvar);

	t1 = cos(pi/orientation*(n-1.0));
	t2 = sin(pi/orientation*(n-1.0));

	side = (int) (Gr->height-1)/2;

	//CUDA
	for (x=0;x<2*side+1;x++) {
		for (y=0;y<2*side+1;y++) {
			X = (double) (x-side)*t1+ (double) (y-side)*t2;
			Y = (double) -(x-side)*t2+ (double) (y-side)*t1;
			G = 1.0/(2.0*pi*Xvar*Yvar)*pow(a, (double) scale-s)*exp(-0.5*((X*X)/(Xvar*Xvar)+(Y*Y)/(Yvar*Yvar)));
			Gr->data[x][y] = G*cos(2.0*pi*u0*X);
			Gi->data[x][y] = G*sin(2.0*pi*u0*X);
		}
	}

	/* if flag = 1, then remove the DC from the filter */
	

	if (flag == 1) {
	
		//CUDA - logn
		m = 0;
		for (x=0;x<2*side+1;x++)
			for (y=0;y<2*side+1;y++)
				m += Gr->data[x][y];

		m /= pow((double) 2.0*side+1, 2.0);
		
		
		//CUDA
		for (x=0;x<2*side+1;x++)
			for (y=0;y<2*side+1;y++)
				Gr->data[x][y] -= m;
	}	
}

int main(int argc, char **argv){
	
	tStart = clock();

	int hei, wid, side, scale, orientation, flag;//, s, n;
	//Matrix *Gabor_r, *Gabor_i, *Gr, *Gi, *img, *F_r, *F_i;
	Matrix *img , *F_r , *F_i;
	FILE *fp;
	unsigned char *tmp; 
	//float *output;
	double Ul, Uh;
	/* --------------------------- Example --------------------------------
		scale = 3, 
		orientation = 4, 
		Uh (highest spatial frequency) = 0.4, 
		Ul (lowest spatial frequency) = 0.1,
		flag (removing the DC term) = 0 (False),
		side (filter dimension = (2*side+1)*(2*side+1)) = 60
	----------------------------------------------------------------------- */
	scale = 3;
	orientation = 4;
	Ul = 0.1;
	Uh = 0.4;
	flag = 0;
	side = 60;

	if (argc != 4) {
		printf("usage: %s <image_name> <height> <width>\n",argv[0]);
		exit(0);
	}
	
	hei = atoi(argv[2]);
	wid = atoi(argv[3]);

	tmp = (unsigned char *) calloc(hei*wid, sizeof(unsigned char));

	if ((fp = fopen(argv[1],"r")) == NULL) {
		printf("%s can not be open!\n", argv[1]);
		exit(0);
	}
	fread(tmp, sizeof(unsigned char), hei*wid, fp);
	fclose(fp);

	
	CreateMatrix(&img, hei, wid);
	for(int i = 0 ; i < hei ; i++)
		for(int j = 0 ; j < wid ; j++)
			img->data[i][j] = (double) (tmp[i*wid+j]);
			
	free(tmp);
		
	CreateMatrix(&F_r, hei*scale, wid*orientation);
	CreateMatrix(&F_i, hei*scale, wid*orientation);

	printf("Time taken_before_Gabor: %.2fms\n", 1000.0 * (double)(clock() - tStart)/CLOCKS_PER_SEC);

	GaborFilteredImg(F_r, F_i, img, side, Ul, Uh, scale, orientation, flag);

	printf("Time taken_after_Gabor: %.2fms\n", 1000.0 * (double)(clock() - tStart)/CLOCKS_PER_SEC);	

	FreeMatrix(F_r);
	FreeMatrix(F_i);
	
	printf("Total time taken: %.2fms\n", 1000.0 * (double)(clock() - tStart)/CLOCKS_PER_SEC);
	
	return 0;
}
