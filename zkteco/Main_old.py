# -*- coding: utf-8 -*-
import sys
import time

from zk import ZK
from datetime import datetime

print("----Code by Huynt----")
print("Type 1 goto Change Device")
print("Type 2 goto Change Time")
print("Type 3 goto Change Day")
print("Type 4 goto Sync Time Now")
try:
    x=int(input("Enter: "))
    if x==1:
        print("Change Device Now")
    elif x==2:
        xhour = input("Enter Hour: ")
        xminute = input("Enter Minute: ")
        ###
        xyear = datetime.today().year
        xmonth = datetime.today().month
        xday = datetime.today().day
        xsecond = datetime.today().second
        newtime =datetime(int(xyear),int(xmonth),int(xday),int(xhour),int(xminute),int(xsecond))
    elif x==3:
        xmonth = input("Enter Month: ")
        xday = input("Enter Day: ")
        xhour = input("Enter Hour: ")
        xminute = input("Enter Minute: ")
        ###
        xyear = datetime.today().year
        xsecond = datetime.today().second
        newtime =datetime(int(xyear),int(xmonth),int(xday),int(xhour),int(xminute),int(xsecond))
    elif x==4:
        newtime = datetime.today()
    else: 
        exit()
except:
    exit()



conn = None
zk = ZK('14.241.62.251', port=4370, timeout=5, force_udp=False, ommit_ping=False)

try:
    conn = zk.connect()
    # get current machine's time
    zktime = conn.get_time()
    print ("Machine's time: ", zktime)
    # update new time to machineb
    wTime = conn.set_time(newtime)
    # get time check
    time.sleep(2)
    print ("Sau khi sync la: %s" % conn.get_time())
except Exception as e:
    print ("Process terminate : {}".format(e))
finally:
    if conn:
        conn.disconnect()