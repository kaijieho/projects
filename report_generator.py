#This allows for users to generate a report
#Main report has all columns
#Template report has the columns that I wish to extract data from
#Copy and paste data from main report to template report only for same column headers
#Users can filter columns data 

import os
import pandas as pd
from tkinter import Tk, filedialog

def browse_file():
    Tk().withdraw() #hide main window
    file_path = filedialog.askopenfilename() #show file dialog
    return file_path

#same as browse_file but for folder
def browse_folder():
    Tk().withdraw() #hide main window
    folder_path = filedialog.askdirectory() #show file dialog
    return folder_path

#get user inputs for both file paths
print("Select the first Excel file: ")
file_path1 = browse_file()

print("Select the second Excel file: ")
file_path2 = browse_file()

#get save location using OS package
print("Seletct the folder for the output Excel file: ")
output_folder = browse_folder()
output_path = os.path.join(output_folder, "report.xlsx")

#read both files into a dataframe
df1 = pd.read_excel(file_path1)
df2 = pd.read_excel(file_path2)

#find common column headers in both dataframes
common_columns = set(df1.columns) & set(df2.columns)

#loop to copy df1 to df2
for column in common_columns:
    df2[column] = df1[column]

#input name of column to filter
chosen_column = input("Enter the name of the column to filter: ")
if chosen_column != '':
    

    #input filter value
    filter_value = input("Enter the filter value: ")

    #copy and paste data from df1 to df2 for same columns with filtering
    df2.loc[df1[chosen_column]==filter_value, chosen_column] = df1[df1[chosen_column] == filter_value][chosen_column]
    df2[chosen_column] = df1[df1[chosen_column] == filter_value][chosen_column]
    
    #remove rows with empty data from filtered column as there will be empty values in the filtered column as the unwanted values are gone in the column but not the row
    df2 = df2.dropna(subset=[chosen_column])
    
    #save the updated df2 to a new excel file
    df2.to_excel(output_path, index=False)

else:
    #save the updated df2 to a new excel file
    df2.to_excel(output_path, index=False)

print("Report generated to:", output_path)
