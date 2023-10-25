import PySimpleGUI as sg
import wmi  #windows menagement system library
import platform, psutil, socket

sg.theme('DarkAmber') # theme of the window

# Take information abuot your operating system
OpSys = platform.system()

Ram = str(round(psutil.virtual_memory().total / (1024.0 **3)))+" GB" #take Ram information
Proc = platform.processor() #take processor information
Ip = socket.gethostbyname(socket.gethostname()) #take ip address information
S = wmi.WMI() #take windows management system information
my_system = S.Win32_ComputerSystem()[0]

password = 'password' #Define system password

# Define the window's contents
layout = [[sg.Text("Get your computer's information, put in your password: ")],
          [sg.Input(key='-INPUT-')],
          [sg.Button('Ok'), sg.Button('Quit')],
          [sg.Text(size=(300,1), key='-OUTPUT-')]
         ]

# Create the window
window = sg.Window('Get Pc Info', layout, size=(900, 450))

while True:
    event, values = window.read()
    # See if user wants to quit or window was closed
    if event == sg.WINDOW_CLOSED or event == 'Quit':
        break

    elif event == window.read() or event == 'Help':
        sg.popup(
            "\n1. Enter your password in the input bar",
            "\n2. Press Ok to validate your password",
            "\n3. Check your info and press Ok at the and to close the popup",
            "\n4. Press Quit to close the program or press red x",
            "\n+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-",
            "Autor: Deca-Code",
            "+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-",
        )
        
    # If password is correct the window give you your information
    elif values['-INPUT-'] == password:
        window['-OUTPUT-'].update('Your info: Name')

        # pop up your computer information, in a new window
        sg.popup(
                 f"\nManufactured: {my_system.Manufacturer}",
                 f"\nModell: {my_system.Model}",
                 f"\nName: {my_system.Name}",
                 f"\nOperator System: {OpSys}",
                 f"\nSystem Type: {my_system.SystemType}",
                 f"\nSystem Family / Computer Type: {my_system.SystemFamily}",
                 f"\nRAM (random access memory): {Ram}",
                 f"\nProcessor: {Proc}"
                 f"\n\n+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+",
                 f"Ip Address: {Ip}",
                 f"+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
               )
    # If you put wrong password
    elif values['-INPUT-'] != password:
        window['-OUTPUT-'].update('Error: unexpected password, try again!')

# Finish up, it remove window rom the screen
window.close()
