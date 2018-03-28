#include<bits/stdc++.h>
using namespace std;

__global__ void add(int * dev_a[], int * dev_b[], int * dev_c[])
{
	dev_c[threadIdx.x][blockIdx.x]=dev_a[threadIdx.x][blockIdx.x]+dev_b[threadIdx.x][blockIdx.x];
     
}

__global__ void add2(int * dev_a, int * dev_b, int * dev_c)
{
	dev_c[threadIdx.x + blockDim.x * blockIdx.x]=dev_a[threadIdx.x + blockDim.x * blockIdx.x]+dev_b[threadIdx.x + blockDim.x * blockIdx.x];
     
}

inline void GPUassert(cudaError_t code, char * file, int line, bool Abort=true)
{
    if (code != 0) {
        fprintf(stderr, "GPUassert: %s %s %d\n", cudaGetErrorString(code),file,line);
        if (Abort) exit(code);
    }       
}

#define GPUerrchk(ans) { GPUassert((ans), __FILE__, __LINE__); }

#define N 60

int aa[N][N];
int bb[N][N];
int cc[N][N];

int main(void)
{
    
    for(int i = 0; i < N; i++)
    	for(int j = 0; j < N; j++) aa[i][j] = 1, bb[i][j] = 2;
   
    
    int ts1 = clock();

    int ** h_a = (int **)malloc(N * sizeof(int *));
    for(int i=0; i<N;i++){
        GPUerrchk(cudaMalloc((void**)&h_a[i], N*sizeof(int)));
        GPUerrchk(cudaMemcpy(h_a[i], &aa[i][0], N*sizeof(int), cudaMemcpyHostToDevice));
    }

    int **d_a;
    GPUerrchk(cudaMalloc((void ***)&d_a, N * sizeof(int *)));
    GPUerrchk(cudaMemcpy(d_a, h_a, N*sizeof(int *), cudaMemcpyHostToDevice));

    int ** h_b = (int **)malloc(N * sizeof(int *));
    for(int i=0; i<N;i++){
        GPUerrchk(cudaMalloc((void**)&h_b[i], N*sizeof(int)));
        GPUerrchk(cudaMemcpy(h_b[i], &bb[i][0], N*sizeof(int), cudaMemcpyHostToDevice));
    }

    int ** d_b;
    GPUerrchk(cudaMalloc((void ***)&d_b, N * sizeof(int *)));
    GPUerrchk(cudaMemcpy(d_b, h_b, N*sizeof(int *), cudaMemcpyHostToDevice));

    int ** h_c = (int **)malloc(N * sizeof(int *));
    for(int i=0; i<N;i++){
        GPUerrchk(cudaMalloc((void**)&h_c[i], N*sizeof(int)));
    }

    int ** d_c;
    GPUerrchk(cudaMalloc((void ***)&d_c, N * sizeof(int *)));
    GPUerrchk(cudaMemcpy(d_c, h_c, N*sizeof(int *), cudaMemcpyHostToDevice));

	
    add<<<N,N>>>(d_a,d_b,d_c);
    int tf1 = clock();
    
    printf("time1: %.5lf\n", (tf1-ts1)/double(CLOCKS_PER_SEC)*1000);
    
    GPUerrchk(cudaPeekAtLastError());

    for(int i=0; i<N;i++){
        GPUerrchk(cudaMemcpy(&cc[i][0], h_c[i], N*sizeof(int), cudaMemcpyDeviceToHost));
    }

    /*for(int i=0;i<N;i++) {
        for(int j=0;j<N;j++) {
            printf("(%d,%d):%d\n",i,j,cc[i][j]);
        }
    }*/
    
    int ts2 = clock();
    
    int *dev_a, *dev_b, *dev_c;
    
    cudaMalloc((void **) &dev_a, N * N * sizeof(int));
    cudaMalloc((void **) &dev_b, N * N * sizeof(int));
    cudaMalloc((void **) &dev_c, N * N * sizeof(int));
    
    int *a = new int[N], *b = new int[N], *c = new int[N];
    
    for(int i = 0; i < N; i++)
    	for(int j = 0; j < N; j++) a[i * N + j] = aa[i][j], b[i * N + j] = bb[i][j];
    
    cudaMemcpy(dev_a, a, N * N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(dev_b, b, N * N * sizeof(int), cudaMemcpyHostToDevice);
    
	
    add2<<<N,N>>>(dev_a,dev_b,dev_c);
    int tf2 = clock();
    
    printf("time2: %.5lf\n", (tf2-ts2)/double(CLOCKS_PER_SEC)*1000);
        
    GPUerrchk(cudaMemcpy(c, dev_c, N*N*sizeof(int), cudaMemcpyDeviceToHost));

    /*for(int i=0;i<N;i++) {
        for(int j=0;j<N;j++) {
            printf("(%d,%d):%d\n",i,j,c[i * N + j]);
        }
    }*/

    return cudaThreadExit();
}
