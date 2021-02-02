// Algorithm 3 from P. Maponi,
// p. 283, doi:10.1016/j.laa.2006.07.007

#include <iostream>
#include <string>
#include <cmath>
#include <cstdlib>
#include <ctime>
using namespace std;

uint getMaxIndex(double *arr, uint size);
template<typename T>void showScalar(T scalar, string name);
template<typename T>void showVector(T *vector, uint size, string name);
template<typename T>void showMatrix(T **matrix, uint size, string name);
template<typename T>void showMatrixT(T **matrix, uint size, string name);
template<typename T>T **matMul(T **A, T **B, uint size);
template<typename T1, typename T2>T1 **outProd(T1 *vec1, T2 *vec2, uint size);
template<typename T>T matDet(T **A, int M);
void Sherman_Morrison(int **Slater0, double **Slater_inv, uint *Dim, uint *N_updates, int **Updates, uint *Updates_index);

int main() {

    srand((unsigned) time(0));
    uint randRange = 1; // to get random integers in range [-randRange, randRange]
    uint M = 3; // Dimension of the Slater-matrix
    uint i, j; // Indices for iterators

    // Declare and allocate all vectors and matrices
    uint *indices_of_updates = new uint[M];
    int **A = new int*[M]; // The matrix to be inverted
    int **A0 = new int*[M]; // A diagonal matrix with the digonal elements of A
    int **Ar = new int*[M]; // The update matrix
    double **A0inv = new double*[M]; // Inverse of A0
    for (i = 0; i < M; i++) { 
        A[i] = new int[M];
        A0[i] = new int[M];
        Ar[i] = new int[M];
        A0inv[i] = new double[M];
    }

    // Initialize all matrices with zeros
    for (i = 0; i < M; i++) {
        for (j = 0; j < M; j++) {
            A0[i][j] = 0;
            Ar[i][j] = 0;
            A0inv[i][j] = 0;
        }
    }

    // Initialize A with M=3 and Eq. (17) from paper
    A[0][0] = 1;    A[0][1] = 1;    A[0][2] = -1;
    A[1][0] = 1;    A[1][1] = 1;    A[1][2] = 0;
    A[2][0] = -1;   A[2][1] = 0;    A[2][2] = -1;

    // // Fill A with random numbers from [-randRange,randRange] 
    // // and check if A and A0 are invertable
    // do {
    //     for (i = 0; i < M; i++) {
    //         for (j = 0; j < M; j++) {
    //             A[i][j] = rand()%(2*randRange+1)-randRange;
    //         }
    //     }
    //     for (i = 0; i < M; i++) {
    //         A0[i][i] = A[i][i];
    //     }
    // } while (matDet(A, M) == 0 || matDet(A0, M) == 0);
 
    showMatrix(A, M, "A");

    // Init Ar: the update matrix
    for (i = 0; i < M; i++) {
        for (j = 0; j < M; j++) {
            Ar[i][j] = A[i][j] - A0[i][j];
        }
    }

    // Define A0inv
    for (i = 0; i < M; i++) {
        A0inv[i][i] = 1.0/A[i][i];
    }
    showMatrix(A0inv, M, "A0inv");

    // Populate indices_of_updates
    for (i = 0; i < M; i++) {
        indices_of_updates[i] = i;
    }

    uint *dim = new uint(M);
    Sherman_Morrison(A0, A0inv, dim, dim, Ar, indices_of_updates);
    
    showMatrixT(A0inv, M, "A0inv");
    
    // Deallocate all vectors and matrices 
    for (i = 0; i < M; i++) {
        delete [] A[i];
        delete [] A0[i];
        delete [] A0inv[i];
        delete [] Ar[i];
    }

    delete [] A, A0, A0inv, Ar;

    return 0;
}

uint getMaxIndex(double *arr, uint size) {
    uint i;     
    uint max = arr[0]; 
    uint maxi = 0;
    for (i = 1; i < size; i++) {
        if (arr[i] > max) {
            max = arr[i];
            maxi = i;
        }
    }
    return maxi; 
}

template<typename T>
void showScalar(T scalar, string name) {
    cout << name << " = " << scalar << endl << endl;
}

template<typename T>
void showVector(T* vector, uint size, string name) {
    cout << name << " = " << endl;
    for (uint i = 0; i < size; i++) {
        cout << "[ " << vector[i] << " ]" << endl;
    }
    cout << endl;
}

template<typename T>
void showMatrix(T** matrix, uint size, string name) {
    cout << name << " = " << endl;
    for (uint i = 0; i < size; i++) {
        cout << "[ ";
        for (uint j = 0; j < size; j++) {
            cout << matrix[i][j] << " ";
        }
        cout << " ]" << endl;
    }
    cout << endl;
}

template<typename T>
void showMatrixT(T** matrix, uint size, string name) {
    cout << name << " = " << endl;
    for (uint i = 0; i < size; i++) {
        cout << "[ ";
        for (uint j = 0; j < size; j++) {
            cout << matrix[j][i] << " ";
        }
        cout << " ]" << endl;
    }
    cout << endl;
}

template<typename T>
T** matMul(T** A, T** B, uint size) {
    T** C = new T*[size];
    for (uint i = 0; i < size; i++) {
        C[i] = new T[size];
    }
    for (uint i = 0; i < size; i++) {
        for (uint j = 0; j < size; j++) {
            for (uint k = 0; k < size; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
    return C;
}

template<typename T1, typename T2>
T1** outProd(T1* vec1, T2* vec2, uint size) {
    T1** C = new T1*[size];
    for (uint i = 0; i < size; i++) {
        C[i] = new T1[size];
    }
    for (uint i = 0; i < size; i++) {
        for (uint j = 0; j < size; j++) {
            C[i][j] = vec1[i+1] * vec2[j];
        }
    }
    return C;
}

template<typename T>
T matDet(T** A, int M) {
    int det = 0, p, h, k, i, j;
    T** temp = new T*[M];
    for (int i = 0; i < M; i++) temp[i] = new T[M];
    if(M == 1) {
        return A[0][0];
    }
    else if(M == 2) {
        det = (A[0][0] * A[1][1] - A[0][1] * A[1][0]);
        return det;
    }
    else {
        for(p = 0; p < M; p++) {
            h = 0;
            k = 0;
            for(i = 1; i < M; i++) {
                for( j = 0; j < M; j++) {
                    if(j == p) {
                        continue;
                    }
                    temp[h][k] = A[i][j];
                    k++;
                    if(k == M-1) {
                        h++;
                        k = 0;
                    }
                }
            }
            det = det + A[0][p] * pow(-1, p) * matDet(temp, M-1);
        }
        return det;
    }
    delete [] temp;
}

void Sherman_Morrison(int **Slater0, double **Slater_inv, uint *Dim, uint *N_updates, int **Updates, uint *Updates_index) {
    cout << "We just entered Sherman-Morrison" << endl;
    showMatrix(Slater_inv, *Dim, "Slater_inv");
    uint k, l, lbar, i, j, tmp, M = *Dim;
    uint *p = new uint[M+1];
    double *breakdown = new double[M+1];
    double alpha, beta;

    for (i = 0; i < M+1; i++) {
        p[i] = i;
    }

    int **Id = new int*[M];
    for (i = 0; i < M; i++) Id[i] = new int[M];
    for (i = 0; i < M; i++) {
        for (j = 0; j < M; j++) {
            if (i != j) Id[i][j] = 0;
            else Id[i][j] = 1;
        }
    }

    // Declare auxiliary solution matrix ylk
    double ***ylk = new double**[M];
    for (l = 0; l < M; l++) {
        ylk[l] = new double*[M+1];
        for (k = 0; k < M+1; k++) {
            ylk[l][k] = new double[M+1];
        }
    }
    // Initialize ylk with zeros
    for (l = 0; l < M; l++) {
        for (k = 0; k < M+1; k++) {
            for (i = 0; i < M+1; i++) {
                ylk[l][k][i] = 0;
            }
        }
    }

    // Calculate all the y0k in M^2 multiplications instead of M^3
    for (k = 1; k < M+1; k++) {
        for (i = 1; i < M+1; i++) {
            ylk[0][k][i] = Slater_inv[i-1][i-1] * Updates[i-1][k-1];
        }
    }

    // Calculate all the ylk from the y0k
    for (l = 1; l < M; l++) {
        for (j = l; j < M+1; j++) {
            breakdown[j] = abs( 1 + ylk[l-1][p[j]][p[j]] );
        }
        lbar = getMaxIndex(breakdown, M+1);
        for (i = 0; i < M; i++) {
            breakdown[i] = 0;
        }
        tmp = p[l];
        p[l] = p[lbar];
        p[lbar] = tmp;
        for (k = l+1; k < M+1; k++) {
            beta = 1 + ylk[l-1][p[l]][p[l]];
            if (beta == 0) {
                cout << "Break-down condition occured. Exiting..." << endl;
                exit;
            }
            for (i = 1; i < M+1; i++) {
                alpha = ylk[l-1][p[k]][p[l]] / beta;
                ylk[l][p[k]][i] = ylk[l-1][p[k]][i] - alpha * ylk[l-1][p[l]][i];
            }
        }
    }

    cout << "Just before the final construction of the inverse..." << endl;
    showMatrix(Slater_inv, M, "Slater_inv");

    // Construct A-inverse from A0-inverse and the ylk
    double** U;
    double** Al = new double*[M];
    for (i = 0; i < M; i++) Al[i] = new double[M];
    for (l = 0; l < M; l++) {
        k = l+1;
        U = outProd(ylk[l][p[k]], Id[p[k]-1], M);
        beta = 1 + ylk[l][p[k]][p[k]];
        for (i = 0; i < M; i++) {
            for (j = 0; j < M; j++) {
                Al[i][j] = Id[i][j] - U[i][j] / beta;
            }
        }
        Slater_inv = matMul(Al, Slater_inv, M);
    }
    cout << "Just after the final construction of the inverse..." << endl;
    showMatrix(Slater_inv, M, "Slater_inv");

    for (i = 0; i < M; i++) {
        delete [] U[i];
        delete [] Al[i];
    }

    for (l = 0; l < M; l++) {
        for (k = 0; k < M+1; k++) {
            delete [] ylk[l][k];
        }
        delete [] ylk[l];
    }
}