// Optimized bubble sort with C‑level optimizations
// Recommended compile flags:
// gcc -O3 -march=native -funroll-loops -flto -o bubble_sort_optimized bubble_sort_optimized.c

#include <stdbool.h>

void bubble_sort_optimized(int * restrict data, int n) {
    bool swapped;
    for (int i = 0; i < n - 1; ++i) {
        swapped = false;
        int limit = n - i - 1;
        int j = 0;

        // Unroll inner loop by 4 iterations to reduce loop overhead
        for (; j + 4 <= limit; j += 4) {
            if (data[j] > data[j + 1]) {
                int tmp = data[j]; data[j] = data[j + 1]; data[j + 1] = tmp; swapped = true;
            }
            if (data[j + 1] > data[j + 2]) {
                int tmp = data[j + 1]; data[j + 1] = data[j + 2]; data[j + 2] = tmp; swapped = true;
            }
            if (data[j + 2] > data[j + 3]) {
                int tmp = data[j + 2]; data[j + 2] = data[j + 3]; data[j + 3] = tmp; swapped = true;
            }
            if (data[j + 3] > data[j + 4]) {
                int tmp = data[j + 3]; data[j + 3] = data[j + 4]; data[j + 4] = tmp; swapped = true;
            }
        }
        // Handle remaining elements
        for (; j < limit; ++j) {
            if (data[j] > data[j + 1]) {
                int tmp = data[j]; data[j] = data[j + 1]; data[j + 1] = tmp; swapped = true;
            }
        }

        // Early exit if already sorted
        if (!swapped) {
            break;
        }
    }
}
