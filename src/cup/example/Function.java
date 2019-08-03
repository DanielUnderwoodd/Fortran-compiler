package cup.example;

public class Function {
	
	
	int NumArg ;
	String FunctionName;
	String Length;
	
	
	public Function(int NumArg ,String FunctionName , String Length){
		this.Length = Length;
		this.FunctionName = FunctionName;
		this.NumArg = NumArg;
		getnumber();
	}
	
	public int getNumArg(){
		return this.NumArg;
	}

	
	
	
	public void getnumber()
	{
		int i ;
		int counter = 0;
	
		for( i = 0;i <this.Length.length();i++){
			if(this.Length.charAt(i)==','){
				counter++;
			}
			
		}
		this.NumArg = counter + 1;
		
		
	
		
		
	}
}
