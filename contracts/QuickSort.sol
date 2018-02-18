pragma solidity >=0.4.18;

library QuickSort {
    function sortAndVerifyUnique(uint64[] data) internal pure returns(uint64[]) {
       quickSort(data, int(0), int(data.length - 1));
       checkDupes(data);
       return data;
    }
    
    function quickSort(uint64[] memory arr, int left, int right) internal pure {
        int i = left;
        int j = right;
        if (i==j) {
          return;
        }
        uint pivot = arr[uint(left + (right - left) / 2)];
        while (i <= j) {
            while (arr[uint(i)] < pivot) {
              i++;
            }
            while (pivot < arr[uint(j)]) {
              j--;
            }
            if (i <= j) {
                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
    }

    function checkDupes(uint64[] sortedArr) private pure returns(uint64[]) {
      for (uint i = 1; i < sortedArr.length; i++) {
        require (sortedArr[i] != sortedArr[i-1]);
      }
    }
}