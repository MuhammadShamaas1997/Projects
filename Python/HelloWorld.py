#Hello World
"""
Hello World
Hello World
"""
import random
import numpy as np
import scipy as stats
import matplotlib.pyplot as plt

y, z, a, b, c, d=str("Hello, World"), int(5), float(20.5), complex(1+2j), bool(5),  bool(True)
def myfunc():
    global x
    x=int(5)
    if x > 2:
        print(y);
        print(type(x))
        print(random.randrange(1, 1e9))
    if not(z is not (2**2+1) and 'l' not in y):
        print(str(z)+' '+y[0:len(y)])
    else:
        print(y)
    return True

myfunc()    

print(y.capitalize())
print(y.casefold())
print(y.center(20))
print(y.count('o'))
print(y.encode())
print(y.endswith('d'))
print(y.expandtabs())
print(y.find(','))
print(y.format('o'))
print(y.format_map('o'))
print(y.index('o'))
print(y.isalnum())
print(y.isalpha())
print(y.isdecimal())
print(y.isdigit())
print(y.isidentifier())
print(y.islower())
print(y.isnumeric())
print(y.isprintable())
print(y.isspace())
print(y.istitle())
print(y.isupper())
print(y.join('He'))
#print(y.ljust())
print(y.lower())
print(y.lstrip())
#print(y.maketrans())
#print(y.partition())
print(y.replace('l', 'k'))
print(y.rfind('l'))
print(y.rindex('l'))
#print(y.rjust('r'))
print(y.rpartition('l'))
print(y.rsplit('l'))
print(y.rstrip('l'))
print(y.split('l'))
#print(type(y.splitlines('l')))
print(y.startswith('l'))
print(y.strip('l'))
print(y.swapcase())
print(y.title())
#print(y.translate())
print(y.upper())
print(y.zfill(50))
print(isinstance(y, str))

arr=np.array([1, 7, 3, 4, 5])
print(np.sort(arr))
print(np.mean(arr))
#print(stats.mode(arr))
plt.scatter(arr, arr)
plt.show()
