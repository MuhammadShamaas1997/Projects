from  tkinter import ttk
from  tkinter import *
import tkinter as tk
import re

def initPreprocessingFrame(frame, frames):
    Preprocess_data_frame = Frame(frame, width=850, height=400, padx=15, pady=15, bg='white')
    frames['Preprocess Data']=Preprocess_data_frame
    preprocessButton = tk.Button(Preprocess_data_frame, text = "Preprocess data")
    preprocessButton.grid(row=1,column=0, padx=5, pady=5)
    preprocessingTable = ttk.Treeview(Preprocess_data_frame, height=18)
    preprocessingTable['columns']= ('Step', 'Status')
    preprocessingTable.column("#0", width=0)
    preprocessingTable.column("Step",width=280)
    preprocessingTable.column("Status",width=280)
    preprocessingTable.heading("Step",text="Step",anchor='w')
    preprocessingTable.heading("Status",text="Status",anchor='w')
    preprocessingTable.grid(row=2,column=0, padx=5, pady=5)
    stepNames = ['Remove punctuation', 'Remove special characters', 'Remove stop words', 'Lemmatization', 'Remove small words (length < 4)','Tokenization']
    i=0
    for stepName in stepNames:
        preprocessingTable.insert(parent='',index='end',iid=i,text='',values=(stepName,''))
        i=i+1
    return preprocessButton, preprocessingTable

def clean(text,sw,wnl):
    text = re.findall("[a-zA-Z]+", text)
    text = [w for w in text if not w in sw]
    i=0
    for com in text:
        text[i] = wnl.lemmatize(com)
        i=i+1
    text = [w for w in text if not len(w)<4]
    text = ' '.join(text)
    text = text.lower()
    return text


def appendZeros(s):
    while (len(s)<6):
        s='0'+s
    return s

def preprocessData(train_df,sw, preprocessingTable,wnl,vect):
    cols_target = ['Computer Science','Physics','Mathematics','Statistics','Quantitative Biology','Quantitative Finance']
    train_df['ABSTRACT'] = train_df['TITLE']+' '+train_df['ABSTRACT']
    #print(train_df['ABSTRACT'][0])
    
    train_df['ABSTRACT'] = train_df['ABSTRACT'].map(lambda com : clean(com,sw,wnl))
    #print(train_df['ABSTRACT'][0])
    train_df['char_length'] = train_df['ABSTRACT'].apply(lambda x: len(str(x)))
    train_df = train_df.drop('char_length',axis=1)
    codes = {};
    weight = 1;
    for label in cols_target:
        train_df['composite'] = train_df[label].map(lambda a: 0)
    for label in cols_target:
        codes[label] = weight
        weight = weight * 10
        train_df['composite'] =  train_df['composite'] + train_df[label].map(lambda a: a*codes[label])
    train_df['composite'] = train_df['composite'].map(lambda a:(appendZeros(str(a))))
    X_dtm = vect.fit_transform(train_df.ABSTRACT)
    tfidf_feature_names = vect.get_feature_names_out()
    #print(tfidf_feature_names)
    stepNames = ['Remove punctuation', 'Remove special characters', 'Remove stop words', 'Lemmatization', 'Remove small words (length < 4)','Tokenization']
    i=0
    for stepName in stepNames:
        preprocessingTable.delete(i)
        preprocessingTable.insert(parent='',index='end',iid=i,text='',values=(stepName,'Completed'))
        i=i+1

    print('Preprocessing completed successfully')
    return train_df, vect, X_dtm
