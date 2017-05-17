from util import entropy, information_gain, partition_classes
import numpy as np

class DecisionTree(object):
	def __init__(self):
		self.tree = []

	def mutual_info(self,X,y):
		res=entropy(y)
		val, counts = np.unique(X, return_counts=True)
		freqs = counts.astype('float')/len(X)
		# We calculate a weighted average of the entropy
		for p, v in zip(freqs, val):
			res -= p * entropy(y[X == v])
		return res

	def partition_data(self,X,y,attr,split_val):
		X_left=[]
		X_right=[]
		y_left=[]
		y_right=[]
		for i in range(len(X)):
			if X[i,attr]<=split_val:
				X_left.append(X[i,:])
				y_left.append(y[i])
			else:
				X_right.append(X[i,:])
				y_right.append(y[i])
		return (X_left,X_right,y_left,y_right)

	def learn(self, X, y):
		# TODO: train decision tree and store it in self.tree
		X1=[x[:-1] for x in X]
		X1=np.asarray(X1)
		X=X1
		y=np.asarray(y)
		ncol=len(X[0])
		nrow=len(X)
		if ncol==1:
			return self.find_label(y)
		elif len(y)==sum(y):
			return 1
		elif sum(y)==0:
			return 0
		elif nrow<=5:
			return self.find_label(y)
		else:
			gain=np.array([self.mutual_info(X[:,attr],y) for attr in range(len(X[0]))])
			selected_feature=np.argmax(gain)
			max_gain=-100000.0
			split_value=None
			for i in range(len(X)):
				X_left,X_right,y_left,y_right=self.partition_data(X,y,selected_feature,X[i,selected_feature])
				current_y=[y_left,y_right]
				gain= information_gain(y,current_y)
				if gain>max_gain:
					max_gain=gain
					split_value=X[i][selected_feature]
					bX_left=X_left
					by_left=y_left
					bX_right=X_right
					by_right=y_right
			if len(bX_right)==0 or len(bX_left)==0:
				return self.find_label(y)
			else:
				curr_tree=[]
				tree_left=self.learn(bX_left,by_left)
				tree_right=self.learn(bX_right,by_right)
				curr_tree=[selected_feature,split_value,tree_left,tree_right]
				self.tree=curr_tree
				return curr_tree
						
	def find_label(self,y):
		if sum(y)>=len(y)/2:
			return 1
		else:
			return 0

	def classify(self, record):
		# TODO: return predicted label for a single record using self.tree
		tree=self.tree
		while type(tree)==list:
			if record[tree[0]]<=tree[1]:
				tree=tree[2]
			else:
				tree=tree[3]
		result=tree
		return result
		
