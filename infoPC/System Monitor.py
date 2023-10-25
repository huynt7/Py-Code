from tkinter import *
import psutil
import datetime
from multiprocessing import cpu_count



def timeFunc():
    time = datetime.datetime.now().strftime("%I:%M:%S %p")
    date = datetime.datetime.now().strftime("%Y-%m-%d")

    Label(master, text="System Time").grid(row=16, columnspan=2, sticky='w')

    e13 = Entry(master)
    e13.grid(row=16, column=1)
    e13.insert(10, time)

    Label(master, text="System Date").grid(row=17, columnspan=2, sticky='w')

    e14 = Entry(master)
    e14.grid(row=17, column=1)
    e14.insert(10, date)


def secs2hours(secs):
    mm, ss = divmod(secs, 60)
    hh, mm = divmod(mm, 60)
    return "%d:%02d:%02d (H:M:S)" % (hh, mm, ss)

def main():
    global outputList

    totalRam = 1.0
    totalRam = psutil.virtual_memory()[0] * totalRam
    totalRam = str("{:.4f}".format(totalRam / (1024 * 1024 * 1024))) + ' GB'

    availRam = 1.0
    availRam = psutil.virtual_memory()[1] * availRam
    availRam = str("{:.4f}".format(availRam / (1024 * 1024 * 1024))) + ' GB'

    ramUsed = 1.0
    ramUsed = psutil.virtual_memory()[3] * ramUsed
    ramUsed = str("{:.4f}".format(ramUsed / (1024 * 1024 * 1024))) + ' GB'

    ramFree = 1.0
    ramFree = psutil.virtual_memory()[4] * ramFree
    ramFree = str("{:.4f}".format(ramFree / (1024 * 1024 * 1024))) + ' GB'

    core = cpu_count()
    ramUsages = str(psutil.virtual_memory()[2]) + '%'
    cpuPer = str(psutil.cpu_percent()) + '%'
    cpuMainCore = psutil.cpu_count(logical=False)

    outputList.append(cpuMainCore)
    outputList.append(core)
    outputList.append(cpuPer)
    outputList.append(totalRam)
    outputList.append(availRam)
    outputList.append(ramUsed)
    outputList.append(ramUsages)
    outputList.append(ramFree)


def clock():
    global outputList
    outputList = []
    main()
    timeFunc()
    master.update_idletasks()
    e1 = Entry(master)
    e2 = Entry(master)
    e3 = Entry(master)
    e4 = Entry(master)
    e5 = Entry(master)
    e6 = Entry(master)
    e7 = Entry(master)
    e8 = Entry(master)

    e1.grid(row=1, column=1)
    e2.grid(row=2, column=1)
    e3.grid(row=3, column=1)
    e4.grid(row=5, column=1)
    e5.grid(row=6, column=1)
    e6.grid(row=7, column=1)
    e7.grid(row=8, column=1)
    e8.grid(row=9, column=1)

    e1.insert(10, outputList[0])
    e2.insert(10, outputList[1])
    e3.insert(10, outputList[2])
    e4.insert(10, outputList[3])
    e5.insert(10, outputList[4])
    e6.insert(10, outputList[5])
    e7.insert(10, outputList[6])
    e8.insert(10, outputList[7])

    master.after(1000, clock)


if __name__ == '__main__':
    master = Tk()
    master.title('System Monitor')
    Label(master, text="CPU Info").grid(row=0, columnspan=2, sticky='e')
    Label(master, text="Total CPU CORE").grid(row=1, columnspan=2, sticky='w')
    Label(master, text="Total Logical Processors").grid(row=2)
    Label(master, text="CPU Usages").grid(row=3, columnspan=2, sticky='w')
    Label(master, text="RAM Info").grid(row=4, columnspan=2, sticky='e')
    Label(master, text="Total RAM").grid(row=5, columnspan=2, sticky='w')
    Label(master, text="Available RAM").grid(row=6, columnspan=2, sticky='w')
    Label(master, text="RAM Used").grid(row=7, columnspan=2, sticky='w')
    Label(master, text="RAM Usages").grid(row=8, columnspan=2, sticky='w')
    Label(master, text="RAM Free").grid(row=9, columnspan=2, sticky='w')
    Label(master, text="Battery Info").grid(row=10, columnspan=2, sticky='e')
    Label(master, text="Additional").grid(row=15, columnspan=2, sticky='e')
    Label(master, text=u'\N{COPYRIGHT SIGN}' " foysal_nibir 2018", fg='red').grid(row=19, columnspan=2, sticky='n', )

    outputList = []

    clock()
    master.update_idletasks()

    master.mainloop()