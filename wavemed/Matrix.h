//---------------------------------------------------------------------------

#ifndef MatrixH
#define MatrixH
//---------------------------------------------------------------------------
//#include <vcl.h>
//#include <gbdi/image.h>
//using namespace GBDI;
//---------------------------------------------------------------------------

class Matrix
{
public:
    double **lData;
    int height, width;

};


class uc_Matrix
{
public:
    unsigned char **data;
    int height, width;
};

class i_Matrix
{
public:
    int **data;
    int height, width;
};

class Region
{
public:
    int id;
    int number;
    int *member_i;
    int *member_j;
};

//---------------------------------------------------------------------------

#define PI 3.141592653587931159796346854418516159056171875
#define SWAP(a,b) tempr=(a); (a)=(b); (b)=tempr


    void nrerror();
    double *dvector();
    float *vector();
    void free_dvector();
    void free_vector();
    float **matrix();
    double **dmatrix();
    void free_matrix();
    void free_dmatrix();
    void sort(double *Y, int *I, double *A, int length);
    void minimun(double *Y, int *I, double *A, int length);
    void Create_uc_Matrix();
    void Free_uc_Matrx();
    void CreateMatrix(Matrix **M, int hei, int wid);
    void FreeMatrix(Matrix *M);
    void Create_i_Matrix();
    void Free_i_Matrx();
    void Mat_Abs(Matrix *A);
    void Mat_Mean(double *mean, Matrix *A);
    void Mat_Vector(Matrix *A, float *a);
    void Mat_Shift(Matrix *A, Matrix *B, int side);
    void Mat_Zeros(Matrix *A);
    void Mat_Zeros_uc(uc_Matrix *A);
    void Mat_Zeros_i(i_Matrix *A);
    void Mat_FFT2(Matrix *Output_real, Matrix *Output_imag, Matrix *Input_real, Matrix *Input_imag);
    void Mat_IFFT2(Matrix *Output_real, Matrix *Output_imag, Matrix *Input_real, Matrix *Input_imag);
    void four2(double **fftr, double **ffti, double **rdata, double **idata, int rs, int cs, int isign);
    void four1(double *data, int nn, int isign);
    void Mat_Copy(Matrix *A, Matrix *B, int h_target, int w_target, int h_begin, int w_begin, int h_end, int w_end);
    void Mat_uc_Copy(uc_Matrix *A, uc_Matrix *B, int h_target, int w_target, int h_begin, int w_begin, int h_end, int w_end);
    void Mat_i_Copy(i_Matrix *A, i_Matrix *B, int h_target, int w_target, int h_begin, int w_begin, int h_end, int w_end);
    void Mat_Product(Matrix *A, Matrix *B, Matrix *C);
    void Mat_Sum(Matrix *A, Matrix *B, Matrix *C);
    void Mat_Substract(Matrix *A, Matrix *B, Matrix *C);
    void Mat_Fliplr(Matrix *A);
    void Mat_Flipud(Matrix *A);
    void Mat_uc_Fliplr(uc_Matrix *A);
    void Mat_uc_Flipud(uc_Matrix *A);
    double log2(double a);


#endif