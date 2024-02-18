from sklearn.model_selection import train_test_split
from sklearn.model_selection import GridSearchCV
from sklearn.metrics import accuracy_score
from  tkinter import ttk
from  tkinter import *
import tkinter as tk
import numpy as np
import time

def initTrainingFrame(frame,frames,modelNames):
    Training_frame = Frame(frame, width=650, height=400, padx=15, pady=15, bg='white')
    frames['Train Models']=Training_frame
    #lbl = tk.Label(Training_frame, text = "Training of NLP Models").grid(row=0,column=0, padx=5, pady=5)
    trainButton = tk.Button(Training_frame, text = "Train Models")
    trainButton.grid(row=1,column=0, padx=5, pady=5)
    SaveButton = tk.Button(Training_frame, text = "Save Models")
    Training_table = ttk.Treeview(Training_frame, height=18)
    Training_table['columns']= ('Model', 'Testing Accuracy')
    Training_table.column("#0", width=0)
    Training_table.column("Model", width=280)
    Training_table.column("Testing Accuracy", width=280)
    Training_table.heading("Model",text="Model",anchor='w')
    Training_table.heading("Testing Accuracy",text="Testing Accuracy",anchor='w')
    Training_table.grid(row=2,column=0, padx=5, pady=5)
    i=0
    for modelName in modelNames:
        Training_table.insert(parent='',index='end',iid=i,text='',values=(modelName,''))
        i=i+1
    return trainButton, SaveButton, Training_table, Training_frame

def trainAndTestModels(models,params,modelNames,Training_table,train_df,X_dtm):
    index = 0
    i=0
    y = np.asarray(train_df[train_df.columns[3:9]])
    #print(y)
    X_train, X_test, y_train, y_test = train_test_split(X_dtm, y, test_size=0.2, random_state=0)

    for model in models:
        start = time.time()
        grid_search = GridSearchCV(model, params[i], cv=5, scoring='accuracy')
        grid_search.fit(X_train, y_train)
        best_model = grid_search.best_estimator_
        models[i] = best_model
        y_pred_X = best_model.predict(X_test)
        
        end= time.time()
        print('Training completed for ' + modelNames[index])
        print('Time elapsed: '+str(end-start)+'s')
        print('Testing Accuracy is {}'.format(accuracy_score(y_test,y_pred_X)))
        print('')
        index = index + 1
        Training_table.delete(i)
        Training_table.insert(parent='',index='end',iid=i,text='',values=(modelNames[i],accuracy_score(y_test,y_pred_X)*100))
        i=i+1
    print('Training and testing completed successfully')