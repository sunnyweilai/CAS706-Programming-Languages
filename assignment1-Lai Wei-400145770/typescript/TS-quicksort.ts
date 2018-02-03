
function quickSort(array: number[]): number[]{
	array = array.slice();
	partition(array , 0, array.length);
	return array;
}

function partition(array:number[],start:number,end:number): void{
	const length = end - start;

if (length <= 1)return;

const pivotIndex = start + Math.floor(Math.random() * length);

[array[pivotIndex], array[end-1]]=[array[end-1],array[pivotIndex]];

const pivot=array[end-1];
let pivotRank = start;

for (let index = start;index<end-1;index++){
	
	if(array[index]<pivot){
	[array[index],array[pivotRank]]=[array[pivotRank],array[index]];
    pivotRank ++;
	}
}

 if (pivotRank !== end-1) {
	[array[pivotRank],array[end-1]] = [array[end-1],array[pivotRank]];
}

	partition(array, start, pivotRank);
    partition(array, pivotRank + 1, end);


}

const unsortedArray = [10,0,1,3,9,4,2,5,2,5,6]

console.log(quickSort(unsortedArray))





