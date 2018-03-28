//---------------------------------------------------------------------------

#ifndef FeatureH
#define FeatureH
//---------------------------------------------------------------------------
#include <vcl.h>
#include <gbdi/image.h>
#include "Auxiliar.h"
#include "Wavelet.h"

namespace GBDI{
//---------------------------------------------------------------------------

int __fastcall DadosImagemComparisonFunction(void *Item1, void *Item2);

class TDadosImagem{
public:
    char ArquivoNome[200];
    double Distancia;
};

class TFeature{
public :
    __fastcall TFeature(void);
    __fastcall ~TFeature(void);

    TList *lResultados;

    double *VetorCaracteristica;
    double *VetorTemporal;

    int exemplos;

    virtual void CalculaFeature(TWavelet *a, int niveis, int Caracteristica);
    virtual void Media(TWavelet *a, int niveis);
    virtual void Energia(TWavelet *a, int niveis);
    virtual void Entropia(TWavelet *a, int niveis);
    virtual void ArmazenaDados(String Arquivo, FILE *stream2);

    void CarregaFeatures(AnsiString ArquivoFeature, double *VetorBusca);
    double CalculaDistanciaEuclideana(double *VetorCaracteristica, double *VetorTemporal, int FeaturesNumber);
    void DistanciaManju(AnsiString ArquivoFeature, double *VetorBusca);
    double CalculaDistanciaManju(double *VetorBusca, double *VetorTemporal, double *VetorMedias, double *VetorDesvios, int FeaturesNumber);
};
}
#endif


