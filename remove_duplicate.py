#this function removes duplicate values in a list
#input argument = list
#returns new list with only unique values

def remove_duplicates(duplicate):
	final_list = []
	for num in duplicate:
		if num not in final_list:
			final_list.append(num)
	return final_list


def unique_list(array,position):
	unique_list = []
	for i in array:
		if i not in unique_list:
			unique_list.append(i[position])
		else:
			pass
	unique_list = sorted(unique_list)
	
	return unique_list

def unique_list2(array):
	unique_list = []
	for i in array:
		if i not in unique_list:
			unique_list.append(i)
		else:
			pass
	unique_list = sorted(unique_list)
	return unique_list