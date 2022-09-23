import pyautogui
import time

groups = []


print(len(groups))
time.sleep(10)

#for n in range(1000):
#    print(pyautogui.position())
#time.sleep(60)

pyautogui.keyDown('ctrl')
pyautogui.keyDown('t')
pyautogui.keyUp('t')
pyautogui.keyUp('ctrl')

for i in range(len(groups)):

    link = 'https://www.facebook.com/groups/create/'
    pyautogui.typewrite(link)
    pyautogui.keyDown('enter')
    pyautogui.keyUp('enter')
    print("Waiting for 45 seconds\n")
    time.sleep(10)

    #for n in range(1000):
    #    print(pyautogui.position())

    #pyautogui.moveTo(158,329)
    #pyautogui.click()
    #time.sleep(10)
    
    #pyautogui.moveTo(141,288)
    #pyautogui.click()
    
    pyautogui.typewrite('Pakistanis in '+groups[i])
    pyautogui.keyDown('tab')
    pyautogui.keyUp('tab')
    pyautogui.typewrite('p')
    pyautogui.keyDown('enter')
    pyautogui.keyUp('enter')
    time.sleep(1)

    pyautogui.moveTo(132,692)
    pyautogui.click()
    time.sleep(10)
    
    pyautogui.moveTo(307,260)
    pyautogui.click()
    time.sleep(2)

    pyautogui.moveTo(145,393)
    pyautogui.click()
    time.sleep(5)

    pyautogui.moveTo(451,184)
    pyautogui.click()
    pyautogui.keyDown('enter')
    pyautogui.keyUp('enter')
    time.sleep(3)

    pyautogui.moveTo(306,138)
    pyautogui.click()
    time.sleep(5)

    pyautogui.moveTo(816,48)
    pyautogui.click()
    pyautogui.click()
    pyautogui.keyDown('right')
    pyautogui.keyUp('right')
    pyautogui.typewrite('/edit')
    pyautogui.keyDown('enter')
    pyautogui.keyUp('enter')
    time.sleep(10)

    pyautogui.moveTo(1365,527)
    pyautogui.click()
    time.sleep(1)

    pyautogui.moveTo(1056,362)
    pyautogui.click()
    time.sleep(1)

    pyautogui.moveTo(1056,392)
    pyautogui.click()
    time.sleep(1)

    pyautogui.moveTo(1027,495)
    pyautogui.click()
    time.sleep(5)

    pyautogui.moveTo(1065,417)
    pyautogui.click()
    time.sleep(1)

    pyautogui.moveTo(1065,447)
    pyautogui.click()
    time.sleep(1)

    pyautogui.moveTo(1045,547)
    pyautogui.click()
    time.sleep(5)

    pyautogui.keyDown('ctrl')
    pyautogui.keyDown('w')
    pyautogui.keyUp('ctrl')
    pyautogui.keyUp('w')
    pyautogui.keyDown('ctrl')
    pyautogui.keyDown('t')
    pyautogui.keyUp('t')
    pyautogui.keyUp('ctrl')



