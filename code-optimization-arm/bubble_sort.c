#define N 32768

int data[N];

int main () {
    for (int i=0;i<(N-1);i++) {
        for (int j=0;j<(N-1);j++) {
            if (data[j]>data[j+1]) {
                int temp=data[j];
                data[j]=data[j+1];
                data[j+1]=temp;
            }
        }
        return 1;
    }
}
