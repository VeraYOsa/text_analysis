# Import modules 
from wordcloud import WordCloud
import matplotlib.pyplot as plt
import imageio

# Generate the object and read the file (it is recommended to find a PDF with fewer pages first)
pdfFileObject = open('obama.pdf', 'rb')
pdfReader = PyPDF2.PdfFileReader(pdfFileObject)
count = pdfReader.numPages
#code to extract all text
for i in range(count):
    page = pdfReader.getPage(i)
    print(page.extractText())
    

mycloud = WordCloud().generate(str(page.extractText()))

plt.imshow(mycloud)
plt.axis('off')   # Turn off the display of cloud map coordinates
plt.savefig('out.jpg',dpi=1000,edgecolor='blue', bbox_inches='tight', quality=95)  # Save word cloud (to work path)
plt.show()



#With shapes
mytext = page.extractText()
picture = imageio.imread('sabina.png')  #chose image for shape

mycloud = WordCloud(
                background_color = 'white',  # background color
                max_words = 20000,           # Maximum number of words
                mask = picture,              # Draw word cloud with this parameter value, and width and height will be ignored
                max_font_size = 20,          # Display the maximum value of the font
                font_path = 'simsun.ttc',    # To solve the problem of display word disorder
                collocations=False,          # Avoid repetition
               ).generate(mytext)

plt.imshow(mycloud)

plt.axis('off')

plt.savefig('new.jpg',dpi=1000,edgecolor='blue',transparent=True, bbox_inches='tight', quality=95)
plt.show()
