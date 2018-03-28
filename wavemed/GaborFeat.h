//---------------------------------------------------------------------------

#ifndef GaborFeatH
#define GaborFeatH
//---------------------------------------------------------------------------
//#include <vcl.h>
//#include <gbdi/image.h>
#include "Matrix.h"
//using namespace GBDI;
//---------------------------------------------------------------------------

void GaborFeature(double *features, Matrix *img, int side, double Ul, double Uh, int scale, int orientation, int flag);
void Gabor(Matrix *Gr, Matrix *Gi, int s, int n, double Ul, double Uh, int scale, int orientation, int flag);

#endif

