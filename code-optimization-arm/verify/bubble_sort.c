void bubble_sort (int* data, int n) {
    for (int i=0;i<(n-1);i++) {
        for (int j=0;j<(n-1);j++) {
            if (data[j]>data[j+1]) {
                int temp=data[j];
                data[j]=data[j+1];
                data[j+1]=temp;
            }
        }
    }
}
