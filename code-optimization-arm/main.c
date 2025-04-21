#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#define DWT_CONTROL     (*((volatile uint32_t *)0xE0001000))
#define DWT_CYCCNT      (*((volatile uint32_t *)0xE0001004))
#define DEMCR           (*((volatile uint32_t *)0xE000EDFC))
#define DEMCR_TRCENA    (1 << 24)
#define DWT_CTRL_CYCCNTENA (1 << 0)
#define N 32768
#define SYSTEM_CORE_CLOCK 168000000U // Typical STM32F4 clock speed

void DWT_Init(void) {
    DEMCR |= DEMCR_TRCENA;      // Enable Trace Unit
    DWT_CYCCNT = 0;             // Reset cycle counter
    DWT_CONTROL |= DWT_CTRL_CYCCNTENA; // Enable cycle counter
}

void bubble_sort(int *data, int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - 1 - i; j++) {
            if (data[j] > data[j + 1]) {
                int temp = data[j];
                data[j] = data[j + 1];
                data[j + 1] = temp;
            }
        }
    }
}

int main(void) {
    int *data = malloc(N * sizeof(int));
    if (!data) {
        printf("Memory allocation failed\n");
        return -1;
    }

    // Initialize array with random data
    for (int i = 0; i < N; i++) {
        data[i] = rand();
    }

    uint32_t start, end, cycles_elapsed;
    float time_ms;

    DWT_Init(); // Initialize DWT

    start = DWT_CYCCNT;       // Record start cycle count
    bubble_sort(data, N);     // Function to measure
    end = DWT_CYCCNT;         // Record end cycle count

    cycles_elapsed = end - start;
    time_ms = (float)cycles_elapsed / (SYSTEM_CORE_CLOCK / 1000.0f); // Convert to ms

    printf("Time taken: %u cycles (~%.3f ms)\n", cycles_elapsed, time_ms);

    free(data);
    return 0;
}