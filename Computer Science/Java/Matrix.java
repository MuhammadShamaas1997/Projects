/*
public Matrix(double [][] mat,int r, int c)
public void tostring()
public Matrix add(Matrix mat)
public Matrix subtract(Matrix mat)
public double rowcolproduct(Matrix m1,int r1, Matrix m2, int c2)
public Matrix multiply(Matrix mat)
public Matrix scale(double alpha)
public Matrix transpose()
public double det()
public Matrix Inverse()
*/


import java.util.Objects;



public class Matrix extends Complex{

double [][] matrix={};
int rows = 0;
int cols = 0;
//double [][] matrix = { {2,7,9,5,6},{3,6,1,2,3},{7,4,2,7,2},{2,4,6,7,9},{7,4,1,7,4} };
//double [][] matrix = { {2,7,9,5},{3,6,1,2},{7,4,2,7},{2,4,6,7} };
//double [][] matrix = { {2,7,9},{3,6,1},{7,4,2} };
//double [][] matrix = { {2,3},{3,6} };
//double [][] matrix = { {2} };

//double [][] identity = { {1,0},{0,1} };
//double [][] identity = { {1,0,0},{0,1,0},{0,0,1} };
double [][] identity = { {1,0,0,0},{0,1,0,0},{0,0,1,0},{0,0,0,1} };
//double [][] identity = { {1,0,0,0,0},{0,1,0,0,0},{0,0,1,0,0},{0,0,0,1,0},{0,0,0,0,1} };

public Matrix(double [][] mat,int r, int c){
	matrix=mat;
	rows=r;
	cols=c;
}

public void tostring(){
	System.out.println("");
	System.out.println("{");
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
		System.out.print(matrix[r][c]+" ,");	
		}System.out.println("");
	}
	System.out.print("}");
	System.out.println("");
}

public Matrix add(Matrix mat){
	double [][] sum=new double[rows][cols];
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			sum[r][c]=matrix[r][c]+mat.matrix[r][c];
		}
	}
	return new Matrix(sum,rows,cols);
}

public Matrix subtract(Matrix mat){
	double [][] sum=new double[rows][cols];
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			sum[r][c]=matrix[r][c]-mat.matrix[r][c];
		}
	}
	return new Matrix(sum,rows,cols);
}

public double rowcolproduct(Matrix m1,int r1, Matrix m2, int c2){
	double sum=0.0;
	for (int c1=0;c1<m1.cols ;c1++ ) {
			sum+=(m1.matrix[r1][c1]*m2.matrix[c1][c2]);
	}
	return sum;
}

public Matrix multiply(Matrix mat){
	double [][] product=new double[rows][mat.cols];
	for (int r1=0;r1<rows ;r1++ ) {
		for (int c2=0;c2<mat.cols ;c2++ ) {
		product[r1][c2]=rowcolproduct(new Matrix(matrix,rows,cols),r1,mat,c2);
		}
	}
	return new Matrix(product,rows,mat.cols);
}

public Matrix scale(double alpha){
	double [][] result=new double[rows][cols];
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			result[r][c]=matrix[r][c]*alpha;
		}
	}
	return new Matrix(result,rows,cols);
}

public Matrix transpose(){
double [][] result=new double[cols][rows];
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			result[c][r]=matrix[r][c];
		}
	}
	return new Matrix(result,cols,rows);	
}

public double det(){
double determinant=0.0;
if(rows==1 && cols==1){
	return matrix[0][0];
}
else{
for (int c=0;c<cols ;c++ ) {
	double [][] minor=new double[rows-1][cols-1];
    for (int r2=1;r2<rows ;r2++ ) {
    int c3=0;
    	for (int c2=0;c2<cols ;c2++ ) {
    		if(c2==c){}
    		else{minor[r2-1][c3]=matrix[r2][c2];c3++;}
    	}
    }
    Matrix minormatix=new Matrix(minor,rows-1,cols-1);
	if((c%2)==0)
	{determinant+=(matrix[0][c]*minormatix.det());}
    else
    {determinant-=(matrix[0][c]*minormatix.det());}
}
return determinant;
}
}



public Matrix Inverse(){
double constant=0.0;
double constant1=0.0;
for (int p=0;p<rows ;p++ ) {
	for (int r=p;r<rows ;r++ ) {
		constant=matrix[r][p];
		for (int c=0;c<cols ;c++ ) {
			matrix[r][c]=matrix[r][c]/constant;
			identity[r][c]=identity[r][c]/constant;
		}
	}
	for (int r=p+1;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			matrix[r][c]=matrix[r][c]-matrix[p][c];
			identity[r][c]=identity[r][c]-identity[p][c];
		}
	}
}
for (int p=rows-1;p>=0 ;p-- ) {
	for (int r=p-1;r>=0 ;r-- ) {
		constant=matrix[r][p];
		for (int c=cols-1;c>=0 ;c-- ) {
			matrix[r][c]=matrix[r][c]-matrix[p][c]*constant;
			identity[r][c]=identity[r][c]-identity[p][c]*constant;
		}
		
	}
}
return new Matrix(identity,rows,cols);
}


    public static void main(String[] args) {
//    double [][] m1 = { {2,7,9,5,6},{3,6,1,2,3},{7,4,2,7,2},{2,4,6,7,9},{7,4,1,7,4} };
//    double [][] m2 = { {2,7,9,5,6},{3,6,1,2,3},{7,4,2,7,2},{2,4,6,7,9},{7,4,1,7,4} };
    double [][] m1 = { {2,7,3},{3,6,2} };
    double [][] m2 = { {2,7},{3,6} };	
	Matrix mat1=new Matrix(m1,2,3);
	Matrix mat2=new Matrix(m2,2,2);
//	Matrix inverse=mat.Inverse();
//	inverse.tostring();
Matrix mat3=mat1.transpose();
	mat3.tostring();
	//double determinant=mat.det();
	//System.out.println(determinant);
	}
}