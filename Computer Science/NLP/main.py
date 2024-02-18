from ClassificationModule import *
from PreprocessingModule import *
from TrainingModule import *
from EDAModule import *
from IOModule import *
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.multiclass import OneVsRestClassifier
from sklearn.linear_model import SGDClassifier
from sklearn.linear_model import Perceptron
from nltk.stem import WordNetLemmatizer
from sklearn.svm import LinearSVC
from nltk.corpus import stopwords
from  tkinter import *
import tkinter as tk
import nltk

train_df = {}
X_dtm =  {}
vect = TfidfVectorizer(max_features=10000,stop_words='english')
wnl = WordNetLemmatizer()
nltk.download("stopwords")
nltk.download("wordnet")

# Initialize the models
logRegModel = OneVsRestClassifier(LogisticRegression(tol=0.000001,max_iter=10000))
logRegModelParams = {}
linearSVCModel = OneVsRestClassifier(LinearSVC(dual='auto',tol=0.000001,max_iter=10000))
linearSVCModelParams = {
	'estimator': [
		LinearSVC(dual='auto',tol=0.000001,max_iter=10000,random_state=1),
		LinearSVC(dual='auto',tol=0.000001,max_iter=100000,random_state=43)
	]
}
perceptronModel = OneVsRestClassifier(Perceptron(tol=0.000001,max_iter=10000))
perceptronModelParams = {}
SGDCModel = OneVsRestClassifier(SGDClassifier(tol=0.000001,max_iter=10000))
SGDCModelParams = {}
modelNames=['Logistic Regression','Linear SVC','Linear Perceptron','Stochastic Gradient Descent']
models = [logRegModel,linearSVCModel,perceptronModel,SGDCModel]
modelParams = [logRegModelParams,linearSVCModelParams,perceptronModelParams,SGDCModelParams]
fileNames=['Logistic_Regression_model','Linear_SVC_model','perceptron_model','SGDC_model']

# Top level frame
frame = tk.Tk()
frame.config(bg="skyblue")
frame.title("NLP Project")
frame.geometry('800x500')

# Create sidebar frame
sidebar_frame = Frame(frame, width=200, height=800, bg='white')
sidebar_frame.grid(row=0, column=0, padx=10, pady=5, sticky='nw')
Label(sidebar_frame, text="NLP Project", font='bold', bg='white').grid(row=0, column=0, padx=5, pady=5)
image = PhotoImage(file="VU.PNG")
original_image = image.subsample(6,6) 
Label(sidebar_frame, image=original_image).grid(row=1, column=0, padx=5, pady=5)
tool_bar = Frame(sidebar_frame, width=180, height=185, bg='white')
tool_bar.grid(row=2, column=0, padx=5, pady=5, sticky='n')
frameNames = ['Import Data','Perform EDA','Preprocess Data','Train Models','Classify']
frames = {}
buttons = {}

def showFrame(frameName):
	for f in frameNames:
		frames[f].grid_forget()
	for f in frameNames:
		buttons[f].configure(background='white')
	buttons[frameName].configure(background='lightblue')
	frames[frameName].grid(row=0, column=1, padx=10, pady=5, sticky='nw')

# Buttons that serve as placeholders for other widgets
i = 0
for f in frameNames:
	buttons[f] = tk.Button(tool_bar, text = f, background='white', width=15, height=3)
	buttons[f].grid(row=i, column=0, padx=5, pady=3, ipadx=10)
	i = i + 1
buttons['Import Data'].configure(command=lambda:showFrame('Import Data'))
buttons['Perform EDA'].configure(command=lambda:showFrame('Perform EDA'))
buttons['Preprocess Data'].configure(command=lambda:showFrame('Preprocess Data'))
buttons['Train Models'].configure(command=lambda:showFrame('Train Models'))
buttons['Classify'].configure(command=lambda:showFrame('Classify'))

# Import data frame
def importTrainingData():
	global train_df
	global importButton
	importButton.grid_forget()
	train_df = importData(Data_table)
importButton, Data_table = initImportFrame(frame,frames)
importButton.configure(command=importTrainingData)

# EDA Frame
def performEDA():
	global train_df
	global EDAButton
	global NextButton
	performExploratoryDataAnalysis(train_df,plot1,fig,EDA_frame,plotNumber)
	EDAButton.grid_forget()
	NextButton.grid(row=2,column=0, padx=5, pady=5)
def nextPlot():
	global plotNumber
	plotNumber = (plotNumber + 1)%4
	performEDA()
EDAButton, NextButton, fig, plot1, EDA_frame = initEDAFrame(frame,frames)
plotNumber = 0
EDAButton.configure(command = performEDA)
NextButton.configure(command = nextPlot)

# Preprocessing Frame
def preprocessTrainingData():
	global train_df
	global vect
	global X_dtm
	sw=stopwords.words('english')
	train_df,vect,X_dtm = preprocessData(train_df,sw,preprocessingTable,wnl,vect)
	preprocessButton.grid_forget()
preprocessButton, preprocessingTable = initPreprocessingFrame(frame,frames)
preprocessButton.configure(command = preprocessTrainingData)

# Training frame
def performTraining():
	global models
	global X_dtm
	trainAndTestModels(models,modelParams,modelNames,Training_table,train_df,X_dtm)
	trainButton.grid_forget()
	SaveButton.grid(row=1,column=0, padx=5, pady=5)
def saveModels():
	saveTrainedModels(fileNames,models)
	SaveButton.grid_forget()
trainButton, SaveButton, Training_table, Training_frame = initTrainingFrame(frame,frames,modelNames)
trainButton.configure(command = performTraining)
SaveButton.configure(command = saveModels)

# Classification frame
def loadModels():
	global models
	loadTrainedModels(fileNames,models)
	ImportButton.grid_forget()
	loadRandomInputButton.grid(row=0,column=1, padx=5, pady=5)
	classifyButton.grid(row=3,column=1, padx=5, pady=5)
def loadRandomInput():
	testData = pd.read_csv('./Data/test.csv')
	print('Test data imported successfully')
	i=np.random.randint(0,testData.shape[0]) 
	for ind,item in testData.iterrows():
		if ind==i:
			inputtxtTitle.delete(1.0, tk.END)
			inputtxtTitle.insert(tk.END,item['TITLE'])
			inputtxtAbstract.delete(1.0, tk.END)
			inputtxtAbstract.insert(tk.END,item['ABSTRACT'])
def classifyInput():
	sw=stopwords.words('english')
	classifyResearchArticle(inputtxtTitle,inputtxtAbstract,vect,classificationTable,models,modelNames,sw,wnl)
Classify_frame, inputtxtTitle, inputtxtAbstract, ImportButton, loadRandomInputButton, classifyButton, classificationTable = initClassificationFrame(frame, frames, modelNames)
ImportButton.configure(command = loadModels)
loadRandomInputButton.configure(command = loadRandomInput)
classifyButton.configure(command = classifyInput)

showFrame('Import Data')

frame.mainloop()