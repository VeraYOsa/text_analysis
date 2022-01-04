sentence = "El perro le ladraba a La Gatita .. .. lol #teamlagatita en las playas de Key Biscayne este Memorial day"
from sentiment_analysis_spanish import sentiment_analysis
sentiment = sentiment_analysis.SentimentAnalysisSpanish()
print(sentiment.sentiment(sentence))


from pysentimiento import SentimentAnalyzer
analyzer = SentimentAnalyzer(lang="es")




from transformers import AutoTokenizer, AutoModelForSequenceClassification, pipeline

tokenizer = AutoTokenizer.from_pretrained("sagorsarker/codeswitch-spaeng-sentiment-analysis-lince")

model = AutoModelForSequenceClassification.from_pretrained("sagorsarker/codeswitch-spaeng-sentiment-analysis-lince")

nlp = pipeline('sentiment-analysis', model=model, tokenizer=tokenizer)
sentence = "enemigos"
nlp(sentence)


from codeswitch.codeswitch import SentimentAnalysis, LanguageIdentification, POS, NER
lid = LanguageIdentification('spa-eng') 
text = "ratones colorados" # your code-mixed sentence 
result = lid.identify(text)
print(result)
sa = SentimentAnalysis('spa-eng')
sentence = "vida"
result = sa.analyze(sentence)
print(result)

ner = NER('spa-eng')
text = "perro" # your mixed sentence 
result = ner.tag(text)
print(result)


sa.analyze("serpiente")

from transformers import pipeline
classifier = pipeline('sentiment-analysis', model="nlptown/bert-base-multilingual-uncased-sentiment")
classifier('Because the 3 monthly plan is a political one, it’s not recommended by medical experts')
results = classifier(["Because the 3 monthly plan is a political one, it’s not recommended by medical experts.",
           "Becoming an Uncle is cool, congrats. Since July I’m a Great Uncle. That’s just being old."])
for result in results:
    print(f"label: {result['label']}, with score: {round(result['score'], 4)}")
    
inputs = tokenizer("We are very happy to show you the 🤗 Transformers library.")
pt_batch = tokenizer(
    ["Because the 3 monthly plan is a political one, it’s not recommended by medical experts.",
               "Becoming an Uncle is cool, congrats. Since July I’m a Great Uncle. That’s just being old."],
    padding=True,
    truncation=True,
    max_length=512,
    return_tensors="pt"
)

import torch
pt_outputs = model(**pt_batch, labels = torch.tensor([1, 0]))
print(pt_outputs)
