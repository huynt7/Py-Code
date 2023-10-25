from tkinter import *
import wmi
import platform, socket
import cpuinfo
import psutil
import re

def bytes_to_GB(bytes):
    gb = bytes/(1024*1024*1024)
    gb = round(gb, 2)
    return gb

S = wmi.WMI()
my_system = S.Win32_ComputerSystem()[0]
Ram = str(round(int(my_system.TotalPhysicalMemory) / (1024.0 **3)))+" GB"
Ip = socket.gethostbyname(socket.gethostname())
CPUinfo = cpuinfo.get_cpu_info()['brand_raw']
OpSys = platform.platform()
User = my_system.UserName
disk_partitions = psutil.disk_partitions()
for partition in disk_partitions:
    disk_usage = psutil.disk_usage(partition.mountpoint)
    print('Total Disk Space :', int(disk_usage.total/(1024 **3)), 'GB')

with open('/proc/scsi/scsi') as scsi:
    match =re.findall(r'Model:\s.*',scsi.read())
    for i in match:
        print(re.sub('','',i))

master = Tk()
master.title('Get info PC')
Label(master, text="\nManufactured: "+ my_system.Manufacturer).grid(row=0,column=1)
Label(master, text="\nModell: "+ my_system.Model).grid(row=1,column=1)
Label(master, text="\nName: "+ my_system.Name).grid(row=2,column=1)
Label(master, text="\nOperator System: "+ OpSys).grid(row=3,column=1)
Label(master, text="\nSystem Type: "+ my_system.SystemType).grid(row=4,column=1)
Label(master, text="\nRAM: "+ Ram).grid(row=5,column=1)
Label(master, text="\nProcessor: "+ CPUinfo).grid(row=6,column=1)
Label(master, text="Ip Address: "+ Ip).grid(row=7,column=1)
Label(master, text="\nUserName: "+ User[User.find('\\')+1:]).grid(row=8,column=1)

master.mainloop()