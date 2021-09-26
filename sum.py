#!/usr/bin/python3

#Read in build options
keystr="202109"
foneday=open("oneday.txt")
timelevels=[]
nodeknts=[]
hhmm0="-1"
knt=-1
while True:
  line=foneday.readline()
  if not line:
    break;
  if line.find(keystr)>=0:
    hhmm=line.strip()[9:]
    #save previous knt
    timelevels.append(hhmm0)
    nodeknts.append(knt)
    knt=0
    hhmm0=hhmm
  else:
    if not (line.find('JOBID')>=0 or line.strip()==''):
      knt=knt+int(line[108:])

for i in range(0,len(nodeknts)):
  print(str(i)+" "+str(timelevels[i])+" "+str(nodeknts[i]))

