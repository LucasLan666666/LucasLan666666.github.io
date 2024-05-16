# 字体测试

## 标题

正常字

## **标题（粗）**

1 **粗体字**

## *标题（斜）*

2 *斜体字*

## 代码块

```C
#include <stdio.h>
#include <stdlib.h>

void printHouxu(char n[], int L[], int R[], int i);
int main() {
    int numV;
    scanf("%d", &numV);
    int L[numV], R[numV];
    char n[numV];
    for (int i = 0; i < numV; i++) {
        L[i] = 0;
        R[i] = 0;
    }
    struct element{
        char data;
        int pos[2];
    }elem[numV];

    for (int i = 0; i < numV; i++){
        elem[i].data = '0';
        elem[i].pos[0] = 0;
        elem[i].pos[1] = 0;
    }
    for (int i = 0; i < (numV - 1) / 2; i++) {
        scanf(" %c %d %d", &elem[i].data, &elem[i].pos[0], &elem[i].pos[1]);
        n[i] = elem[i].data;
        L[i] = elem[i].pos[1];
        R[i] = elem[i].pos[0];
    }
    for (int i = (numV - 1) / 2; i < numV; i++) {
        scanf(" %c", &elem[i].data);
        n[i] = elem[i].data;
    }
    printHouxu(n, L, R, 0);
    return 0;
}

void printHouxu(char n[], int L[], int R[], int i) {
    if (i >= 0 && n[i] != '0') {
        if (L[i] != 0) {
            printHouxu(n, L, R, L[i]);
        }
        if (R[i] != 0) {
            printHouxu(n, L, R, R[i]);
        }
        printf("%c", n[i]);
    }
}
```
