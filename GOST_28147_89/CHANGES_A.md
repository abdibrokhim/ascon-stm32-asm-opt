
The error you're seeing is because the `_lrotl` function (a Windows-specific rotate left function) isn't available in your embedded development environment. The issue is in the "gosttt.cpp" file, which appears to be another version of the GOST implementation.

Let's fix this by implementing our own version of the rotate left function.

Here's how to fix the error:

1. Open the "gosttt.cpp" file in your editor.

2. At the top of the file, after your other includes, add a custom implementation of the rotate left function:
```cpp
// Add a custom rotate left implementation to replace _lrotl
static inline uint32_t custom_lrotl(uint32_t value, int shift) {
    return (value << shift) | (value >> (32 - shift));
}
```

3. Then find line 72 where the error is occurring, and replace `_lrotl` with your new function:
```cpp
// Replace this line:
S.full = (*DATA).half[_GOST_Data_Part_N2_Half]^_lrotl(S.full,11);

// With this:
S.full = (*DATA).half[_GOST_Data_Part_N2_Half]^custom_lrotl(S.full,11);
```

This will implement the rotate left function in a platform-independent way. The function works by:
1. Shifting the bits left by the specified amount (`value << shift`)
2. Shifting the bits that would be lost off the right end back to the right side (`value >> (32 - shift)`)
3. Combining the two with OR (`|`) to create the rotated result

Your code should now compile without the "_lrotl was not declared" error.
