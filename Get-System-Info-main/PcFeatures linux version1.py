#Linux compatible code
import PySimpleGUI as sg
import platform, psutil, socket

sg.theme('DarkAmber') # theme of the window

# Take information abuot your operating system and computer
OpSys = platform.system()
Ram = str(round(psutil.virtual_memory().total / (1024.0 **3)))+" GB" #take Ram information
Proc = platform.processor() #take processor information
Ip = socket.gethostbyname(socket.gethostname()) #take ip address information
Computer = platform.node()
version = platform.version()
CPU = " " +str(psutil.cpu_count())
fCPU = " " +str(psutil.cpu_count(logical=False))

password = 'password' #Define system password

# Define the window's contents
layout = [[sg.Text("Get your computer's information, put in your password: ")],
          [sg.Input(key='-INPUT-')],
          [sg.Button('Ok'), sg.Button('Quit'), sg.Button('Help')],
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
                 f"\nOperator System: {OpSys}",
                 f"\nNode: {Computer}",
                 f"\nOs Version: {version}",
                 f"\nRAM (random access memory): {Ram}",
                 f"\nProcessor: {Proc}",
                 f"\nNumber of CPUs: {CPU} core",
                 f"\nNumber of physical CPUs: {fCPU} core",
                 f"\n+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+",
                 f"Ip Address: {Ip}",
                 f"+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
               )
    # If you put wrong password
    elif values['-INPUT-'] != password:
        window['-OUTPUT-'].update('Error: unexpected password, try again!')

# Finish up, it remove window rom the screen
window.close()
