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


typedef struct StructA {
    int *a;
} CudaMatrix;

#define N 10

__global__ void kernel(CudaMatrix *A){
	int x = threadIdx.x;
	printf("--> %d\n",x);
	for(int i = 0 ; i < 10 ; i++)
		printf("%d - ",A->a[i]);
	printf("\n");
}

int main() {
	
    CudaMatrix *A;
    int *a;
    a = (int *)malloc( N * sizeof(int) );
    for(int i = 0 ; i < N ; i++)
    	a[i] = i;
    
    int *a2;
    cudaMalloc( &a2 , N * sizeof(int) );
    cudaMemcpy( a2 , a , N * sizeof(int) , cudaMemcpyHostToDevice );
    
    int sz = sizeof(CudaMatrix);
	cudaMalloc( &A , sz );
	
	cudaMemcpy( &(A->a) , &a2 , sizeof(int *) , cudaMemcpyHostToDevice );
	kernel<<<1,1>>>( A );
	
	
	cudaFree( A );
}
