import pandas as pd
import pickle
import tkinter as tk
from  tkinter import ttk
from  tkinter import *

# Import data
def importData(Data_table):
    data = pd.read_csv('./Data/train.csv')
    print('Data imported successfully')
    i=0 
    for ind,item in data.iterrows():
        Data_table.insert(parent='',index='end',iid=i,text='',values=(item['ID'],item['TITLE'],item['ABSTRACT'][:20],item['Computer Science'],item['Physics'],item['Mathematics'],item['Statistics'],item['Quantitative Biology'],item['Quantitative Finance']))
        i = i + 1
    return data

def initImportFrame(frame,frames):
    Import_data_frame = Frame(frame, width=650, height=400, padx=15, pady=15, bg='white')
    frames['Import Data']=Import_data_frame
    #tk.Label(Import_data_frame, text = "Import dataset").grid(row=0,column=0, padx=5, pady=5)
    importButton = tk.Button(Import_data_frame, text = "Import training data", command = lambda:importData(Data_table))
    importButton.grid(row=1,column=0, padx=5, pady=5)
    Data_table = ttk.Treeview(Import_data_frame, height=18)
    Data_table['columns']= ('ID','Title', 'Abstract','Computer Science','Physics','Mathematics','Statistics','Quantitative Biology','Quantitative Finance')
    widths = [0,150,150,40,40,40,40,40,40]
    titles = ["ID","Title","Abstract","Computer Science","Physics","Mathematics","Statistics","Quantitative Biology","Quantitative Finance"]
    labels = ["ID","Title","Abstract","CS","PHY","MTH","STAT","QB","QF"]
    Data_table.column("#0", width=0)
    for i in range(0,9):
        Data_table.column(titles[i],width=widths[i])
        Data_table.heading(titles[i],text=labels[i],anchor='w')
    Data_table.grid(row=2,column=0, padx=5, pady=5)
    return importButton, Data_table

# Save the models
def saveTrainedModels(fileNames,models):
    index = 0
    for model in models:
        filename = './Models/'+fileNames[index]+'.sav'
        pickle.dump(model, open(filename, 'wb'))
        index = index + 1
    print('Saving completed')

# load the models
def loadTrainedModels(fileNames,models):
    index = 0
    for model in models:
        filename = './Models/'+fileNames[index]+'.sav'
        models[index] = pickle.load(open(filename, 'rb'))
        index = index + 1 
    print('Loading completed')