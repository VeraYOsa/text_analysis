#Importing libraries
import pandas as pd
import os
import glob
# import numpy as np

#Variables set up
input_folder = (r'C:\Users\inesr\OneDrive\Documentos\El Descanso\\')
input_folder = (r'C:\Users\inesr\OneDrive\Documentos\Gapminder_data_project\\')
# input_files = glob.glob(os.path.join(input_folder, "*.csv"))
# extension = 'pdf'
os.chdir(input_folder)
input_files = glob.glob('*.pdf')
# output_folder = (r'C:\Users\inesr\OneDrive\Documentos\Gapminder_data_project\output\\')
# output_file = 'gapminder_data.csv'

# importing all the required modules
import PyPDF2
# creating an object 
file = open('sabina.pdf', 'rb')

# creating a pdf reader object
fileReader = PyPDF2.PdfFileReader(file)

# print the number of pages in pdf file
print(fileReader.numPages)



pdfFileObject = open('obama.pdf', 'rb')
pdfReader = PyPDF2.PdfFileReader(pdfFileObject)
count = pdfReader.numPages
for i in range(count):
    page = pdfReader.getPage(i)
    print(page.extractText())
    
 # creating a pdf file object
pdfFileObj = open('obama.pdf', 'rb')

# creating a pdf reader object
pdfReader = PyPDF2.PdfFileReader(pdfFileObj)

# printing number of pages in pdf file
print(pdfReader.numPages)

# creating a page object
pageObj = pdfReader.getPage(5)

# extracting text from page
print(pageObj.extractText())

# closing the pdf file object
pdfFileObj.close()
