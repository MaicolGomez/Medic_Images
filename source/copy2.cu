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

typedef struct CudaMatrixStruct {
	double *data;
	int height, width;
} CudaMatrix;

__global__ void CudaPrintMatrix(CudaMatrix *A){
	
	printf("Elementos de CudaMatrix:\n");
	for(int i = 0; i < A->height * A->width ; i++)
		printf("%d: %.3lf\n", i, A->data[i]);
	
	
	printf("CudaMatrix->height: %d  CudaMatrix->width: %d\n", A->height, A->width);
}

void CudaCreateMatrix(CudaMatrix *&AA,int hei,int wid){	
	

	
	double *d;// = new double[hei*wid];
	d = (double *)malloc( hei * wid * sizeof(double) );
	for(int i = 0 ; i < hei * wid ; i++)
		d[i] = i + 1.0;
	
	double *data;
	cudaMalloc( (void **) &data, sizeof(double) * hei * wid );
	cudaMemcpy( data , d , sizeof(double) * hei * wid , cudaMemcpyHostToDevice );
	
	CudaMatrix *A = new CudaMatrix();
	A->width = wid;
	A->height = hei;
	cudaMalloc((void **)&AA, sizeof(CudaMatrix));
	
	cudaMemcpy(AA, A, sizeof(CudaMatrix), cudaMemcpyHostToDevice);
	cudaMemcpy(&(AA->data), &data, sizeof(double *), cudaMemcpyHostToDevice);
	
	
	CudaPrintMatrix<<<1, 1>>>(AA);
	
	//cudaFree(AA);
	//cudaFree(data);
}

int main() {
	CudaMatrix *devGr;
	int side = 1;
	CudaCreateMatrix( devGr , 2 * side + 1 , 2 * side + 1 );
	
	//CudaPrintMatrix<<<1,1>>>(devGr);//IMPRIME LA MATRICES CREADA
	
	cudaFree(devGr);
}
