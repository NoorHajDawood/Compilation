#ifndef _ANOTHER_H_
#define _ANOTHER_H_

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

typedef struct _Array
{
    int size;
    int *data;
} * Array;

Array createArray(int n, ...)
{
    Array array = malloc(sizeof(struct _Array));
    assert (!array);

    va_list args;
    va_start(args, n);

    array->size = n;
    if(n == 0)
    {
        array->data = NULL;
        return array;
    }
    array->data = calloc(n, sizeof(int));

    for (int i = 0; i < n; ++i)
        array->data[i] = va_arg(args, int);

    return array;
}
int arr_index(Array array, int index)
{
    if (array && array->size > 0 && array->size > index)
    {
        return array->data[index];
    }
    return 0;
}
int arr_shtrodel(Array arr1, Array arr2)
{
    int size1 = 0, size2 = 0;
    if (arr1 && arr2)
    {
        size1 = arr1->size;
        size2 = arr2->size;
    }

    int result = 0, i;
    for (i = 0; i < size1 && i < size2; ++i)
    {
        result += arr1->data[i] * arr2->data[i];
    }

    return result;
}
Array arr_plus(Array arr1, Array arr2)
{
    int size1 = 0, size2 = 0;
    if (arr1 && arr2)
    {
        size1 = arr1->size;
        size2 = arr2->size;
    }

    Array result = malloc(sizeof(Array));
    if (!result)
        return NULL;

    result->size = size1 > size2 ? size1 : size2;
    result->data = calloc(result->size, sizeof(int));
    if (!result->data)
    {
        free(result);
        return NULL;
    }

    int i;
    for (i = 0; i < size1 && i < size2; ++i)
    {
        result->data[i] = arr1->data[i] + arr2->data[i];
    }
    for (; i < size1; ++i)
    {
        result->data[i] = arr1->data[i];
    }
    for (; i < size2; ++i)
    {
        result->data[i] = arr2->data[i];
    }

    return result;
}
Array arr_minus(Array arr1, Array arr2)
{
    int size1 = 0, size2 = 0;
    if (arr1 && arr2)
    {
        size1 = arr1->size;
        size2 = arr2->size;
    }

    Array result = malloc(sizeof(Array));
    if (!result)
        return NULL;

    result->size = size1 > size2 ? size1 : size2;
    result->data = calloc(result->size, sizeof(int));
    if (!result->data)
    {
        free(result);
        return NULL;
    }

    int i;
    for (i = 0; i < size1 && i < size2; ++i)
    {
        result->data[i] = arr1->data[i] - arr2->data[i];
    }
    for (; i < size1; ++i)
    {
        result->data[i] = arr1->data[i];
    }
    for (; i < size2; ++i)
    {
        result->data[i] = -arr2->data[i];
    }

    return result;
}
Array arr_multiply(Array arr1, Array arr2)
{
    int size1 = 0, size2 = 0;
    if (arr1 && arr2)
    {
        size1 = arr1->size;
        size2 = arr2->size;
    }

    Array result = malloc(sizeof(Array));
    if (!result)
        return NULL;

    result->size = size1 > size2 ? size1 : size2;
    result->data = calloc(result->size, sizeof(int));
    if (!result->data)
    {
        free(result);
        return NULL;
    }

    int i;
    for (i = 0; i < size1 && i < size2; ++i)
    {
        result->data[i] = arr1->data[i] * arr2->data[i];
    }

    return result;
}
Array arr_divide(Array arr1, Array arr2)
{
    int size1 = 0, size2 = 0;
    if (arr1 && arr2)
    {
        size1 = arr1->size;
        size2 = arr2->size;
    }

    Array result = malloc(sizeof(Array));
    if (!result)
        return NULL;

    result->size = size1 > size2 ? size1 : size2;
    result->data = calloc(result->size, sizeof(int));
    if (!result->data)
    {
        free(result);
        return NULL;
    }

    int i;
    for (i = 0; i < size1 && i < size2; ++i)
    {
        result->data[i] = arr1->data[i] / arr2->data[i];
    }

    return result;
}

#endif
