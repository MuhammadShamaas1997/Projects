from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg
from matplotlib.figure import Figure
import seaborn as sns
from matplotlib import pyplot as plt
import tkinter as tk
from  tkinter import ttk
from  tkinter import *


def initEDAFrame(frame, frames):
    EDA_frame = Frame(frame, width=650, height=400, pady=15, bg='white')
    frames['Perform EDA']=EDA_frame
    #lbl = tk.Label(EDA_frame, text = "Exploratory Data Analysis").grid(row=0,column=0, padx=5, pady=5)
    EDAButton = tk.Button(EDA_frame, text = "Perform EDA")
    EDAButton.grid(row=1,column=0, padx=5, pady=5)
    NextButton = tk.Button(EDA_frame, text = "Next")
    fig = Figure(figsize = (6, 4))
    plot1 = fig.add_subplot(111)
    canvas = FigureCanvasTkAgg(fig,master = EDA_frame)  
    canvas.draw()
    canvas.get_tk_widget().grid(row=3,column=0, padx=5, pady=5)
    return EDAButton, NextButton, fig, plot1, EDA_frame

def performExploratoryDataAnalysis(train_df,plot1,fig,EDA_frame,plotNumber):
    fig = Figure(figsize = (6, 4))
    plot1 = fig.add_subplot(111)
    canvas = FigureCanvasTkAgg(fig,master = EDA_frame)  
    canvas.draw()
    canvas.get_tk_widget().grid(row=3,column=0, padx=5, pady=5)

    if (plotNumber==0):
        train_df['char_length'] = train_df['ABSTRACT'].apply(lambda x: len(str(x)))
        plot1.hist(train_df['char_length'])
        plot1.set_title('Distribution of abstract length for training data')
        plot1.set_xlabel('Length')
        plot1.set_ylabel('Frequency')
        canvas = FigureCanvasTkAgg(fig, master = EDA_frame) 
        canvas.draw()
        canvas.get_tk_widget().grid(row=3,column=0, padx=5, pady=5)
    if (plotNumber==1):
        train_df['char_length'] = train_df['TITLE'].apply(lambda x: len(str(x)))
        plot1.hist(train_df['char_length'])
        plot1.set_title('Distribution of title length for training data')
        plot1.set_xlabel('Length')
        plot1.set_ylabel('Frequency')
        canvas = FigureCanvasTkAgg(fig, master = EDA_frame)  
        canvas.draw()
        canvas.get_tk_widget().grid(row=3,column=0, padx=5, pady=5)
    if (plotNumber==2):
        cols_target = ['Computer Science','Physics','Mathematics','Statistics','Quantitative Biology','Quantitative Finance']
        data = train_df[cols_target]
        colormap = plt.cm.plasma
        plt.title('Correlation of categories')
        plt.figure(figsize=(6, 4))
        plt.axes().set_title('Correlation of categories')
        figh=sns.heatmap(data.astype(float).corr(),xticklabels=['CS','PHY','MTH','STAT','QB','QF'],yticklabels=['CS','PHY','MTH','STAT','QB','QF'],linewidths=0.1,vmax=1.0,square=True,cmap=colormap,linecolor='white',annot=True)
        canvas = FigureCanvasTkAgg(figh.get_figure(), master = EDA_frame)
        canvas.draw()
        canvas.get_tk_widget().grid(row=3,column=0, padx=5, pady=5)
    if (plotNumber==3):
        col_names = ['CS','PHY','MTH','STAT','QB','QF']
        cols_target = ['Computer Science','Physics','Mathematics','Statistics','Quantitative Biology','Quantitative Finance']
        counts = [0,0,0,0,0,0]
        i=0
        for category in cols_target:
            counts[i] = sum(train_df[category])
            i=i+1
        figh=plot1.bar(col_names,counts)
        plot1.set_title('Number of articles of different categories')
        plot1.set_xlabel('Category')
        plot1.set_ylabel('Frequency')
        canvas = FigureCanvasTkAgg(fig, master = EDA_frame)
        canvas.draw()
        canvas.get_tk_widget().grid(row=3,column=0, padx=5, pady=5)    
    print('EDA performed successfully')