
fn main(){
	let vector = vec![1,2,2,3,6,2,-11,6,0];
	println!("Unsorted array:{:?}",vector );
	let after = quick_sort(vector);
	println!("Sorted array:{:?}",after );
}

fn quick_sort(vector: Vec<i32>) -> Vec<i32>{

if vector.len()>1{

	let pivot = vector[0];

	let mut less = Vec::new();
	let mut equal = Vec::new();
	let mut greater = Vec::new();

	for value in vector {
		if value >pivot {
			greater.push(value)
		}
		if value < pivot{
			less.push(value)
		}
		if value==pivot{
			equal.push(value)
		}
    }
	let mut after_vector = Vec::new();

	after_vector.extend(quick_sort(less));
	after_vector.extend(equal);
	after_vector.extend(quick_sort(greater));

	return after_vector;
}
else{
	return vector;
    }
}


