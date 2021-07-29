# defines UDPfromxxx functions which return UDP equivalent of supplied POS code
#
# @lb42 july 2021
#


def UDPfromFR (str) :
   posTab = {
"ABR":"X",
"ADJ":"ADJ",
"ADV":"ADV",
"DET:ART":"DET",
"DET:POS":"DET",
"INT":"INTJ",
"KON":"CCON",
"NAM":"PROPN",
"NOM":"NOUN",
"NUM":"NUM",
"PRO":"PRON",
"PRO:DEM":"PRON",
"PRO:IND":"PRON",
"PRO:PER":"PRON",
"PRO:POS":"PRON",
"PRO:REL":"PRON",
"PRP":"ADP",
"PRP:det":"ADP",
"PUN":"PUNCT",
"PUN:cit":"PUNCT",
"SENT":"PUNCT",
"SYM":"SYM",
"VER:cond":"VERB",
"VER:futu":"VERB",
"VER:impe":"VERB",
"VER:impf":"VERB",
"VER:infi":"VERB",
"VER:pper":"VERB",
"VER:ppre":"VERB",
"VER:pres":"VERB",
"VER:simp":"VERB",
"VER:subi":"VERB",
"VER:subp":"VERB"          
   }
   return posTab.get(str,"?")   

def UDPfromC5 (str):
   posTab = {
   "AJ0": "ADJ",
   "AJC": "ADJ",
   "AJS": "ADJ",
   "AT0": "DET",
   "AV0": "ADV",
   "AVP": "ADV",
   "AVQ": "ADV",
   "CJC": "CCONJ",
   "CJS": "SCONJ",
   "CJT": "SCONJ",
   "CRD": "NUM",
   "DPS": "DET",
   "DT0": "DET",
   "DTQ": "DET",
   "EX0": "PRON",
   "ITJ": "INTJ",
   "NN0": "NOUN",
   "NN1": "NOUN",
   "NN2": "NOUN",
   "NP0": "PROPN",
   "ORD": "ADJ",
   "PNI": "PRON",
   "PNP": "PRON",
   "PNQ": "PRON",
   "PNX": "PRON",
   "POS": "PART",
   "PRF": "ADP",
   "PRP": "ADP",
   "PUL": "PUNCT",
   "PUN": "PUNCT",
   "PUQ": "PUNCT",
   "PUR": "PUNCT",
   "SENT": "PUNCT",
   "TO0": "PART",
   "VBB": "VERB",
   "VBD": "VERB",
   "VBG": "VERB",
   "VBI": "VERB",
   "VBN": "VERB",
   "VBZ": "VERB",
   "VDB": "VERB",
   "VDD": "VERB",
   "VDG": "VERB",
   "VDI": "VERB",
   "VDN": "VERB",
   "VDZ": "VERB",
   "VHB": "VERB",
   "VHD": "VERB",
   "VHG": "VERB",
   "VHI": "VERB",
   "VHN": "VERB",
   "VHZ": "VERB",
   "VM0": "AUX",
   "VVB": "VERB",
   "VVD": "VERB",
   "VVG": "VERB",
   "VVI": "VERB",
   "VVN": "VERB",
   "VVZ": "VERB",
   "XX0": "PART",
   "ZZ0": "SYM"
   }
   
   return posTab.get(str,"?")
   
