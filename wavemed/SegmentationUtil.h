//---------------------------------------------------------------------------
#ifndef SegmentationUtilH
#define SegmentationUtilH
//---------------------------------------------------------------------------
/**
* Esta classe representa um retângulo definido por dois pontos.
*/
class TSelection{
   public:
      TSelection(){
         Reset();
      }//end TSelection

      void SetPoint1(int x, int y);
      void SetPoint2(int x, int y);
      void SetX1(int x);
      void SetX2(int x);
      void SetY1(int y);
      void SetY2(int y);
      int GetTop();
      int GetLeft();
      int GetWidth();
      int GetHeight();

      int GetX1(){
         return x1;
      }//end GetX1

      int GetX2(){
         return x2;
      }//end GetX2

      int GetY1(){
         return y1;
      }//end GetY1

      int GetY2(){
         return y2;
      }//end GetY2

      void SetBounds(int minx, int miny, int maxx, int maxy){

         this->minx = minx;
         this->miny = miny;
         this->maxx = maxx;
         this->maxy = maxy;         
      }//end SetBounds

      void Reset();
   private:
      int x1;
      int x2;
      int y1;
      int y2;
      int maxx;
      int maxy;
      int minx;
      int miny;
};//end TSelection


#endif
