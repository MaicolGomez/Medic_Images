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
#define BL 256


__global__ void MatrixMultiplication(int *A,int *B,int *C){
	int row = threadIdx.y + blockIdx.y * blockDim.y;
	int col = threadIdx.x + blockIdx.x * blockDim.x;;
	int k = 0;
	for(int i = 0 ; i < N ; i++)
		k += A[ row * N + i ] * B[ i * N + col ];
	C[ row * N + col ] = k;
}

int main(){
	int *a , *b , *c;
	size_t size = N * N * sizeof(int) ;
	a = (int *)malloc( size );
	b = (int *)malloc( size );
	c = (int *)malloc( size );
	
	/*
	a = new int[N * N];
	b = new int[N * N];
	c = new int[N * N];
	*/
	for(int i = 0 ; i < N ; i++)
		for(int j = 0 ; j < N ; j++)
			a[ i * N + j ] = (i==j) , b[ i * N + j ] = (i==j);
			
	int *A , *B , *C;
	
	cudaMalloc( &A , size );
	cudaMalloc( &B , size );
	cudaMalloc( &C , size );

	
	dim3 block( BL , BL );
	dim3 grid( N / block.x , N / block.y );
	
	cout<<"BL: "<<BL<<" other: "<<N / block.y<<endl;
	
	for(int i = 0 ; i < 10 ; i++){
		for(int j = 0 ; j < 10 ; j++)
			cout << a[ i * N + j ] << " ";
			/*int r = 0;
			for(int k = 0 ; k < N ; k++)
				r += a[i][k] * b[k][j];
			
			if( r != c[i][j] ){
				printf("La cagaste\n");
				break;
			}*/
		cout << "\n";
	}	
	
	cudaMemcpy( A , a , size , cudaMemcpyHostToDevice );
	cudaMemcpy( B , b , size , cudaMemcpyHostToDevice );
	
	MatrixMultiplication<<< grid , block >>>( A , B , C );
	
	cudaMemcpy( c , C , size , cudaMemcpyDeviceToHost );
	
	for(int i = 0 ; i < 10 ; i++){
		for(int j = 0 ; j < 10 ; j++)
			cout << c[ i * N + j ] << " ";
			/*int r = 0;
			for(int k = 0 ; k < N ; k++)
				r += a[i][k] * b[k][j];
			
			if( r != c[i][j] ){
				printf("La cagaste\n");
				break;
			}*/
		cout << "\n";
	}	
	
	cudaFree(A);
	cudaFree(B);
	cudaFree(C);
	return 0;
}
