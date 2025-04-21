#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 32768

void bubble_sort(int *data, int n);
int bubble_sort_asm(int *data, int n);

int main() {
    int *data1, *data2;
    clock_t start, end;
    double c_time, asm_time;

    data1 = (int *)malloc(N * sizeof(int));
    data2 = (int *)malloc(N * sizeof(int));

    if (!data1 || !data2) {
        fprintf(stderr, "Memory allocation failed\n");
        return 1;
    }

    srand(11);

    for (int i = 0; i < N; i++) data1[i] = data2[i] = rand();

    // Measure C version performance
    start = clock();
    bubble_sort(data1, N);
    end = clock();
    c_time = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("C bubble sort time: %f seconds\n", c_time);

    // Measure ASM version performance
    start = clock();
    bubble_sort_asm(data2, N);
    end = clock();
    asm_time = ((double) (end - start)) / CLOCKS_PER_SEC;
    printf("Assembly bubble sort time: %f seconds\n", asm_time);
    printf("Performance improvement: %f%%\n", (c_time - asm_time) / c_time * 100);

    // Verify correctness
    for (int i = 0; i < N; i++) {
        if (data1[i] != data2[i]) {
            fprintf(stderr, "Mismatch at index %d: %d != %d\n", i, data1[i], data2[i]);
            free(data1);
            free(data2);
            return 1;
        }
    }
    
    printf("Verification successful: both implementations produce identical results\n");
    free(data1);
    free(data2);
    return 0;
}