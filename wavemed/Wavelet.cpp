//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "Wavelet.h"

using namespace GBDI;
#pragma package(smart_init)
//---------------------------------------------------------------------------

void TWavelet::CalculaWavelet(Graphics::TBitmap * src, int niveis, int WaveletTipo)
{
        switch(WaveletTipo){
            case 0 : HaarWavelet(src, niveis); break;
            case 1 : DaubechiesWavelet(src, niveis); break;
        }
}

void TWavelet::HaarWavelet(Graphics::TBitmap * src, int niveis)
{

      int mit1,mit2,i,y,k,j;

        ImageWidth = mit1 = src->Width;
        ImageHeight = mit2 = src->Height;

        CarregaTabela(src);

        for(i = 1; i<=niveis; i++)
        {
            mit1 = mit1/2;
            mit2 = mit2/2;


            for(y=0; y < mit2*2; y++)
            {
                for(j=0; j < mit1*2; j=j+2)
                    TempMatrix[y][j/2]= ((AuxMatrix[y][j] + AuxMatrix[y][j+1])*sqrt(2)/2);

                for(k=0; k < mit1*2; k=k+2)
                    TempMatrix[y][k/2 + mit1] = ((AuxMatrix[y][k] - AuxMatrix[y][k+1])*sqrt(2)/2);
            }
            for(y=0; y < mit1*2; y++)
            {
                for(j=0; j < mit2*2; j=j+2)
                    AuxMatrix[j/2][y]=((TempMatrix[j][y]+TempMatrix[j+1][y])*sqrt(2)/2);

                for(k=0; k < mit2*2; k=k+2)
                    AuxMatrix[k/2 + mit2][y] = ((TempMatrix[k][y]- TempMatrix[k+1][y])*sqrt(2)/2);
            }
        };

        NormalizaMatriz();
        for (int y = 0; y < ImageHeight; y++)
           for (int x = 0; x < ImageWidth; x++)
               src->Canvas->Pixels[y][x] = RGB(AuxMatrix[x][y],AuxMatrix[x][y],AuxMatrix[x][y]);

};

void TWavelet::DaubechiesWavelet(Graphics::TBitmap * src, int niveis)
{
        int mit1,mit2,i,y,k,j;

        ImageWidth = mit1 = src->Width;
        ImageHeight = mit2 = src->Height;

        CarregaTabela(src);

        for(i = 1; i<=niveis; i++)
        {
          mit1 = mit1/2;
          mit2 = mit2/2;

          for(y=0; y < mit2*2; y++)
          {
            TempMatrix[y][0]=((AuxMatrix[y][mit2*2-2]*(1+sqrt(3)) + AuxMatrix[y][mit2*2-1]*(3+sqrt(3))+ AuxMatrix[y][0]*(3-sqrt(3))+AuxMatrix[y][1]*(1-sqrt(3)))*sqrt(2)/(8) );
            for(j=2; j < mit1*2; j=j+2)
                TempMatrix[y][j/2]=((AuxMatrix[y][j]*(1+sqrt(3)) + AuxMatrix[y][j+1]*(3+sqrt(3))+ AuxMatrix[y][j+2]*(3-sqrt(3))+AuxMatrix[y][j+3]*(1-sqrt(3)))*sqrt(2)/(8) );

            TempMatrix[y][mit1] = ((AuxMatrix[y][mit2*2-2]*(1-sqrt(3)) + AuxMatrix[y][mit2*2-1]*(sqrt(3)-3) + AuxMatrix[y][0]*(3+sqrt(3)) - AuxMatrix[y][1]*(1+sqrt(3)))*sqrt(2)/(8) );
            for(k=2; k < mit1*2; k=k+2)
                TempMatrix[y][k/2 + mit1] = ((AuxMatrix[y][k]*(1-sqrt(3)) + AuxMatrix[y][k+1]*(sqrt(3)-3) + AuxMatrix[y][k+2]*(3+sqrt(3)) - AuxMatrix[y][k+3]*(1+sqrt(3)))*sqrt(2)/(8) );

          }
          for(y=0; y < mit1*2; y++)
          {
            AuxMatrix[0][y]=((TempMatrix[mit2*2-2][y]*(1+sqrt(3)) + TempMatrix[mit2*2-1][y]*(3+sqrt(3))+ TempMatrix[0][y]*(3-sqrt(3))+ TempMatrix[1][y]*(1-sqrt(3)))*sqrt(2)/(8) );
            for(j=2; j < mit2*2; j=j+2)
                AuxMatrix[j/2][y]=((TempMatrix[j][y]*(1+sqrt(3)) + TempMatrix[j+1][y]*(3+sqrt(3))+ TempMatrix[j+2][y]*(3-sqrt(3))+ TempMatrix[j+3][y]*(1-sqrt(3)))*sqrt(2)/(8) );

            AuxMatrix[mit2][y] = ((TempMatrix[mit2*2-2][y]*(1-sqrt(3)) + TempMatrix[mit2*2-1][y]*(sqrt(3)-3) + TempMatrix[0][y]*(3+sqrt(3)) - TempMatrix[1][y]*(1+sqrt(3)))*sqrt(2)/(8) );
            for(k=2; k < mit2*2; k=k+2)
                AuxMatrix[k/2 + mit2][y] = ((TempMatrix[k][y]*(1-sqrt(3)) + TempMatrix[k+1][y]*(sqrt(3)-3) + TempMatrix[k+2][y]*(3+sqrt(3)) - TempMatrix[k+3][y]*(1+sqrt(3)))*sqrt(2)/(8) );
          }
        }

        NormalizaMatriz();
        for (int y = 0; y < ImageHeight; y++)
           for (int x = 0; x < ImageWidth; x++)
               src->Canvas->Pixels[y][x] = RGB(AuxMatrix[x][y],AuxMatrix[x][y],AuxMatrix[x][y]);
}

void TWavelet::CarregaTabela(Graphics::TBitmap * src)
{
        int nCount, nCountX, nCountY, RR, GG, BB, nResult;
        DWORD TheRGBValue;

        for(nCountX = 0; nCountX < ImageWidth; nCountX ++)
                for(nCountY = 0; nCountY < ImageHeight; nCountY ++)
                {
                        TheRGBValue = ColorToRGB(src->Canvas->Pixels[nCountX][nCountY]);
                        RR = GetRValue(TheRGBValue);
                        GG = GetGValue(TheRGBValue);
                        BB = GetBValue(TheRGBValue);

                        nResult = (RR + GG + BB)/3;
                        AuxMatrix[nCountY][nCountX] = nResult;
                }
}

void TWavelet::NormalizaMatriz()
{ float max, min, aux, dif;

     max = AuxMatrix[0][0];
     min = max;
     for(int i = 0; i<ImageWidth; i++)
        for(int j = 0; j<ImageHeight; j++)
        {    if(AuxMatrix[i][j]> max)
                    max = AuxMatrix[i][j];
             if(AuxMatrix[i][j]< min)
                    min = AuxMatrix[i][j];
        }
     dif = max - min;
     for(int i = 0; i<ImageWidth; i++)
        for(int j = 0; j<ImageHeight; j++)
              AuxMatrix[i][j] = 255*abs(AuxMatrix[i][j])/dif;

}

