import datetime
import subprocess
import sys
from tkinter import *
import datetime

subprocess.check_call([sys.executable, '-m', 'pip', 'install', '--upgrade', 'pip'])

try:
	import tkcalendar
except ImportError:
	subprocess.check_call([sys.executable, '-m', 'pip', 'install', 'tkCalendar'])
finally:
	from tkcalendar import Calendar

root = Tk()
root.geometry('270x220')
x = datetime.datetime.now()
lich = Calendar(root,font = ("Arial", 10), selectmode = 'day',
			year = x.year, month = x.month,
			day = x.day)

lich.pack(pady = 20)
root.mainloop()