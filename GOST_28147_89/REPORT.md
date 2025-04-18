non original paper link: https://www.researchgate.net/publication/220335508_Security_Evaluation_of_GOST_28147-89_In_View_Of_International_Standardisation

### Calculating the Performance Improvement

To determine the improvement between the original GOST implementation (`gost_main()`) and the optimized GOST implementation (`gost_opt_main()`), we’ll use the execution times provided: the original took **04:49 seconds**, and the optimized took **02:27 seconds**. Let’s break this down step-by-step.

#### Step 1: Convert Times to Seconds
For easier calculations, convert the times from minutes:seconds format to total seconds:
- **Original time (04:49):**  
  \( 4 \times 60 + 49 = 240 + 49 = 289 \) seconds
- **Optimized time (02:27):**  
  \( 2 \times 60 + 27 = 120 + 27 = 147 \) seconds

#### Step 2: Calculate the Time Saved
Subtract the optimized time from the original time to find the absolute improvement:
- **Time saved:**  
  \( 289 - 147 = 142 \) seconds

#### Step 3: Calculate the Percentage Improvement
To express the improvement as a percentage relative to the original time:
- **Percentage improvement:**  
  \( \frac{142}{289} \times 100 \approx 49.13\% \)  
This means the optimized version is approximately 49.13% faster than the original.

#### Step 4: Calculate the Speed-up Factor
The speed-up factor shows how many times faster the optimized version is compared to the original:
- **Speed-up factor:**  
  \( \frac{289}{147} \approx 1.97 \)  
This indicates the optimized implementation runs nearly **twice as fast** as the original.

#### Final Results
- **Original execution time:** 289 seconds (04:49)
- **Optimized execution time:** 147 seconds (02:27)
- **Time saved:** 142 seconds
- **Percentage improvement:** ~49.13%
- **Speed-up factor:** ~1.97x

### Why the Improvement?
The significant performance gain is likely due to optimizations in the GOST 28147-89 algorithm, such as using **precomputed substitution tables**. These tables streamline the substitution step by reducing multiple memory accesses and computations to a single lookup per byte, cutting the processing time nearly in half.

### Trade-off
This optimization comes with a small cost: the precomputed tables require about **1KB of additional memory**. For most systems, this is a negligible trade-off given the substantial speed improvement.

### Conclusion
The optimized GOST implementation (`gost_opt_main()`) reduces the execution time from 04:49 to 02:27, saving 142 seconds. This represents a 49.13% improvement, making it nearly twice as fast as the original (`gost_main()`). This enhancement showcases the power of algorithmic optimization in cryptographic implementations.