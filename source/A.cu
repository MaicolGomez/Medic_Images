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

typedef struct MatrixStruct {
	double **data;
	int height, width;
} Matrix;

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
		for (n=0;n<orientation;n++) {
			Gabor(Gr, Gi, s+1, n+1, Ul, Uh, scale, orientation, flag);//CUDA- 2 normales y logn
			Mat_Copy(F_1, Gr, 0, 0, 0, 0, 2*side, 2*side);//CUDA
			Mat_Copy(F_2, Gi, 0, 0, 0, 0, 2*side, 2*side);//CUDA
			Mat_FFT2(G_real, G_imag, F_1, F_2);//CUDA-no definido

			Mat_Product(Tmp_1, G_real, F_real);//CUDA
			Mat_Product(Tmp_2, G_imag, F_imag);//CUDA
			Mat_Substract(IMG, Tmp_1, Tmp_2);//CUDA

			Mat_Product(Tmp_1, G_real, F_imag);//CUDA
			Mat_Product(Tmp_2, G_imag, F_real);//CUDA
			Mat_Sum(IMG_imag, Tmp_1, Tmp_2);//CUDA

			Mat_IFFT2(Tmp_1, Tmp_2, IMG, IMG_imag);//CUDA-no definido
			
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
            
			Mat_Copy(FilteredImg_real, Tmp_1, s*hei, n*wid, 2*side, 2*side, hei+2*side-1, wid+2*side-1);//CUDA
			Mat_Copy(FilteredImg_imag, Tmp_2, s*hei, n*wid, 2*side, 2*side, hei+2*side-1, wid+2*side-1);//CUDA
		}
	}
	
    for(int i = 0 ; i < (2 * scale * orientation) ; i++)
        printf("%.8lf ",features[i]);
    printf("\n");
    cout << 2 * scale  * orientation << endl;
    
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

	GaborFilteredImg(F_r, F_i, img, side, Ul, Uh, scale, orientation, flag);

	FreeMatrix(F_r);
	FreeMatrix(F_i);
	return 0;
}
