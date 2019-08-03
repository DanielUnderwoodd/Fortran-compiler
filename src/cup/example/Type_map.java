package cup.example;

public class Type_map {
	
	String value_type;
	String variable_name;
	String FunctionName;
	public Type_map(String value_type  , String variable_name,String FunctionName){
		this.value_type = value_type;
		this.variable_name = variable_name;
		this.FunctionName = FunctionName;
	}

	public String Value_type (){
		return this.value_type;
	}


}
