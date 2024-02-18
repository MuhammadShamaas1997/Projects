from PreprocessingModule import clean
from  tkinter import ttk
from  tkinter import *
import tkinter as tk

def initClassificationFrame(frame, frames, modelNames):
    Classify_frame = Frame(frame, width=650, height=400, padx=15, pady=15, bg='white')
    frames['Classify']=Classify_frame
    lbl = tk.Label(Classify_frame, text = "Title:", bg='white')
    lbl.grid(row=1,column=0, padx=5, pady=5)
    inputtxtTitle = tk.Text(Classify_frame, height = 2, width = 60)
    inputtxtTitle.grid(row=1,column=1, padx=5, pady=5)
    lbl = tk.Label(Classify_frame, text = "Abstract:", bg='white')
    lbl.grid(row=2,column=0, padx=5, pady=5)
    inputtxtAbstract = tk.Text(Classify_frame, height = 5, width = 60)
    inputtxtAbstract.grid(row=2,column=1, padx=5, pady=5)
    ImportButton = tk.Button(Classify_frame, text = "Import Models")
    ImportButton.grid(row=3,column=1, padx=5, pady=5)
    classifyButton = tk.Button(Classify_frame, text = "Classify")
    loadRandomInputButton = tk.Button(Classify_frame, text = "Load Random Input")
    lbl = tk.Label(Classify_frame, text = "Results:", bg='white').grid(row=4,column=0, padx=5, pady=5)
    classificationTable = ttk.Treeview(Classify_frame)
    classificationTable['columns']= ('Model', 'Classification result')
    classificationTable.column("#0", width=0)
    classificationTable.column("Model",width=240)
    classificationTable.column("Classification result",width=240)
    classificationTable.heading("Model",text="Model",anchor='w')
    classificationTable.heading("Classification result",text="Categories",anchor='w')
    classificationTable.grid(row=4,column=1, padx=5, pady=5)
    i=0
    for modelName in modelNames:
        classificationTable.insert(parent='',index='end',iid=i,text='',values=(modelName,''))
        i=i+1
    return Classify_frame, inputtxtTitle, inputtxtAbstract, ImportButton, loadRandomInputButton, classifyButton, classificationTable

def getCategory(res):
    ans = ''
    res=list(res[0])
    if (res[0]==1):
        ans=ans+'Computer Science,'
    if (res[1]==1):
        ans=ans+'Physics,'
    if (res[2]==1):
        ans=ans+'Mathematics,'
    if (res[3]==1):
        ans=ans+'Statistics,'
    if (res[4]==1):
        ans=ans+'Quantitative Biology,'
    if (res[5]==1):
        ans=ans+'Quantitative Finance,'
    return ans[:-1]

# Function for classifying research article based on input data
def classifyResearchArticle(inputtxtTitle,inputtxtAbstract,vect,classificationTable,models,modelNames,sw,wnl):
    inp = clean(inputtxtTitle.get(1.0, "end-1c")+' '+inputtxtAbstract.get(1.0, "end-1c"),sw,wnl)
    X_dtm = vect.transform([inp])
    i=0
    for model in models:
        classificationTable.delete(i)
        y_pred_X = model.predict(X_dtm)
        classificationTable.insert(parent='',index='end',iid=i,text='',values=(modelNames[i],getCategory(y_pred_X)))
        i=i+1
    print('Classification completed successfully')