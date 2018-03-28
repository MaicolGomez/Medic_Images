//---------------------------------------------------------------------------

#ifndef WaveletH
#define WaveletH
//---------------------------------------------------------------------------
#include <vcl.h>
#include <gbdi/image.h>
namespace GBDI{
//---------------------------------------------------------------------------
class TWavelet{
private :
   double TempMatrix[700][700];

public :

        double AuxMatrix[700][700];
        int ImageHeight, ImageWidth;

        virtual void CalculaWavelet(Graphics::TBitmap * src, int niveis,int WaveletTipo);
  protected:
        virtual void HaarWavelet(Graphics::TBitmap * src, int niveis);
        virtual void DaubechiesWavelet(Graphics::TBitmap * src, int niveis);
        virtual void CarregaTabela(Graphics::TBitmap * src);
        virtual void NormalizaMatriz();

//    friend class TFeature;
};
}
#endif
