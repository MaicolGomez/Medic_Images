#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <malloc.h>
#include "matrix.h"

void Gabor(Matrix *Gr, Matrix *Gi, int s, int n, double Ul, double Uh, 
int scale, int orientation, int flag);

void GaborFilteredImg(Matrix *FilteredImg_real, Matrix *FilteredImg_imag, Matrix *img, int side, 
double Ul, double Uh, int scale, int orientation, int flag);

void main(int argc, char **argv)
{
	int hei, wid, i, j, side, scale, orientation, flag, s, n;
	Matrix *Gabor_r, *Gabor_i, *Gr, *Gi, *img, *F_r, *F_i;
	FILE *fp;
	unsigned char *tmp; 
	float *output;
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
	for (i=0;i<hei;i++)
		for (j=0;j<wid;j++) 
			img->data[i][j] = (double) (tmp[i*wid+j]);

	free(tmp);

	/* ------ print out the Gabor filters (intensity plot) ----------------- */
	CreateMatrix(&Gr, 2*side+1, 2*side+1);
	CreateMatrix(&Gi, 2*side+1, 2*side+1);
	CreateMatrix(&Gabor_r, (2*side+1)*scale, (2*side+1)*orientation);
	CreateMatrix(&Gabor_i, (2*side+1)*scale, (2*side+1)*orientation);

	for (s=0;s<scale;s++)
		for (n=0;n<orientation;n++) {
			Gabor(Gr, Gi, s+1, n+1, Ul, Uh, scale, orientation, flag);
			Mat_Copy(Gabor_r, Gr, s*(2*side+1), n*(2*side+1), 0, 0, 2*side, 2*side);
			Mat_Copy(Gabor_i, Gi, s*(2*side+1), n*(2*side+1), 0, 0, 2*side, 2*side);
		}

	output = (float *) calloc((2*side+1)*scale*(2*side+1)*orientation, sizeof(float));

	Mat_Vector(Gabor_r, output);

	fp = fopen("Gabor.R","wb");
	fwrite(output, sizeof(float), (2*side+1)*scale*(2*side+1)*orientation, fp);
	fclose(fp);

	Mat_Vector(Gabor_i, output);

	fp = fopen("Gabor.I","wb");
	fwrite(output, sizeof(float), (2*side+1)*scale*(2*side+1)*orientation, fp);
	fclose(fp);

	free(output);
	FreeMatrix(Gr);
	FreeMatrix(Gi);
	FreeMatrix(Gabor_r);
	FreeMatrix(Gabor_i);

	/* ------ Save the Gabor filtered outputs ----------------- */
	CreateMatrix(&F_r, hei*scale, wid*orientation);
	CreateMatrix(&F_i, hei*scale, wid*orientation);

	GaborFilteredImg(F_r, F_i, img, side, Ul, Uh, scale, orientation, flag);

	output = (float *) calloc(F_r->height*F_r->width, sizeof(float));

	Mat_Vector(F_r, output);

	fp = fopen("Output.R","wb");
	fwrite(output, sizeof(float), F_r->height*F_r->width, fp);
	fclose(fp);

	Mat_Vector(F_i, output);

	fp = fopen("Output.I","wb");
	fwrite(output, sizeof(float), F_i->height*F_i->width, fp);
	fclose(fp);

	free(output);
	FreeMatrix(F_r);
	FreeMatrix(F_i);
}

