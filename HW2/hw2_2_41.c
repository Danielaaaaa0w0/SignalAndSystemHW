#include <stdio.h>

#define X_LEN 4
#define Y_LEN 7

void deconvolution(int x[], int y[], int h[], int x_len, int y_len)
{
    for (int n = 0; n < y_len; n++)
    {
        h[n] = y[n]; // 初始化 h[n] 為 y[n]
        for (int k = 1; k < x_len && (n - k) >= 0; k++)
        {
            h[n] -= x[k] * h[n - k]; // 反向計算 h[n]
        }
        h[n] /= x[0]; // 反向解出 h[n]
    }
}

int main()
{
    int x[X_LEN] = {1, -1, 2, 4};          // 輸入信號 x[n]
    int y[Y_LEN] = {2, 6, 4, 0, 8, 5, 12}; // 輸出信號 y[n]
    int h[Y_LEN] = {0};                    // h[n] 初始化為 0

    deconvolution(x, y, h, X_LEN, Y_LEN);

    printf("h[n] = ");
    for (int i = 0; i < 4; i++)
    {
        printf("%d ", h[i]);
    }
    printf("\n");

    return 0;
}
