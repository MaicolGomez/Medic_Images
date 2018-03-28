
#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include <math.h>
#include "GaborFeat.h"
//using namespace GBDI;

void GaborFeature(double *features, Matrix *img, int side, double Ul, double Uh, int scale, int orientation, int flag)
{
    int h, w, xs, ys, r1, r2, r3, r4, hei, wid, s, n, base;
    Matrix *IMG, *IMG_imag, *Gr, *Gi, *Tmp_1, *Tmp_2, *F_1, *F_2, *G_real, *G_imag, *F_real, *F_imag, *F;
	double m, v;

	hei = img->height;
	wid = img->width;

	xs = (int) pow(2.0, ceil(log2((double) img->height)));
	ys = (int) pow(2.0, ceil(log2((double) img->width)));

	CreateMatrix(&IMG, xs, ys);
	for (h=0;h<hei;h++)
		for (w=0;w<wid;w++)
			IMG->lData[h][w] = img->lData[h][w];

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

	base = scale*orientation;

	for (s=0;s<scale;s++) {
		for (n=0;n<orientation;n++) {
			Gabor(Gr, Gi, s+1, n+1, Ul, Uh, scale, orientation, flag);
			Mat_Copy(F_1, Gr, 0, 0, 0, 0, 2*side, 2*side);
			Mat_Copy(F_2, Gi, 0, 0, 0, 0, 2*side, 2*side);
			Mat_FFT2(G_real, G_imag, F_1, F_2);

			Mat_Product(Tmp_1, G_real, F_real);
			Mat_Product(Tmp_2, G_imag, F_imag);
			Mat_Substract(IMG, Tmp_1, Tmp_2);

			Mat_Product(Tmp_1, G_real, F_imag);
			Mat_Product(Tmp_2, G_imag, F_real);
			Mat_Sum(IMG_imag, Tmp_1, Tmp_2);

			Mat_IFFT2(Tmp_1, Tmp_2, IMG, IMG_imag);
			Mat_Shift(IMG, Tmp_1, side);
			Mat_Shift(IMG_imag, Tmp_2, side);

			m = 0;
			for (h=0;h<hei;h++)
				for (w=0;w<wid;w++) {
					F->lData[h][w] = sqrt(pow(IMG->lData[h][w], 2.0)+pow(IMG_imag->lData[h][w], 2.0));
					m += F->lData[h][w];
				}

			m /= (double) (hei*wid);
			features[s*orientation+n] = (float) m;

			v = 0;
			for (h=0;h<hei;h++)
				for (w=0;w<wid;w++)
					v += (F->lData[h][w]-m)*(F->lData[h][w]-m);

			v /= (double) (hei*wid);
			features[base+s*orientation+n] = (float) sqrt(v);
		}
	}

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
	FreeMatrix(F);

}

void Gabor(Matrix *Gr, Matrix *Gi, int s, int n, double Ul, double Uh, int scale, int orientation, int flag)
{
    double base, a, u0, z, var, X, Y, G, t1, t2, m;
	int x, y, side;

	base = Uh/Ul;
	a = pow(base, 1.0/(double)(scale-1));

	u0 = Uh/pow(a, (double) scale-s);

        var = pow(0.6/Uh*pow(a, (double) scale-s), 2.0);

	t1 = cos((double) PI/orientation*(n-1.0));
	t2 = sin((double) PI/orientation*(n-1.0));

	side = (int) (Gr->height-1)/2;

	for (x=0;x<2*side+1;x++) {
		for (y=0;y<2*side+1;y++) {
			X = (double) (x-side)*t1+ (double) (y-side)*t2;
			Y = (double) -(x-side)*t2+ (double) (y-side)*t1;
			G = 1.0/(2.0*PI*var)*pow(a, (double) scale-s)*exp(-0.5*(X*X+Y*Y)/var);
			Gr->lData[x][y] = G*cos(2.0*PI*u0*X);
			Gi->lData[x][y] = G*sin(2.0*PI*u0*X);
		}
	}

	/* if flag == 1, then remove the DC from the real part of Gabor */

	if (flag == 1) {
		m = 0;
		for (x=0;x<2*side+1;x++)
			for (y=0;y<2*side+1;y++)
				m += Gr->lData[x][y];

		m /= pow((double) 2.0*side+1, 2.0);

		for (x=0;x<2*side+1;x++)
			for (y=0;y<2*side+1;y++)
				Gr->lData[x][y] -= m;
	}

}
