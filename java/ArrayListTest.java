class ArrayListTest{
	public static void main(String args []){
		ArrayList<Egg> myList=new ArrayList();
		Egg s=new Egg();
		myList.add(s);
		
		Egg b=new Egg();
		myList.add(b);
		
		int size=myList.size();
		boolean isin =myList.contains(s);
		int idx=myList.indexOf(b);
		boolean empty=myList.isEmpty();
		myList.remove(s);
		
		
		
		
	}




}