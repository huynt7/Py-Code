import requests


url = 'https://raw.githubusercontent.com/huynt7/Py-Code/main/zkteco/tn.txt'

req = requests.get(url)
print(req.text)
line1 = req.text.split('\n')

print(line1)

#for lines in req.text.split('\n'):
    #print(lines)

'''for line in req.iter_lines():
    print(lines[1])
    if line:
        line1 = str(line)
        line1 = line1.replace('b', '')
        line1 = line1.replace("'","")
        print (line1)'''