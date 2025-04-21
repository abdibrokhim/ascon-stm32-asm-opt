#include <stdio.h>
#include <stdlib.h>

#define N 32768

int bubble_sort(int *data, int n);
int bubble_sort_asm(int *data, int n);

int main() {
    int *data1, *data2;

    data1 = (int *)malloc(N * sizeof(int));
    data2 = (int *)malloc(N * sizeof(int));

    srand(11);

    for (int i = 0; i < N; i++) data1[i] = data2[i] = rand();

    bubble_sort(data1, N);
    bubble_sort_asm(data2, N);

    for (int i = 0; i < N; i++) {
        if (data1[i] != data2[i]) {
            fprintf(stderr, "Mismatch at index %d: %d != %d\n", i, data1[i], data2[i]);
            return 0;
        }
    }
    return 1;
}