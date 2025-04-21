# Code optimization for STM-32 f103/STM-32 F407 Discovery Time and memory

### My stuff

slides: https://www.canva.com/design/DAGYIhh5ce4/nh29Mfb10Jt2mMzgli42kg/view?utm_content=DAGYIhh5ce4&utm_campaign=designshare&utm_medium=link&utm_source=editor

docs: https://docs.google.com/document/d/1c5ZmoUhJryPKpuOPlEtO79nmxWDM9-8CV-M3vkMHEAg/edit?usp=sharing

kindly check `paper` folder for the rest of the stuff.

## Literature review

### Using C

compile `bubble_sort.c` file using; 

```bash
gcc bubble_sort.c -O3 -o bubble_sort
```

execute and time the program;

```bash
time ./bubble_sort
```

> book says:
![execute-time](stuff/execute-time.png)

### Using Assembly

compile `bubble_sort_asm.s` file using; 

```bash
gcc -c bubble_sort_asm.s -o bubble_sort_asm.o 
```

execute and time the program;

```bash
time ./bubble_sort_asm
```

compare the execution time of the two programs;

![execute-time-c-asm](stuff/execute-time-c-asm.png)

> book says:
![execute-time-c-asm-book](stuff/execute-time-c-asm-book.png)

### Result verification

enter `verify` folder and run the following command;
    
```bash
gcc driver.c bubble_sort.c bubble_sort_asm.s -o main
```

## References

- Embedded systems. 2nd edition. ARM Programming and Optimization by Jason D. Bakos. [here](https://books.google.co.uz/books?hl=en&lr=&id=NFLSEAAAQBAJ&oi=fnd&pg=PP1&dq=code+optimization+in+embedded+systems+ARM+Cortex-M+microcontrollers&ots=T3i_rewRb5&sig=8zz_aNTTMfCUmMFtyiUifn3w6i0&redir_esc=y#v=onepage&q&f=false)

