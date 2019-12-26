/*
public class ComplexMatrix extends Complex{

int rows = 0;
int cols = 0;
Complex [][] matrix = {};
Complex [][] identity = {};
ComplexMatrix [][] tensor = {};
double [][] realmatrix={};
Boolean Realmatrix=false;
Boolean Matrix=false;
Boolean Tensor=false;

public ComplexMatrix(Complex [][] mat,int r, int c){
public ComplexMatrix(ComplexMatrix [][] mat,int r, int c){
public ComplexMatrix(double [][] mat,int r, int c){

public void printMatrixAsString(){
public void printMatrixToFile(){
public void writeUsingOutputStream(String data) {
public ComplexMatrix(Complex [][] mat,int r, int c){
public void printMatrixAsString(){
public ComplexMatrix add(ComplexMatrix mat){
public ComplexMatrix subtract(ComplexMatrix mat){
public ComplexMatrix rowinterchange(int r1,int r2){
public ComplexMatrix colinterchange(int c1,int c2){
public ComplexMatrix rowmultiplication(int r,Complex com){
public ComplexMatrix rowdivision(int r,Complex com){
public ComplexMatrix colmultiplication(int c,Complex com){
public ComplexMatrix coldivision(int c,Complex com){
public ComplexMatrix rowsaddition(int r1,int r2,Complex com){
public ComplexMatrix rowssubtraction(int r1,int r2,Complex com){
public ComplexMatrix colsaddition(int c1,int c2,Complex com){
public ComplexMatrix colssubtraction(int c1,int c2,Complex com){
public Complex rowcolproduct(ComplexMatrix m1,int r1, ComplexMatrix m2, int c2){
public ComplexMatrix dotProduct(ComplexMatrix mat){
public ComplexMatrix crossProduct(ComplexMatrix mat){
public ComplexMatrix dotmultiply(ComplexMatrix mat){
public ComplexMatrix dotdivide(ComplexMatrix mat){
public ComplexMatrix dotplus(ComplexMatrix mat){
public ComplexMatrix dotminus(ComplexMatrix mat){
public ComplexMatrix scale(Complex alpha){
public ComplexMatrix rootsToPoly(){
public ComplexMatrix conv(ComplexMatrix mat){
public Complex PolyVal(Complex com){
public ComplexMatrix polyToRoots(double center, double range){
public ComplexMatrix transpose(){
public Complex det(){
public ComplexMatrix Inverse(){
public ComplexMatrix exp(){
public ComplexMatrix mpower(int p){
public ComplexMatrix zeros(){
public ComplexMatrix ones(){
public ComplexMatrix eye(int n){
public ComplexMatrix diagCopy(){
public int [] size(){
public ComplexMatrix sort(){
public ComplexMatrix cummulativeRowProd(){
public ComplexMatrix cummulativeRowSum(){
public ComplexMatrix diff(){
public double norm(int p){
public Complex trace(){
public ComplexMatrix matrixConjugate(){
public ComplexMatrix complexConjugateTranspose(){
public ComplexMatrix appendrow(ComplexMatrix mat){
public ComplexMatrix replacerow(ComplexMatrix mat, int row){
public ComplexMatrix appendcol(ComplexMatrix mat){
public ComplexMatrix replacecol(ComplexMatrix mat,int column){
public void kernal(){
public ComplexMatrix eig(){
public double trapz(ComplexMatrix x){
public ComplexMatrix tensorDeterminant(){
public ComplexMatrix characteristicPolynomial(){
public void linearDCMachine(Complex VB, Complex R, Complex B, Complex L, Complex M){
public void RectangularLoopInUniformMagneticField(){
public void TorqueInducedInRectangularCurrentCarryingLoopInUniformMagneticField(){
public void TransferFunction(){
public ComplexMatrix getRow(int row){
public ComplexMatrix getColumn(int col){
public ComplexMatrix RowMean(){
public ComplexMatrix ColMean(){
public ComplexMatrix lsqnonneg(ComplexMatrix Xmat){
public ComplexMatrix TwoPortParameters(ComplexMatrix mat,int row, int col){
public Complex fminbnd(ComplexMatrix x){
public Complex PolyInt(ComplexMatrix x){
public ComplexMatrix PolyDer(ComplexMatrix x){
*/

import java.util.Objects;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Paths;


public class ComplexMatrix extends Complex{

int rows = 0;
int cols = 0;
Complex [][] matrix = {};
Complex [][] identity = {};
ComplexMatrix [][] tensor = {};
double [][] realmatrix={};
Boolean Realmatrix=false;
Boolean Matrix=false;
Boolean Tensor=false;
public ComplexMatrix(Complex [][] mat,int r, int c){
    matrix=mat;
	rows=r;
	cols=c;
	Matrix=true;
	identity=new Complex [rows][cols];
	for (int row=0;row<rows ;row++ ) {
		for (int col=0;col<cols ;col++ ) {
			if(row==col){
				identity[row][col]=new Complex(1,0);
			}
			else{
				identity[row][col]=new Complex();
			}
		}
	}
}

public ComplexMatrix(ComplexMatrix [][] mat,int r, int c){
    tensor=mat;
	rows=r;
	cols=c;
	Tensor=true;
}

public ComplexMatrix(double [][] mat,int r, int c){
    realmatrix=mat;
	rows=r;
	cols=c;
	Realmatrix=true;
}

//prints matrix as string on command line
public void printMatrixAsString(){
	System.out.println("");
	System.out.println("{");
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			if(Matrix)
				{System.out.print(matrix[r][c].toString()+" ,");}
			if(Realmatrix)
				{System.out.print(realmatrix[r][c]+" ,");}
			if(Tensor)
				{tensor[r][c].printMatrixAsString();}	
		}
		System.out.println("");
	}
	System.out.print("}");
	System.out.println("");
}

//prints matrix to file with one number per row
public void printMatrixToFile(){
	String data="";
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			if(Matrix)
				{data=data+(matrix[r][c].abs()+System.lineSeparator());}
			if(Realmatrix)
				{data=data+(realmatrix[r][c]+System.lineSeparator());}
		};
	}
	writeUsingOutputStream(data);
} 

//prints matrix to file Data.txt
public void writeUsingOutputStream(String data) {
        OutputStream os = null;
        try {
        	os = new FileOutputStream(new File("Data.txt"));
            os.write(data.getBytes(), 0, data.length());
        } catch (IOException e) {
            e.printStackTrace();
        }finally{
            try {
                os.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
}

//adds two matrices of same dimensions
public ComplexMatrix add(ComplexMatrix mat){
	Complex [][] m = new Complex [rows][cols];
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			m[r][c]=matrix[r][c].plus(mat.matrix[r][c]);
		}
	}
	return new ComplexMatrix(m,rows,cols);
}

//subtracts two matrices of same dimensions
public ComplexMatrix subtract(ComplexMatrix mat){
	Complex [][] m = new Complex [rows][cols];
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			m[r][c]=matrix[r][c].minus(mat.matrix[r][c]);
		}
	}
	return new ComplexMatrix(m,rows,cols);
}

//interchanges matrix rows r1 and r2
public ComplexMatrix rowinterchange(int r1,int r2){
	ComplexMatrix mat = zeros(rows,cols).add(this);
	Complex temp=new Complex();
	for (int c=0;c<cols ;c++ ) {
		temp=matrix[r1][c];
		mat.matrix[r1][c]=matrix[r2][c];
		mat.matrix[r2][c]=temp;
	}
	return mat;		
}

//interchanges matrix columns c1 and c2
public ComplexMatrix colinterchange(int c1,int c2){
	return this.transpose().rowinterchange(c1,c2).transpose();
}

//multiplies matrix row r by Complex com
public ComplexMatrix rowmultiplication(int r,Complex com){
	ComplexMatrix mat = zeros(rows,cols).add(this);
	Complex temp=new Complex();
	for (int c=0;c<cols ;c++ ) {
		mat.matrix[r][c]=matrix[r][c].times(com);
	}
	return mat;
}

//divides matrix row r by Complex com
public ComplexMatrix rowdivision(int r,Complex com){
	ComplexMatrix mat = zeros(rows,cols).add(this);
	Complex temp=new Complex();
	for (int c=0;c<cols ;c++ ) {
		mat.matrix[r][c]=matrix[r][c].divides(com);
	}
	return mat;
}

//multiplies matrix column c by Complex com
public ComplexMatrix colmultiplication(int c,Complex com){
	return this.transpose().rowmultiplication(c,com).transpose();
}

//divides matrix column c by Complex com
public ComplexMatrix coldivision(int c,Complex com){
	return this.transpose().rowdivision(c,com).transpose();
}

//row r1 = row r1 + row r2 * com 
public ComplexMatrix rowsaddition(int r1,int r2,Complex com){
	ComplexMatrix mat = zeros(rows,cols).add(this);
	for (int c=0;c<cols ;c++ ) {
		mat.matrix[r1][c]=matrix[r1][c].plus(matrix[r2][c].times(com));
	}
	return mat;
}

//row r1 = row r1 - row r2 * com 
public ComplexMatrix rowssubtraction(int r1,int r2,Complex com){
	ComplexMatrix mat = zeros(rows,cols).add(this);
	for (int c=0;c<cols ;c++ ) {
		mat.matrix[r1][c]=matrix[r1][c].minus(matrix[r2][c].times(com));
	}
	return mat;
}

//col c1 = col c1 + col c2 * com
public ComplexMatrix colsaddition(int c1,int c2,Complex com){
	return this.transpose().rowsaddition(c1,c2,com).transpose();
}

//col c1 = col c1 - col c2 * com
public ComplexMatrix colssubtraction(int c1,int c2,Complex com){
	return this.transpose().rowssubtraction(c1,c2,com).transpose();
}

//row r1 of matrix m1 is multiplied by column c2 of matrix m2
public Complex rowcolproduct(ComplexMatrix m1,int r1, ComplexMatrix m2, int c2){
	Complex sum=new Complex();
	for (int c1=0;c1<m1.cols ;c1++ ) {
		sum=sum.plus((m1.matrix[r1][c1]).times(m2.matrix[c1][c2]));
	}
	return sum;
}

//dotProduct of two matrices. # cols of matrix = # rows of mat
public ComplexMatrix dotProduct(ComplexMatrix mat){
	ComplexMatrix matr = zeros(rows,mat.cols);
	for (int r1=0;r1<rows ;r1++ ) {
		for (int c2=0;c2<mat.cols ;c2++ ) {
			matr.matrix[r1][c2]=rowcolproduct(new ComplexMatrix(matrix,rows,cols),r1,mat,c2);
		}
	}
	return matr;
}

//cross product of two matrices of dimensions 1 X 3
public ComplexMatrix crossProduct(ComplexMatrix mat){
	Complex [][] res=new Complex[1][3];
	res[0][0]=(matrix[0][1].times(mat.matrix[0][2])).minus(matrix[0][2].times(mat.matrix[0][1]));
	res[0][1]=((matrix[0][0].times(mat.matrix[0][2])).minus(matrix[0][2].times(mat.matrix[0][0]))).times(new Complex(-1,0));;
	res[0][2]=(matrix[0][0].times(mat.matrix[0][1])).minus(matrix[0][1].times(mat.matrix[0][0]));
	return new ComplexMatrix(res,1,3);
}

//element wise multiplication of two matrices
public ComplexMatrix dotmultiply(ComplexMatrix mat){
	ComplexMatrix matr = zeros(rows,cols);
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			matr.matrix[r][c]=matrix[r][c].times(mat.matrix[r][c]);
		}
	}
	return matr;	
}

//element wise division of two matrices
public ComplexMatrix dotdivide(ComplexMatrix mat){
	ComplexMatrix matr = zeros(rows,cols);
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			matr.matrix[r][c]=matrix[r][c].divides(mat.matrix[r][c]);
		}
	}
	return matr;	
}

//element wise addition of two matrices
public ComplexMatrix dotplus(ComplexMatrix mat){
	ComplexMatrix matr = zeros(rows,cols);
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			matr.matrix[r][c]=matrix[r][c].plus(mat.matrix[r][c]);
		}
	}
	return matr;	
}

//element wise subtraction of two matrices
public ComplexMatrix dotminus(ComplexMatrix mat){
	ComplexMatrix matr = zeros(rows,cols);
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			matr.matrix[r][c]=matrix[r][c].minus(mat.matrix[r][c]);
		}
	}
	return matr;	
}

//element wise multiplication of a matrix and Complex alpha
public ComplexMatrix scale(Complex alpha){
	ComplexMatrix matr = zeros(rows,cols);
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			matr.matrix[r][c]=matrix[r][c].times(alpha);
		}
	}
	return matr;
}

//compute poynomial with elements of matrix as its roots 
public ComplexMatrix rootsToPoly(){
	int cols1=2;
	int cols2=2;
	Complex [][] res  = zeros(1,cols+1).matrix;
	Complex [][] mat1 = zeros(1,cols+1).matrix;
	Complex [][] mat2 = zeros(1,cols+1).matrix;
	mat1[0][1]=(new Complex(matrix[0][0].re(),matrix[0][0].im())).times(new Complex(-1,0));
	mat1[0][0]=new Complex(1,0);

	for(int c=1;c<cols;c++){
		res  = zeros(1,cols+1).matrix;
		mat2[0][1]=(new Complex(matrix[0][c].re(),matrix[0][c].im())).times(new Complex(-1,0));
		mat2[0][0]=new Complex(1,0);
		for (int c1=0 ;c1<cols1 ;c1++ ) {
			for (int c2=0;c2<cols2 ;c2++ ) {
					res[0][c1+c2]=res[0][c1+c2].plus(mat1[0][c1].times(mat2[0][c2]));
			}
		}
		cols1++;
		for (int cc=0;cc<cols1 ;cc++ ) {
			mat1[0][cc]=res[0][cc];
		}
	}
	return new ComplexMatrix(res,1,cols+1);
}

//convolution of two matrices/ multiplication of two (fractional with numerator row and denominator row) polynomials
public ComplexMatrix conv(ComplexMatrix mat){
	Complex [][] res =zeros(rows,cols+mat.cols-1).matrix;
	
	for(int r=0;r<rows;r++){	
		for (int c1=0 ;c1<cols ;c1++ ) {
			for (int c2=0;c2<mat.cols ;c2++ ) {
				res[r][c1+c2]=res[r][c1+c2].plus(matrix[r][c1].times(mat.matrix[r][c2]));
			}
		}
	}
	return new ComplexMatrix(res,rows,cols+mat.cols-1);
}

//computes value of polynomial at Complex com
public Complex PolyVal(Complex com){
	Complex res=new Complex();	
	for (int c=0;c<cols ;c++ ) {
		res=res.plus(matrix[0][c].times(com.power(cols-1-c)));
	}
	return res;
}

//computes roots of polynomial in range (center-range)+(center-range)i to (center+range)+(center+range)i with step range/1000
public ComplexMatrix polyToRoots(double center, double range){
	Complex [][] res = zeros(1,cols-1).matrix;
	
	int rootsfound=0;
	Complex difference=new Complex();
	for (double r=(center-range);r<=(center+range);r=r+(range/1000.0)){
		for (double i=(center-range);i<=(center+range) ;i=i+(range/1000.0) ) {
			Complex com=new Complex(r,i);
			difference = PolyVal(com);
			if(difference.abs()<(range/10000.0)){
				res[0][rootsfound]=com;
				rootsfound++;
				System.out.println(com.toString());
				if(rootsfound==(cols-1)){
					i=center+range;r=center+range;
				}
			}
		}
	}
	return new ComplexMatrix(res,1,cols-1);
}

//transpose of matrix
public ComplexMatrix transpose(){
	Complex [][] result=new Complex[cols][rows];
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			result[c][r]=matrix[r][c];
		}
	}
	return new ComplexMatrix(result,cols,rows);	
}

//determinant of square matrix
public Complex det(){
	Complex determinant=new Complex();
	if(rows==1 && cols==1){
		return matrix[0][0];
	}
	else{
		for (int c=0;c<cols ;c++ ) {
			Complex [][] minor=new Complex[rows-1][cols-1];
    		for (int r2=1;r2<rows ;r2++ ) {
    			int c3=0;
    			for (int c2=0;c2<cols ;c2++ ) {
    				if(c2==c){

    				}
    				else{
    					minor[r2-1][c3]=matrix[r2][c2];c3++;
    				}
    			}
    		}
    		ComplexMatrix minormatix=new ComplexMatrix(minor,rows-1,cols-1);
			if((c%2)==0){
	 			determinant=determinant.plus(matrix[0][c].times(minormatix.det()));
			}
    		else{
     			determinant=determinant.minus(matrix[0][c].times(minormatix.det()));
    		}
		}
		return determinant;
	}
}

//computes inverse of square matrix
public ComplexMatrix Inverse(){
	Complex constant=new Complex();
	Complex constant1=new Complex();
	ComplexMatrix mat=zeros(rows,cols).add(this);

	for (int p=0;p<cols ;p++ ) {
		for (int r=p;r<rows ;r++ ) {
			constant=mat.matrix[r][p];
			for (int c=0;c<cols ;c++ ) {
				mat.matrix[r][c]=mat.matrix[r][c].divides(constant);
				identity[r][c]=identity[r][c].divides(constant);
			}
		}
		for (int r=p+1;r<rows ;r++ ) {
			for (int c=0;c<cols ;c++ ) {
				mat.matrix[r][c]=mat.matrix[r][c].minus(mat.matrix[p][c]);
				identity[r][c]=identity[r][c].minus(identity[p][c]);
			}
		}
	}
	for (int p=rows-1;p>=0 ;p-- ) {
		for (int r=p-1;r>=0 ;r-- ) {
			constant=mat.matrix[r][p];
			for (int c=cols-1;c>=0 ;c-- ) {
				mat.matrix[r][c]=mat.matrix[r][c].minus(mat.matrix[p][c].times(constant));
				identity[r][c]=identity[r][c].minus(identity[p][c].times(constant));
			}
		}
	}
	return new ComplexMatrix(identity,rows,cols);
}

//element wise exponential of matrix
public ComplexMatrix exp(){
	ComplexMatrix matr = zeros(rows,cols);
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			matr.matrix[r][c]=(matrix[r][c]).exp();
		}
	}
	return matr;
}

//square matrix multiplied with itself p times
public ComplexMatrix mpower(int p){
	Complex [][] mat = eye(rows).matrix;
	for (int c=0;c<p ;c++ ) {
		mat=((new ComplexMatrix(mat,rows,cols)).dotProduct(new ComplexMatrix (matrix,rows,cols))).matrix;
	}
	return new ComplexMatrix(mat,rows,cols);
}

//Complex matrix with all zeros and dimensions row X col
public ComplexMatrix zeros(int row,int col){
	Complex [][] mat=new Complex[row][col];
	for (int r=0;r<row ;r++ ) {
		for (int c=0;c<col ;c++ ) {
			mat[r][c]=new Complex();
		}
	}
	return new ComplexMatrix(mat,row,col);
}

//Real matrix with all zeros and dimensions row X col
public ComplexMatrix Realzeros(int row,int col){
	double [][] mat=new double[row][col];
	for (int r=0;r<row ;r++ ) {
		for (int c=0;c<col ;c++ ) {
			mat[r][c]=0;
		}
	}
	return new ComplexMatrix(mat,row,col);
}

//matrix with all ones and dimensions row X col
public ComplexMatrix ones(int row, int col){
	Complex [][] mat=new Complex[row][col];
	for (int r=0;r<row ;r++ ) {
		for (int c=0;c<col ;c++ ) {
			mat[r][c]=new Complex(1,0);
		}
	}
	return new ComplexMatrix(mat,row,col);
}

//identity matrix with dimensions n X n
public ComplexMatrix eye(int n){
	Complex [][] idn=new Complex[n][n];
	for (int r=0;r<n ;r++ ) {
		for (int c=0;c<n ;c++ ) {
			idn[r][c]=new Complex();
			if(r==c){idn[r][c]=new Complex(1,0);}
		}
	}
	return new ComplexMatrix(idn,n,n);
}

//matrix with same diagonal but all other entries zero
public ComplexMatrix diagCopy(){
	Complex [][] mat=new Complex[rows][cols];
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			if(r==c){
				mat[r][c]=matrix[r][c];
			}
			else{
				mat[r][c]=new Complex();
			}
		}
	}
	return new ComplexMatrix(mat,rows,cols);
}

//size of matrix: [rows , cols]
public int [] Size(){
	int [] size=new int[2];
	size[0]=rows;
	size[1]=cols;
	return size;
}

//sort each row of matrix in ascending order
public ComplexMatrix rowSort(){
	Complex temp = new Complex();
	Complex [][] mat=matrix;
	for (int r=0;r<rows ;r++ ) {
		for (int c1=0;c1<(cols-1) ;c1++ ) {
			for (int c2=(c1+1);c2<cols ;c2++ ) {
				if(matrix[r][c1].abs()>matrix[r][c2].abs()){
					temp=matrix[r][c1];
					mat[r][c1]=matrix[r][c2];
					mat[r][c2]=temp;
				}
			}
		}
	}
	return new ComplexMatrix(mat,rows,cols);
}

//sort each column of matrix in ascending order
public ComplexMatrix colSort(){
	return this.transpose().rowSort().transpose();
}

//cummulative Row Product of matrix
public ComplexMatrix cummulativeRowProd(){
	Complex [][] mat=new Complex[rows][cols];
	for (int r=0;r<rows ;r++ ) {
		for (int c=1;c<cols ;c++ ) {mat[r][0]=matrix[r][0];
			mat[r][c]=matrix[r][c].times(matrix[r][c-1]);
		}
	}
	return new ComplexMatrix(mat,rows,cols);
}

//cummulative Col Product of matrix
public ComplexMatrix cummulativeColProd(){
	return this.transpose().cummulativeRowProd().transpose();
}

//cummulative Row Sum of matrix
public ComplexMatrix cummulativeRowSum(){
	Complex [][] mat=new Complex [rows][cols];
	for (int r=0;r<rows ;r++ ) {
		for (int c=1;c<cols ;c++ ) {mat[r][0]=matrix[r][0];
			mat[r][c]=matrix[r][c].plus(mat[r][c-1]);
		}
	}
	return new ComplexMatrix(mat,rows,cols);
}

//cummulative Col Sum of matrix
public ComplexMatrix cummulativeColSum(){
	return this.transpose().cummulativeRowSum().transpose();
}

//cummulative Row Difference of matrix
public ComplexMatrix Rowdiff(){
	Complex [][] mat = new Complex [rows][cols-1];
	for (int r=0;r<rows ;r++ ) {
		for (int c=1;c<cols ;c++ ) {mat[r][0]=matrix[r][0];
			mat[r][c-1]=matrix[r][c].minus(matrix[r][c-1]);
		}
	}
	return new ComplexMatrix(mat,rows,cols-1);
}

//cummulative Col Difference of matrix
public ComplexMatrix Coldiff(){
	return this.Rowdiff().transpose();
}

//p-norm of matrix. p-root of sum of Each element raised to power p
public double norm(int p){
	double norm=0.0;
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			norm=norm+(Math.pow(matrix[r][c].abs(),p));
		}
	}
	norm=Math.pow(norm,(1/p));
	return norm;
}

//sum of diagonal elements of matrix
public Complex trace(){
	Complex sum=new Complex();
	for (int r=0;r<rows ;r++ ) {
		sum.plus(matrix[r][r]);
	}
	return sum;
}

//element wise complex conjugate of matrix
public ComplexMatrix matrixConjugate(){
	Complex [][] mat = new Complex[rows][cols];
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			mat[r][c]=matrix[r][c].conjugate();
		}
	}
	return new ComplexMatrix(mat,rows,cols);
}

//element wise complex conjugate of transpose of matrix
public ComplexMatrix complexConjugateTranspose(){
	return (new ComplexMatrix(matrix,rows,cols)).transpose().matrixConjugate();
}

//append mat as row+1 to end of matrix
public ComplexMatrix appendrow(ComplexMatrix mat){
	Complex [][] m = new Complex [rows+1][cols];
	
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			m[r][c]=matrix[r][c];
		}
	}
	for (int c=0;c<cols ;c++ ) {
		m[rows][c]=mat.matrix[0][c];
	}
	return new ComplexMatrix(m,rows+1,cols);
}

//append mat as col+1 to end of matrix
public ComplexMatrix appendcol(ComplexMatrix mat){
	return this.transpose().appendrow(mat).transpose();
}

//replace mat as row in matrix in place of row number row
public ComplexMatrix replacerow(ComplexMatrix mat, int row){
	Complex [][] m = matrix;
	for (int c=0;c<cols ;c++ ) {
		m[row][c]=mat.matrix[row][c];
	}
	return new ComplexMatrix(m,rows,cols);
}

//replace mat as column in matrix in place of column number column
public ComplexMatrix replacecol(ComplexMatrix mat,int column){
	return this.transpose().replacerow(mat,column).transpose();
}

//public ComplexMatrix rowEchelonFormReduction(){}

//kernal of matrix computed using column operations to get column echelon form. zero columns correspond to basis of kernal
public void kernal(){
	Complex [][] mat=new Complex[rows+cols][cols];
	Complex [] rowsums=new Complex[rows+cols];
	for (int r=0;r<(rows+cols) ;r++ ) {
		rowsums[r]=new Complex();
	}

	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			mat[r][c]=matrix[r][c];
		}
	}

	for (int r=rows;r<rows+cols ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			if((r-rows)==c){
				mat[r][c]=new Complex(1,0);
			}
			else{
				mat[r][c]=new Complex();
			}
		}
	}

	Complex sum=new Complex();
	for (int r=0;r<(rows+cols) ;r++ ) {
		for (int c=0;c<(cols) ;c++ ) {
			rowsums[r]=rowsums[r].plus(mat[r][c]);
		}
	}

	for (int r=0;r<(rows+cols) ;r++ ) {
		for (int c=0;c<(cols) ;c++ ) {
			mat[r][c]=mat[r][c].plus(rowsums[r]);
		}
	}


	Complex constant=new Complex();
	for(int p=0;p<(rows+cols);p++){
		for (int c=p;c<cols ;c++ ) {
			constant=mat[p][c];
			for (int r=0;r<(rows+cols) ;r++ ) {
				if(constant.abs()>(0.000000000001)){
					mat[r][c]=mat[r][c].divides(constant);
				}
			}
		}
	for (int c=p+1;c<cols ;c++ ) {
		constant=mat[p][c];
		for (int r=0;r<(rows+cols) ;r++ ) {
			if(constant.abs()>(0.000000000001)){
				mat[r][c]=mat[r][c].minus(mat[r][p]);
			}
		}
	}
	}

	Complex min=new Complex(10000,0);
	for (int c=0;c<cols ;c++ ) {
		for (int r=0;r<(rows+cols) ;r++ ) {
			if((mat[r][c].abs()<min.abs())&&(mat[r][c].abs()>(0.000000000001))){
				min=mat[r][c];
			}
		}
		for (int r=0;r<(rows+cols) ;r++ ) {
			mat[r][c]=mat[r][c].divides(min);
		}
		min=new Complex(10000,0);
	}
	(new ComplexMatrix(mat,rows+cols,cols)).printMatrixAsString();	
}

//eigen values of square matrix computed by making characteristic polynomial of matrix
public ComplexMatrix eig(){
	return (new ComplexMatrix(matrix,rows,cols)).characteristicPolynomial().polyToRoots(0.0,100.0);
}

//trepezium integral of matrix function using x as independent variable values
public Complex trapz(ComplexMatrix x){
	Complex sum=new Complex();
	for (int i=1;i<cols ;i++ ) {
		sum=sum.plus((new Complex(0.5,0)).times(matrix[0][i].plus(matrix[0][i-1])).times(x.matrix[0][i].minus(x.matrix[0][i-1])));
	}
	return sum;
}

//trepezium derivative of matrix function using x as independent variable values
public ComplexMatrix Derivative(ComplexMatrix x){
	ComplexMatrix der=zeros(1,cols);
	for (int i=1;i<cols ;i++ ) {
		der.matrix[0][i]=(matrix[0][i].minus(matrix[0][i-1])).divides(x.matrix[0][i].minus(x.matrix[0][i-1]));
	}
	return der;
}

//tensor determinant of square tensor. Each element corresponds to a (fractional) polynomial
public ComplexMatrix tensorDeterminant(){
	Complex[][] comp=zeros(1,cols+1).matrix;
	ComplexMatrix determinant=new ComplexMatrix(comp,1,cols+1);


	if(rows==1 && cols==1){
		return tensor[0][0];
	}
	else{
		for (int c=0;c<cols ;c++ ) {
			ComplexMatrix [][] minor=new ComplexMatrix[rows-1][cols-1];
    		for (int r2=1;r2<rows ;r2++ ) {
    			int c3=0;
    			for (int c2=0;c2<cols ;c2++ ) {
    				if(c2==c){

    				}
    				else{
    					minor[r2-1][c3]=tensor[r2][c2];c3++;
    				}
    			}
    		}
    		ComplexMatrix minormatix=new ComplexMatrix(minor,rows-1,cols-1);
			if((c%2)==0){
	 			determinant=determinant.add(tensor[0][c].conv(minormatix.tensorDeterminant()));
			}
    		else{
     			determinant=determinant.subtract(tensor[0][c].conv(minormatix.tensorDeterminant()));
    		}
		}
		return determinant;
	}
}

//characeristic polynomial of matrix
public ComplexMatrix characteristicPolynomial(){

	tensor=new ComplexMatrix[rows][cols];
	for (int r=0;r<rows ;r++ ) {
		for (int c=0;c<cols ;c++ ) {
			Complex[][] cmat={ {new Complex(0,0),matrix[r][c].times(new Complex(-1,0))} };
			tensor[r][c]=new ComplexMatrix(cmat,1,2);
		
			if(r==c){
				Complex[][] cmatt={ {new Complex(1,0),matrix[r][c].times(new Complex(-1,0))} };
				tensor[r][c]=new ComplexMatrix(cmatt,1,2);
			}
		}
	}
	return (new ComplexMatrix(tensor,rows,cols)).tensorDeterminant();
}



//Rotational Motion,Newton's Laws and Power Relationships 
/*
	LinearVelocityInMeterPerSecond=d(LinearDisplacementInMeter)/d(TimeInSecond);
	AngularVelocityInRadiansPerSecond=d(AngularDisplacementInRadians)/d(TimeInSecond);
	AngularVelocityInRevolutionsPerSecond=AngularVelocityInRadiansPerSecond/(2*Math.PI);
	AngularVelocityInRevolutionsPerMinute=60*AngularVelocityInRevolutionsPerSecond;
	LinearAccelerationInMeterPerSecondPerSecond=d(LinearVelocityInMeterPerSecond)/d(TimeInSecond);
	AngularAccelerationInRadiansPerSecondPerSecond=d(AngularVelocityInRadiansPerSecond)/d(TimeInSecond);
	LinearTorqueInNewtonMeter=(ForceInNewton).CrossProduct(PositionVectorFromPivotToSurface);
	ForceInNewton=MassInKilogram*LinearAccelerationInMeterPerSecondPerSecond
	AngularTorqueInNewtonMeter=MomentOfInertia*AngularAccelerationInRadiansPerSecondPerSecond;
	WorkInJoules=Integral(ForceInNewton)d(LinearDisplacementInMeter);
	WorkInJoules=Integral(AngularTorqueInNewtonMeter)d(AngularDisplacementInRadians);
	PowerInWatts=d(WorkInJoules)/d(TimeInSecond);
	PowerInWatts=ForceInNewton*LinearVelocityInMeterPerSecond;
	PowerInWatts=AngularTorqueInNewtonMeter*AngularVelocityInRadiansPerSecond;
	CurrentInAmperes=Integral(MagneticFieldIntensityInAmpereTurnsPerMeter.dotProduct(d(LinearDisplacementInMeter)));
	MagneticFieldIntensityInAmpereTurnsPerMeter=(WireTurns*CurrentInAmperes)/MeanPathLengthOfCore;
	MagneticFluxDensityInTesla=MagneticPermeabilityOfFreeSpaceInHenrysPerMeter*MagneticFieldIntensityInAmpereTurnsPerMeter;
	RelativePermeability=MagneticPermeabilityOfMaterialInHenrysPerMeter/MagneticPermeabilityOfFreeSpaceInHenrysPerMeter;
	MagneticFluxInWeber=Integral(MagneticFluxDensityInTesla.dotProduct(d(AreaInMeterMeter)));
	VoltageInVolts=CurrentInAmperes*ResistanceInOhms;
	MagnetomotiveForceInAmpereTurns=WireTurns*CurrentInAmperes;
	MagnetomotiveForceInAmpereTurns=MagneticFluxInWeber*MagneticReluctanceInAmpereTurnsPerWeber;
	MagneticPermeanceInWeberPerAmperePerTurn=1/MagneticReluctanceInAmpereTurnsPerWeber;
	MagneticFluxInWeber=MagnetomotiveForceInAmpereTurns*MagneticPermeanceInWeberPerAmperePerTurn;
	MagneticFluxInWeber=(WireTurns*CurrentInAmperes*MagneticPermeabilityOfMaterialInHenrysPerMeter*AreaInMeterMeter)/MeanPathLengthOfCore;
	MagneticFluxInWeber=(MagnetomotiveForceInAmpereTurns*MagneticPermeabilityOfMaterialInHenrysPerMeter*AreaInMeterMeter)/MeanPathLengthOfCore;
	InducedVoltageInCoilInVolts=Summation(-d(MagneticFluxInWeber)/d(TimeInSecond));
	InducedVoltageInCoilInVolts=Summation(InducedVoltageInTurnInVolts);
	MagneticFluxLinkageInWeberTurns=Summation(MagneticFluxOfTurnInWeber);
	ForceInNewton=CurrentInAmperes*(LengthVectorInDirectionOfCurrent.CrossProduct(MagneticFluxDensityInTesla));
	InducedVoltageInTurnInVolts=(LinearVelocityInMeterPerSecond.CrossProduct(MagneticFluxDensityInTesla)).dotProduct(LengthInMagneticFieldInMeter);
*/

//Simulate a linear DC Machine 
public void linearDCMachine(Complex VB, Complex R, Complex B, Complex L, Complex M){
	Complex VoltageInVolts=VB;
	Complex ResistanceInOhms=R;
	Complex MagneticFluxDensityInTesla=B;
	Complex BarLengthInMagneticFieldInMeter=L;
	Complex BarMassInKilogram=M;

	ComplexMatrix BarInducedVoltageInVolts=zeros(1,101);
	ComplexMatrix CurrentInAmperes=zeros(1,101);
	ComplexMatrix BarLinearVelocityInMeterPerSecond=zeros(1,101);
	ComplexMatrix InducedForceInNewton=zeros(1,101);
	ComplexMatrix BarLinearAccelerationInMeterPerSecondPerSecond=zeros(1,101);

	BarInducedVoltageInVolts.matrix[0][0]=new Complex();
	CurrentInAmperes.matrix[0][0]=VoltageInVolts.divides(ResistanceInOhms);
	BarLinearVelocityInMeterPerSecond.matrix[0][0]=new Complex();
	InducedForceInNewton.matrix[0][0]=(VoltageInVolts.times(BarLengthInMagneticFieldInMeter).times(MagneticFluxDensityInTesla)).divides(ResistanceInOhms);
	BarLinearAccelerationInMeterPerSecondPerSecond.matrix[0][0]=InducedForceInNewton.matrix[0][0].divides(BarMassInKilogram);


	int index=0;	
	for (double TimeInSecond=0;TimeInSecond < 0.1 ;TimeInSecond=TimeInSecond+0.001 ) {
		index++;
		BarInducedVoltageInVolts.matrix[0][index]=BarLinearVelocityInMeterPerSecond.matrix[0][index-1].times(MagneticFluxDensityInTesla).times(BarLengthInMagneticFieldInMeter);
		CurrentInAmperes.matrix[0][index]=(VoltageInVolts.minus(BarInducedVoltageInVolts.matrix[0][index-1])).divides(ResistanceInOhms);
		BarLinearAccelerationInMeterPerSecondPerSecond.matrix[0][index]=InducedForceInNewton.matrix[0][index-1].divides(BarMassInKilogram);
		BarLinearVelocityInMeterPerSecond.matrix[0][index]=BarLinearVelocityInMeterPerSecond.matrix[0][index-1].plus(BarLinearAccelerationInMeterPerSecondPerSecond.matrix[0][index-1].scale(0.01));
		InducedForceInNewton.matrix[0][index]=CurrentInAmperes.matrix[0][index-1].times(BarLengthInMagneticFieldInMeter).times(MagneticFluxDensityInTesla);	
	}
	BarLinearVelocityInMeterPerSecond.printMatrixToFile();
}

//Simulate a generator using spinning Rectangular Loop In Uniform Magnetic Field 
public void RectangularLoopInUniformMagneticField(){
	ComplexMatrix AngularVelocityInRadiansPerSecond=zeros(1,3);
	ComplexMatrix MagneticFluxDensityInTesla=zeros(1,3);
	ComplexMatrix LengthInMagneticFieldInMeter=zeros(1,3);
	ComplexMatrix InducedVoltageInTurnInVolts=zeros(1,101);
	double FrequencyOfRotationInHertz=1.0;
	double RadiusOfCoilInMeter=1.0;

	MagneticFluxDensityInTesla.matrix[0][0]=new Complex(-1,0);
	LengthInMagneticFieldInMeter.matrix[0][2]=new Complex(1,0);

	int index=0;	
	for (double TimeInSecond=0;TimeInSecond < 100 ;TimeInSecond=TimeInSecond+1 ) {
		index++;
		AngularVelocityInRadiansPerSecond.matrix[0][0]=new Complex(Math.cos(2*Math.PI*FrequencyOfRotationInHertz*TimeInSecond),0);
		AngularVelocityInRadiansPerSecond.matrix[0][1]=new Complex(Math.sin(2*Math.PI*FrequencyOfRotationInHertz*TimeInSecond),0);
		InducedVoltageInTurnInVolts.matrix[0][index]=((AngularVelocityInRadiansPerSecond.crossProduct(MagneticFluxDensityInTesla)).dotProduct(LengthInMagneticFieldInMeter.transpose())).matrix[0][0].times(new Complex(2.0*RadiusOfCoilInMeter,0));
	}
	InducedVoltageInTurnInVolts.printMatrixToFile();
}

//Simulate a Motor using Rectangular Current Carrying Loop In Uniform Magnetic Field
public void TorqueInducedInRectangularCurrentCarryingLoopInUniformMagneticField(){
	Complex CurrentInAmperes=new Complex(1);
	ComplexMatrix MagneticFluxDensityInTesla = zeros(1,3);
	ComplexMatrix LengthInMagneticFieldInMeter = zeros(1,3);
	ComplexMatrix RadiusVectorOfCoilInMeter = zeros(1,3);
	ComplexMatrix ForceInNewton = zeros(1,3);
	ComplexMatrix AngularTorqueInNewtonMeter=zeros(1,3);
	Complex AngularAccelerationInRadiansPerSecondPerSecond=new Complex();
	Complex AngularVelocityInRadiansPerSecond=new Complex();
	Complex MomentOfInertia=new Complex(1);
	double [][] AngularDisplacementInRadians = new double [1][10001];

	MagneticFluxDensityInTesla.matrix[0][0]=new Complex(1);
	LengthInMagneticFieldInMeter.matrix[0][2]=new Complex(1,0);
	RadiusVectorOfCoilInMeter.matrix[0][0]=new Complex(1,0); 

	//ForceInNewton.printMatrixAsString();
	int index=0;	
	for (double TimeInSecond=0;TimeInSecond < 100 ;TimeInSecond=TimeInSecond+0.01 ) {

		index++;

		ForceInNewton = (LengthInMagneticFieldInMeter.crossProduct(MagneticFluxDensityInTesla)).scale(CurrentInAmperes);
		AngularTorqueInNewtonMeter=RadiusVectorOfCoilInMeter.crossProduct(ForceInNewton);
		
		AngularAccelerationInRadiansPerSecondPerSecond=(AngularTorqueInNewtonMeter.matrix[0][2]).times(MomentOfInertia.reciprocal());
		//System.out.println(AngularAccelerationInRadiansPerSecondPerSecond.toString());
		AngularVelocityInRadiansPerSecond=AngularVelocityInRadiansPerSecond.plus(AngularAccelerationInRadiansPerSecondPerSecond.scale(0.01));
		//System.out.println(AngularVelocityInRadiansPerSecond.toString());
		//AngularDisplacementInRadians[0][index]=(AngularDisplacementInRadians[0][index-1]+(AngularVelocityInRadiansPerSecond.scale(0.01).re()));
		AngularDisplacementInRadians[0][index]=(AngularDisplacementInRadians[0][index-1]+(AngularVelocityInRadiansPerSecond.scale(0.01).re()))%(2*Math.PI);
		if((AngularDisplacementInRadians[0][index]>(0.5*Math.PI))&&(AngularDisplacementInRadians[0][index]<(1.5*Math.PI))){LengthInMagneticFieldInMeter.matrix[0][2]=new Complex(-1,0);}
		else{LengthInMagneticFieldInMeter.matrix[0][2]=new Complex(1,0);}
		RadiusVectorOfCoilInMeter.matrix[0][0]=new Complex(((new Complex()).polarToCartesian(1,AngularDisplacementInRadians[0][index-1])).re(),0);
		RadiusVectorOfCoilInMeter.matrix[0][1]=new Complex(((new Complex()).polarToCartesian(1,AngularDisplacementInRadians[0][index-1])).im(),0);
		
	}
	new ComplexMatrix(AngularDisplacementInRadians,1,10001).printMatrixToFile();
}

//Find coordinates for Bode Plot of Transfer Function
public void TransferFunction(){
	ComplexMatrix xD=zeros(1,101);
	ComplexMatrix yD=zeros(1,101);
	int index=0;
	for (double i=0;i<101 ;i++ ) {
		xD.matrix[0][index]=new Complex(Math.exp(i));
		Complex s = xD.matrix[0][index].times(new Complex(0,2*Math.PI));
		System.out.println(s);
		yD.matrix[0][index]=((new Complex(10000)).plus(s.scale(0.001)).plus(s.scale(0.000000001).reciprocal())).reciprocal().scale(10000);
		yD.matrix[0][0]=new Complex();
		xD.matrix[0][index]=new Complex(Math.log(xD.matrix[0][index].abs()));
		//yD.matrix[0][index]=new Complex(Math.log(yD.matrix[0][index].abs()));
		//System.out.println(yD.matrix[0][index]);
		index++;

	}
	yD.printMatrixToFile();
}

//Get row number row of matrix
public ComplexMatrix getRow(int row){
	ComplexMatrix Row=zeros(1,cols);
	for (int c=0;c<cols ;c++ ) {
		Row.matrix[0][c]=matrix[row][c];
	}
	return Row;
}

//Get column number col of matrix
public ComplexMatrix getColumn(int col){
	return this.transpose().getRow(col).transpose();
}

//get Row Mean of Matrix
public ComplexMatrix RowMean(){
	return this.cummulativeRowSum().scale(new Complex(1/Double.valueOf(cols),0)).getColumn(cols-1);

}

//get Column Mean of Matrix
public ComplexMatrix ColMean(){
	return this.transpose().RowMean().transpose();
}

//computes linear regression parameters matrix b where Xmat.b=Ymat=this
public ComplexMatrix lsqnonneg(ComplexMatrix Xmat){
	return (Xmat.transpose().dotProduct(Xmat).Inverse()).dotProduct(Xmat.transpose()).dotProduct(this);
}

//Two Port Parameters
/*OpenCircuitImpedance=0,0
ShortCircuitAdmittance=1,1
Transmission=2,2
InverseTransmission=3,3
Hybrid=4,4
InverseHybrid=5,5
*/
public ComplexMatrix TwoPortParameters(ComplexMatrix mat,int row, int col){

	ComplexMatrix[][] TwoPortParametersTensor=new ComplexMatrix[6][6];
	for (int r=0;r<6 ;r++ ) {
		for (int c=0;c<6 ;c++ ) {
			TwoPortParametersTensor[r][c]=zeros(2,2);
		}
	}
	ComplexMatrix TwoPortParameters=new ComplexMatrix(TwoPortParametersTensor,6,6);
	TwoPortParameters.tensor[row][col]=mat;

	//OpenCircuitImpedance
	if(row==0){
	}

	//ShortCircuitAdmittance
	if(row==1){
		//OpenCircuitImpedance
		TwoPortParameters.tensor[0][0].matrix[0][0]=TwoPortParameters.tensor[row][col].matrix[1][1].divides(TwoPortParameters.tensor[row][col].det());
		TwoPortParameters.tensor[0][0].matrix[0][1]=TwoPortParameters.tensor[row][col].matrix[0][1].divides(TwoPortParameters.tensor[row][col].det());TwoPortParameters.tensor[0][0].matrix[0][1]=TwoPortParameters.tensor[0][0].matrix[0][1].scale(-1);
		TwoPortParameters.tensor[0][0].matrix[1][0]=TwoPortParameters.tensor[row][col].matrix[1][0].divides(TwoPortParameters.tensor[row][col].det());TwoPortParameters.tensor[0][0].matrix[1][0]=TwoPortParameters.tensor[0][0].matrix[1][0].scale(-1);
		TwoPortParameters.tensor[0][0].matrix[1][1]=TwoPortParameters.tensor[row][col].matrix[0][0].divides(TwoPortParameters.tensor[row][col].det());
	}

	//Transmission
	if(row==2){
		//OpenCircuitImpedance
		TwoPortParameters.tensor[0][0].matrix[0][0]=TwoPortParameters.tensor[row][col].matrix[0][0].divides(TwoPortParameters.tensor[row][col].matrix[1][0]);
		TwoPortParameters.tensor[0][0].matrix[0][1]=TwoPortParameters.tensor[row][col].det().divides(TwoPortParameters.tensor[row][col].matrix[1][0]);
		TwoPortParameters.tensor[0][0].matrix[1][0]=(new Complex(1,0)).divides(TwoPortParameters.tensor[0][0].matrix[1][0]);
		TwoPortParameters.tensor[0][0].matrix[1][1]=TwoPortParameters.tensor[row][col].matrix[1][1].divides(TwoPortParameters.tensor[row][col].matrix[1][0]);
	}

	//InverseTransmission
	if(row==3){
		//OpenCircuitImpedance
		TwoPortParameters.tensor[0][0].matrix[0][0]=TwoPortParameters.tensor[row][col].matrix[1][1].divides(TwoPortParameters.tensor[row][col].matrix[1][0]);
		TwoPortParameters.tensor[0][0].matrix[0][1]=(new Complex(1,0)).divides(TwoPortParameters.tensor[row][col].matrix[1][0]);
		TwoPortParameters.tensor[0][0].matrix[1][0]=TwoPortParameters.tensor[row][col].det().divides(TwoPortParameters.tensor[row][col].matrix[1][0]);
		TwoPortParameters.tensor[0][0].matrix[1][1]=TwoPortParameters.tensor[row][col].matrix[0][0].divides(TwoPortParameters.tensor[row][col].matrix[1][0]);
	}

	//Hybrid
	if(row==4){
		//OpenCircuitImpedance
		TwoPortParameters.tensor[0][0].matrix[0][0]=TwoPortParameters.tensor[row][col].det().divides(TwoPortParameters.tensor[row][col].matrix[1][1]);
		TwoPortParameters.tensor[0][0].matrix[0][1]=TwoPortParameters.tensor[row][col].matrix[0][1].divides(TwoPortParameters.tensor[row][col].matrix[1][1]);
		TwoPortParameters.tensor[0][0].matrix[1][0]=TwoPortParameters.tensor[row][col].matrix[1][0].divides(TwoPortParameters.tensor[row][col].matrix[1][1]);TwoPortParameters.tensor[0][0].matrix[1][0]=TwoPortParameters.tensor[0][0].matrix[1][0].scale(-1);
		TwoPortParameters.tensor[0][0].matrix[1][1]=(new Complex(1,0)).divides(TwoPortParameters.tensor[row][col].matrix[1][1]);
	}
	
	//InverseHybrid
	if(row==5){
		//OpenCircuitImpedance
		TwoPortParameters.tensor[0][0].matrix[0][0]=(new Complex(1,0)).divides(TwoPortParameters.tensor[row][col].matrix[0][0]);
		TwoPortParameters.tensor[0][0].matrix[0][1]=TwoPortParameters.tensor[row][col].matrix[0][1].divides(TwoPortParameters.tensor[row][col].matrix[0][0]);TwoPortParameters.tensor[0][0].matrix[0][1]=TwoPortParameters.tensor[0][0].matrix[1][0].scale(-1);
		TwoPortParameters.tensor[0][0].matrix[1][0]=TwoPortParameters.tensor[row][col].matrix[1][0].divides(TwoPortParameters.tensor[row][col].matrix[0][0]);
		TwoPortParameters.tensor[0][0].matrix[1][1]=TwoPortParameters.tensor[row][col].det().divides(TwoPortParameters.tensor[row][col].matrix[0][0]);
	}
		
	//ShortCircuitAdmittance
	TwoPortParameters.tensor[1][0].matrix[0][0]=TwoPortParameters.tensor[0][0].matrix[1][1].divides(TwoPortParameters.tensor[0][0].det());
	TwoPortParameters.tensor[1][0].matrix[0][1]=TwoPortParameters.tensor[0][0].matrix[0][1].divides(TwoPortParameters.tensor[0][0].det());TwoPortParameters.tensor[1][0].matrix[0][1]=TwoPortParameters.tensor[1][0].matrix[0][1].scale(-1);
	TwoPortParameters.tensor[1][0].matrix[1][0]=TwoPortParameters.tensor[0][0].matrix[1][0].divides(TwoPortParameters.tensor[0][0].det());TwoPortParameters.tensor[1][0].matrix[1][0]=TwoPortParameters.tensor[1][0].matrix[1][0].scale(-1);
	TwoPortParameters.tensor[1][0].matrix[1][1]=TwoPortParameters.tensor[0][0].matrix[0][0].divides(TwoPortParameters.tensor[0][0].det());

	//Transmission
	TwoPortParameters.tensor[2][0].matrix[0][0]=TwoPortParameters.tensor[0][0].matrix[0][0].divides(TwoPortParameters.tensor[0][0].matrix[1][0]);
	TwoPortParameters.tensor[2][0].matrix[0][1]=TwoPortParameters.tensor[0][0].det().divides(TwoPortParameters.tensor[0][0].matrix[1][0]);
	TwoPortParameters.tensor[2][0].matrix[1][0]=(new Complex(1,0)).divides(TwoPortParameters.tensor[0][0].matrix[1][0]);
	TwoPortParameters.tensor[2][0].matrix[1][1]=TwoPortParameters.tensor[0][0].matrix[1][1].divides(TwoPortParameters.tensor[0][0].matrix[1][0]);

	//InverseTransmission
	TwoPortParameters.tensor[3][0].matrix[0][0]=TwoPortParameters.tensor[0][0].matrix[1][1].divides(TwoPortParameters.tensor[0][0].matrix[0][1]);
	TwoPortParameters.tensor[3][0].matrix[0][1]=TwoPortParameters.tensor[0][0].det().divides(TwoPortParameters.tensor[0][0].matrix[0][1]);
	TwoPortParameters.tensor[3][0].matrix[1][0]=(new Complex(1,0)).divides(TwoPortParameters.tensor[0][0].matrix[0][1]);
	TwoPortParameters.tensor[3][0].matrix[1][1]=TwoPortParameters.tensor[0][0].matrix[0][0].divides(TwoPortParameters.tensor[0][0].matrix[0][1]);

	//Hybrid
	TwoPortParameters.tensor[4][0].matrix[0][0]=TwoPortParameters.tensor[0][0].det().divides(TwoPortParameters.tensor[0][0].matrix[1][1]);
	TwoPortParameters.tensor[4][0].matrix[0][1]=TwoPortParameters.tensor[0][0].matrix[0][1].divides(TwoPortParameters.tensor[0][0].matrix[1][1]);
	TwoPortParameters.tensor[4][0].matrix[1][0]=TwoPortParameters.tensor[0][0].matrix[1][0].divides(TwoPortParameters.tensor[0][0].matrix[1][1]);TwoPortParameters.tensor[4][0].matrix[1][0]=TwoPortParameters.tensor[4][0].matrix[1][0].scale(-1);
	TwoPortParameters.tensor[4][0].matrix[1][1]=(new Complex(1,0)).divides(TwoPortParameters.tensor[0][0].matrix[1][1]);

	//InverseHybrid
	TwoPortParameters.tensor[5][0].matrix[0][0]=(new Complex(1,0)).divides(TwoPortParameters.tensor[0][0].matrix[0][0]);
	TwoPortParameters.tensor[5][0].matrix[0][1]=TwoPortParameters.tensor[0][0].matrix[0][1].divides(TwoPortParameters.tensor[0][0].matrix[0][0]);TwoPortParameters.tensor[5][0].matrix[0][1]=TwoPortParameters.tensor[5][0].matrix[1][0].scale(-1);
	TwoPortParameters.tensor[5][0].matrix[1][0]=TwoPortParameters.tensor[0][0].matrix[1][0].divides(TwoPortParameters.tensor[0][0].matrix[0][0]);
	TwoPortParameters.tensor[5][0].matrix[1][1]=TwoPortParameters.tensor[0][0].det().divides(TwoPortParameters.tensor[0][0].matrix[0][0]);

	if(TwoPortParameters.tensor[0][0].matrix[0][1].equals(TwoPortParameters.tensor[0][0].matrix[1][0])){System.out.println("Passive Network");}
	if(TwoPortParameters.tensor[1][0].matrix[0][1].equals(TwoPortParameters.tensor[1][0].matrix[1][0])){System.out.println("Passive Network");}
	if(TwoPortParameters.tensor[2][0].matrix[0][1].minus(TwoPortParameters.tensor[2][0].matrix[1][0]).equals(new Complex(1,0))){System.out.println("Passive Network");}
	if(TwoPortParameters.tensor[3][0].matrix[0][1].minus(TwoPortParameters.tensor[3][0].matrix[1][0]).equals(new Complex(1,0))){System.out.println("Passive Network");}
	if(TwoPortParameters.tensor[4][0].matrix[0][1].equals(TwoPortParameters.tensor[4][0].matrix[1][0].scale(-1))){System.out.println("Passive Network");}
	if(TwoPortParameters.tensor[5][0].matrix[0][1].equals(TwoPortParameters.tensor[5][0].matrix[1][0].scale(-1))){System.out.println("Passive Network");}	

	if(TwoPortParameters.tensor[0][0].matrix[0][0].equals(TwoPortParameters.tensor[0][0].matrix[1][1])){System.out.println("Symmetric Network");}
	if(TwoPortParameters.tensor[1][0].matrix[0][0].equals(TwoPortParameters.tensor[1][0].matrix[1][1])){System.out.println("Symmetric Network");}
	if(TwoPortParameters.tensor[2][0].matrix[0][0].equals(TwoPortParameters.tensor[2][0].matrix[1][1])){System.out.println("Symmetric Network");}
	if(TwoPortParameters.tensor[3][0].matrix[0][0].equals(TwoPortParameters.tensor[3][0].matrix[1][1])){System.out.println("Symmetric Network");}
	if(TwoPortParameters.tensor[4][0].det().equals(new Complex(1,0))){System.out.println("Symmetric Network");}
	if(TwoPortParameters.tensor[5][0].det().equals(new Complex(1,0))){System.out.println("Symmetric Network");}
	
	return TwoPortParameters;
}

//Find minimum value of function on domain x using derivative descent method
public Complex fminbnd(ComplexMatrix x){
	Complex min= matrix[0][0];
	Complex x0=x.matrix[0][0];
	Complex x1=x.matrix[0][0];
	Complex temp=x.matrix[0][0];
	for (int i=1;i<cols;i++){
		Complex der=(PolyVal(x.matrix[0][i]).minus(PolyVal(x.matrix[0][i-1]))).divides(x.matrix[0][i].minus(x.matrix[0][i-1]));
		temp=x1;
		x1=x0.minus(der);
		x0=temp;
		min=PolyVal(x1);
	}
	return min;
}

//Polynomial Integration on domain x
public Complex PolyInt(ComplexMatrix x){
	Complex sum=new Complex();
	for (int i=1;i<cols ;i++ ) {
		sum=sum.plus((new Complex(0.5,0)).times(PolyVal(x.matrix[0][i]).plus(PolyVal(x.matrix[0][i-1]))).times(x.matrix[0][i].minus(x.matrix[0][i-1])));
	}
	return sum;
}

//Polynomial derivative on domain x
public ComplexMatrix PolyDer(ComplexMatrix x){
	ComplexMatrix der=zeros(1,cols);
	for (int i=1;i<cols ;i++ ) {
		der.matrix[0][i]=(PolyVal(x.matrix[0][i]).minus(PolyVal(x.matrix[0][i-1]))).divides(x.matrix[0][i].minus(x.matrix[0][i-1]));
	}
	return der;
}

//Sine with domain x
public ComplexMatrix Sine(ComplexMatrix x){
	ComplexMatrix sine=zeros(1,cols);
	for (int i=0;i<cols ;i++ ) {
		//System.out.println(i);
		sine.matrix[0][i]=(x.matrix[0][i]).sin();
	}
	return sine;
}

//Cosine with domain x
public ComplexMatrix Cosine(ComplexMatrix x){
	ComplexMatrix cosine=zeros(1,cols);
	for (int i=0;i<cols ;i++ ) {
		cosine.matrix[0][i]=(x.matrix[0][i]).cos();
	}
	return cosine;
}

//Tan with domain x
public ComplexMatrix Tan(ComplexMatrix x){
	ComplexMatrix tan=zeros(1,cols);
	for (int i=0;i<cols ;i++ ) {
		tan.matrix[0][i]=(x.matrix[0][i]).tan();
	}
	return tan;
}

//Fourier Transform of function. The result is matrix of 100 A and B fourier coefficients. x=2pift. f(x)=A_ncos(nt)+B_nsin(nt). C_0=(A0+B0)/2
public ComplexMatrix fft(ComplexMatrix x){
	ComplexMatrix Acoefficients=zeros(1,100);
	ComplexMatrix Bcoefficients=zeros(1,100);
	//System.out.println(trapz(x));
	Complex [][] mat=zeros(rows,cols).matrix;
	for (int i=0;i<100 ;i++ ) {
		mat=this.dotmultiply(Sine(x.scale(new Complex(i,0)))).matrix;
		Bcoefficients.matrix[0][i]=(new Complex(1/Math.PI,0)).times((new ComplexMatrix(mat,rows,cols)).trapz(x));
	}
	for (int i=0;i<100 ;i++ ) {
		mat=this.dotmultiply(Cosine(x.scale(new Complex(i,0)))).matrix;
		Acoefficients.matrix[0][i]=(new Complex(1/Math.PI,0)).times((new ComplexMatrix(mat,rows,cols)).trapz(x));
	}
	//Acoefficients.printMatrixAsString();
	//Bcoefficients.printMatrixAsString();
	ComplexMatrix[][] coefficients=new ComplexMatrix[1][2];
	coefficients[0][0]=Acoefficients;
	coefficients[0][1]=Bcoefficients;
	return new ComplexMatrix(coefficients,1,2);
}

//returns regression function for this matrix on domain Xmat
public ComplexMatrix ExactRegression(ComplexMatrix Xmat){
	int xlength=1000;
	double Xlength=1000;
	double xmin=0.0;
	double xstep=0.01;
	double xmax=10;
	ComplexMatrix RegressionFunction=zeros(1,xlength+1);
	Complex Product=new Complex(1,0);
	Complex Sum=new Complex();

	for (double x=xmin;x<=xmax ;x=x+xstep ) {
		for (int i=0;i<cols ;i++ ) {
			for (int j=0;j<cols ;j++ ) {
				if(j!=i){
					
					Product=Product.scale(((new Complex(x)).minus(Xmat.matrix[0][j])).abs());
				}
			}
			Sum=Sum.plus((Product.power(((new Complex(x)).minus(Xmat.matrix[0][i])).abs())).times(matrix[0][i]));
			Product=new Complex(1,0);
		}
		RegressionFunction.matrix[0][(int)(x*(Xlength/(xmax-xmin)))]=Sum;
		//System.out.println(Sum.toString());
		Sum=new Complex();	
	}

	RegressionFunction.printMatrixToFile();
	return RegressionFunction;

}

public static void main(String[] args) {
    Complex [][] m1 =new Complex[1][11];
    Complex [][] m2 =new Complex[1][11];
    int index=0;
    for (double i=0;i<=10 ;i=i+1 ) {
    m1[0][index] = new Complex(i,0);
    m2[0][index] = new Complex(2*i,0);
    index=index+1;
    }
    
	ComplexMatrix mat1=new ComplexMatrix(m1,1,index);
	ComplexMatrix mat2=new ComplexMatrix(m2,1,index);
	//mat1.linearDCMachine(new Complex(10.0,0),new Complex(0.1,0),new Complex(0.5,0),new Complex(0.5,0),new Complex(0.1,0));
	//mat1.TransferFunction();
	//mat2.lsqnonneg(mat1).printMatrixAsString();
	//mat1.Cosine(mat1).fft(mat2).printMatrixAsString();
	//mat2.ExactRegression(mat1);
    }
}