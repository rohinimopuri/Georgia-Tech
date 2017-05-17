from scipy import stats
import numpy as np


# This method computes entropy for information gain
def entropy(class_y):
	"""Compute the entropy for a list of classes

	Example:
		entropy([0,0,0,1,1,1,1,1,1]) = 0.92
	"""
	if len(class_y)==0:
		return 0
	total=len(class_y)
	ones=sum(class_y)
	zeros=total-ones
	p1=float(ones)/total
	p0=float(zeros)/total
	if p1!=0 and p0!=0:
		return -p1*np.log2(p1)-p0*np.log2(p0)
	else:
		return 0
	# TODO: Implement this

def partition_classes(x, y, split_point):
	"""Partition the class vector, y, by the split point. 

	Return a list of two lists where the first list contains the labels 
	corresponding to the attribute values less than or equal to split point
	and the second list contains the labels corresponding to the attribute 
	values greater than split point

	Example:
	x = [2,4,6,7,3,7,9]	y = [1,1,1,0,1,0,0]	split_point = 5	output = [[1,1,1], [1,0,0,0]]
	""" 
	# TODO: Implement this
	data0=[]
	data1=[]
	y0=[]
	y1=[]
	for i in range(len(x)):
		if x[i]<=split_point:
			data0.append(x[i])
			y0.append(y[i])
		else:
			data1.append(x[i])
			y1.append(y[i])
	return (data0,data1,y0,y1)
	
def information_gain(previous_y, current_y):
	"""Compute the information gain from partitioning the previous_classes
	into the current_classes.

	Example:
	previous_classes = [0,0,0,1,1,1]	current_classes = [[0,0], [1,1,1,0]]	Information gain = 0.45915
	Input:
	-----
		previous_classes: the distribution of original labels (0's and 1's)
		current_classes: the distribution of labels given a particular attr
	"""
	# TODO: Implement this
	parent_entropy=entropy(previous_y)
	current_entropy=0.0
	total_len=0.0
	for c in current_y:
		total_len= total_len+len(c)
	for c in current_y:
		current_entropy=current_entropy+((float(len(c))/total_len)*entropy(c))
	gain=parent_entropy-current_entropy
	return gain
