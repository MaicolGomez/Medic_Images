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
#define N 64
#define TB 32

float A[N][N];
float B[N][N];
float C[N][N];

__global__ void MatAdd(float A[N][N], float B[N][N], float C[N][N])
{
int i = blockIdx.x * blockDim.x + threadIdx.x;
int j = blockIdx.y * blockDim.y + threadIdx.y;
if (i < N && j < N)
C[i][j] = A[i][j] + B[i][j];
}

int main(){

	float (*d_A)[N]; //pointers to arrays of dimension N
	float (*d_B)[N];
	float (*d_C)[N];

	for(int i = 0; i < N; i++) {
		for(int j = 0; j < N; j++) {
		    A[i][j] = i;
		    B[i][j] = j;
		}
	}       

	//allocation
	cudaMalloc((void**)&d_A, (N*N)*sizeof(float));
	cudaMalloc((void**)&d_B, (N*N)*sizeof(float));
	cudaMalloc((void**)&d_C, (N*N)*sizeof(float));

	//copying from host to device
	cudaMemcpy(d_A, A, (N*N)*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_B, B, (N*N)*sizeof(float), cudaMemcpyHostToDevice);
	cudaMemcpy(d_C, C, (N*N)*sizeof(float), cudaMemcpyHostToDevice);

	// Kernel invocation
	dim3 threadsPerBlock(16, 16);
	dim3 numBlocks(N / threadsPerBlock.x, N / threadsPerBlock.y);
	MatAdd<<<numBlocks, threadsPerBlock>>>(d_A, d_B, d_C);

	//copying from device to host
	cudaMemcpy(A, (d_A), (N*N)*sizeof(float), cudaMemcpyDeviceToHost);
	cudaMemcpy(B, (d_B), (N*N)*sizeof(float), cudaMemcpyDeviceToHost);
	cudaMemcpy(C, (d_C), (N*N)*sizeof(float), cudaMemcpyDeviceToHost);

	for(int i = 0; i < N; i++){
		for(int j = 0; j < N; j++)
			printf("%lf ", C[i][j]);
		
		printf("\n");
	}
	return 0;
}
