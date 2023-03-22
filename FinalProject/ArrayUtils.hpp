#ifndef _ARRAY_UTILS_
#define _ARRAY_UTILS_

#include <iostream>
#include <exception>
#include <vector>
#include <initializer_list>

using namespace std;

class Array
{
private:
        vector<int> data;

public:
        Array() {}
        Array(initializer_list<int> initList)
        {
                *this = initList;
        }

        void add(size_t index, int value)
        {
                while (data.size() < index)
                {
                        data.push_back(0);
                }
                data.push_back(value);
        }

        // &opeartor[] can increase array size if accessed out of bounds
        int &operator[](size_t index)
        {
                if (index + 1 > data.size())
                {
                        add(index, 0);
                }

                return data[index];
        }

        // operator[] cannot increase array size if accessed out of bounds, only return 0 if so
        int operator[](size_t index) const
        {
                if (index + 1 > data.size())
                {
                        return 0;
                }

                return data[index];
        }

        Array operator+(const Array &right) const
        {
                size_t size1 = data.size();
                size_t size2 = right.data.size();
                size_t len = size1 > size2 ? size1 : size2;

                Array result;
                for (size_t i = 0; i < len; ++i)
                {
                        result[i] = (*this)[i] + right[i];
                }

                return result;
        }

        Array operator-(const Array &right) const
        {
                size_t size1 = data.size();
                size_t size2 = right.data.size();
                size_t len = size1 > size2 ? size1 : size2;

                Array result;
                for (size_t i = 0; i < len; ++i)
                {
                        result[i] = (*this)[i] - right[i];
                }

                return result;
        }

        Array operator*(const Array &right) const
        {
                size_t size1 = data.size();
                size_t size2 = right.data.size();
                size_t len = size1 > size2 ? size1 : size2;

                Array result;
                for (size_t i = 0; i < len; ++i)
                {
                        result[i] = (*this)[i] * right[i];
                }

                return result;
        }

        Array operator/(const Array &right) const
        {
                size_t s1 = data.size(), s2 = right.data.size();
                size_t len = s1 > s2 ? throw runtime_error("divison by zero") : s2;

                Array result;
                for (size_t i = 0; i < len; ++i)
                {
                        result[i] = (*this)[i] / right[i];
                }

                return result;
        }

        Array &operator=(initializer_list<int> initList)
        {
                data.clear();
                for (int value : initList)
                {
                        data.push_back(value);
                }
                return *this;
        }

        Array &operator=(int value)
        {
                data.clear();
                data.push_back(value);
                return *this;
        }

        friend ostream &operator<<(ostream &out, Array arr)
        {
                out << "[";
                if (arr.data.size() > 0)
                {
                        out << arr[0];
                }
                for (size_t i = 1; i < arr.data.size(); ++i)
                {
                        out << ", " << arr[i];
                }
                out << "]";
                return out;
        }

        static int dotProduct(Array arr1, Array arr2)
        {
                size_t s1 = arr1.data.size();
                size_t s2 = arr2.data.size();
                size_t len = s1 > s2 ? s1 : s2;

                int result = 0;
                for (size_t i = 0; i < len; ++i)
                {
                        result += arr1[i] * arr2[i];
                }

                return result;
        }
};

#endif
