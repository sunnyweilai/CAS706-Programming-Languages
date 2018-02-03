function quickSort(array) {
    array = array.slice();
    partition(array, 0, array.length);
    return array;
}
function partition(array, start, end) {
    var length = end - start;
    if (length <= 1)
        return;
    var pivotIndex = start + Math.floor(Math.random() * length);
    _a = [array[end - 1], array[pivotIndex]], array[pivotIndex] = _a[0], array[end - 1] = _a[1];
    var pivot = array[end - 1];
    var pivotRank = start;
    for (var index = start; index < end - 1; index++) {
        if (array[index] < pivot) {
            _b = [array[pivotRank], array[index]], array[index] = _b[0], array[pivotRank] = _b[1];
            pivotRank++;
        }
    }
    if (pivotRank !== end - 1) {
        _c = [array[end - 1], array[pivotRank]], array[pivotRank] = _c[0], array[end - 1] = _c[1];
    }
    partition(array, start, pivotRank);
    partition(array, pivotRank + 1, end);
    var _a, _b, _c;
}
var unsortedArray = [10, 0, 1, 3, 9, 4, 2, 5, 2, 5, 6];
console.log(quickSort(unsortedArray));
