import tkinter.ttk as tk
import subprocess
import sys
import time

try:
	import requests
except ImportError:
	subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'requests'])

from tkinter import messagebox
from tkinter import *
from zk import ZK
from datetime import datetime

# lấy dữ liệu online
url = 'https://raw.githubusercontent.com/huynt7/Py-Code/main/zkteco/bn.txt'
req = requests.get(url)
s = req.text.split('\n')
# gán dữ liệu vào biến
ip = s[0]
port = s[1]
passConnect = s[2]

class UI():
    def __init__(self, master=None):
        self.root = Tk()
        self.title = 'Device Zkteco., Coder: Huynt'
        self.setting()
        self.create_Widget()
        self.pack()
        self.sync_curTime()
        self.mainloop()
        

    def setting(self):
        self.root.geometry('280x210+300+200')
        self.root.resizable(1, 1)
        self.root.title(self.title)

    def sync_curTime(self):
        entry_frame = Frame(self.root)
        day_var = IntVar(entry_frame)
        month_var = IntVar(entry_frame)
        hour_var = IntVar(entry_frame)
        minute_var =IntVar(entry_frame)

        current_day = datetime.today().day
        current_month = datetime.today().month
        current_hour = datetime.today().hour
        current_minute = datetime.today().minute

        day_var.set(current_day)
        month_var.set(current_month)
        hour_var.set(current_hour)
        minute_var.set(current_minute)

        self.set_day = Spinbox(self.root, from_ = 1, to = 31, textvariable = day_var)
        self.set_month = Spinbox(self.root, from_ = 1, to = 12, textvariable = month_var)
        self.set_hour = Spinbox(self.root, from_ = 1, to = 24, textvariable = hour_var)
        self.set_minute = Spinbox(self.root, from_ = 1, to = 60, textvariable = minute_var)
        self.set_day.place(x = 60, y = 80, height = 25, width = 50)
        self.set_month.place(x = 60, y = 110, height = 25, width = 50)
        self.set_hour.place(x = 60, y = 140, height = 25, width = 50)
        self.set_minute.place(x = 60, y = 170, height = 25, width = 50)
        
    def create_Widget(self):

        self.text_addIP = Label(self.root, text = 'IP:', font = ('Times', '10'))
        self.addressIP = Entry(self.root, textvariable = StringVar(self.root,value=ip), font = ('Times', '11'), show = '*')

        self.text_password = Label(self.root,text = 'PW:', font = ('Times','10'))
        self.password = Entry(self.root, textvariable = StringVar(self.root,value=passConnect), font = ('Times','11'),show = '*')

        self.text_setting = Label(self.root, text = 'Optional time', font = ('Times', '10'))
        self.show_result1 = Label(self.root,text = '', font = ('Times', '10'), justify='left', wraplength =160 )
        self.show_result2 = Label(self.root,text = '', font = ('Times', '10'), justify='left', wraplength =160 )

        self.text_day = Label(self.root, text = 'Day:', font = ('Times', '10'))
        self.text_month = Label(self.root, text = 'Month:', font = ('Times', '10'))
        self.text_hour = Label(self.root, text = 'Hour:', font = ('Times', '10'))
        self.text_minute = Label(self.root, text = 'Minute:', font = ('Times', '10'))
        
        self.but_timedevice = Button(self.root,text = "Get Time Device", font = ('Times', '10'), fg = 'white', bg = '#678', command = self.get_timeDevice)
        self.but_sync = Button(self.root,text = "Current Times", font = ('Times', '10'), fg = 'white', bg = '#478', command = self.sync_curTime)
        self.but_change = Button(self.root, text = "Change", font = ('Times', '10', 'bold'), fg = 'white', bg = '#147', command = self.set_change)

    def pack(self):
        self.text_addIP.place(x = 15, y = 10, height = 25)
        self.addressIP.place(x = 40, y = 10,height = 25, width = 110)
        self.text_password.place(x = 155, y = 10, height = 25)
        self.password.place(x = 190, y = 10, height = 25, width = 70)

        self.text_setting.place(x = 20, y = 55)
        self.show_result1.place(x = 110, y = 38, width = 160)
        self.show_result2.place(x = 110, y = 75, width = 160)

        self.text_day.place(x = 10, y = 83, height = 20)
        self.text_month.place(x = 10, y = 113, height = 20)
        self.text_hour.place(x = 10, y = 143, height = 20)
        self.text_minute.place(x = 10, y = 173, height = 20)
        
        self.but_timedevice.place(x =140, y = 110, height = 25, width = 120)
        self.but_sync.place(x =140, y = 140, height = 25, width = 120)
        self.but_change.place(x =140, y = 170, height = 25, width = 120)

    def get_timeDevice(self):
        try:
            xIP = self.addressIP.get()
            xPASS = self.password.get()
            conn = None
            zk = ZK(xIP, password=xPASS)
            conn = zk.connect()
            zktime = conn.get_time()
            # get current machine's time, show it
            self.show_result1.config(text="Machine's time: \n" + str(zktime))
            self.show_result2.config(text='')
            #self.show_result1.after(1000,self.get_timeDevice)
        except Exception as e:
            print ("Process terminate : {}".format(e))
        finally:
            if conn:
                conn.disconnect()

    def set_change(self):
        try:
            conn = None
            zk = ZK(ip, password=passConnect)
            conn = zk.connect()
            # get current machine's time
            zktime = conn.get_time()
            self.show_result1.config(text="Machine's time:\n" + str(zktime))
            print ("Machine's time: ", zktime)
            # update new time to machine
            try:
                year = datetime.today().year
                day = eval(self.set_day.get())
                month = eval(self.set_month.get())
                hour = eval(self.set_hour.get())
                minute = eval(self.set_minute.get())
                second = datetime.today().second

                newtime =datetime(year,month,day,hour,minute,second)

            except (SystemError, Exception):
                return
            wTime = conn.set_time(newtime)
            # get time check
            time.sleep(1)
            self.show_result2.config(text="Sync time:\n" + str(newtime))
            print ("Sync time: ", newtime)
            conn.disconnect()
        except Exception as e:
            print ("Process terminate : {}".format(e))

    def mainloop(self):
        self.root.mainloop()

app = UI()