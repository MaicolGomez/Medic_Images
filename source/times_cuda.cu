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
#define N 1024
#define TB 32

/*__global__ void suma(int *A, int *S){
	
	S[0] = S[0] + A[threadIdx.x];
	printf("A[t]: %d S[0]: %d\n",A[threadIdx.x], S[0]);
	
	__syncthreads();
}*/

__global__ void MatrixMultiplication(int *A,int *B,int *C){
	int row = threadIdx.y + blockIdx.y * blockDim.y;
	int col = threadIdx.x + blockIdx.x * blockDim.x;
	
	C[ row * N + col ] = A[ row * N + col ] * B[ row * N + col ];
}

int main(){

	clock_t tStart = clock();

	int *a , *b , *c;
	size_t size = N * N * sizeof(int) ;
	a = (int *)malloc( size );
	b = (int *)malloc( size );
	c = (int *)malloc( size );
	
	for(int i = 0; i < N; i++)
		for(int j = 0; j < N; j++)
			a[i * N + j] = i + j;
			

	for(int i = 0; i < N; i++)
		for(int j = 0; j < N; j++)
			b[i * N + j] = 1;
	
	int *A , *B , *C;
	
	cudaMalloc( &A , size );
	cudaMalloc( &B , size );
	cudaMalloc( &C , size );
	
	dim3 threadsxblock( TB , TB );
	dim3 blocksxgrid( N / threadsxblock.x , N / threadsxblock.x );
	
	cudaMemcpy( A , a , size , cudaMemcpyHostToDevice );
	cudaMemcpy( B , b , size , cudaMemcpyHostToDevice );
	
	MatrixMultiplication<<< blocksxgrid , threadsxblock >>>( A , B , C );
	
	cudaMemcpy( c , C , size , cudaMemcpyDeviceToHost );
	
	cudaFree(A);
	cudaFree(B);
	cudaFree(C);
	
	printf("Time taken: %.2fms\n", 1000.0 * (double)(clock() - tStart)/CLOCKS_PER_SEC);
	
	return 0;
	
}
