print(abs(1+2j))
#Return the absolute value of a number. 
#The argument may be an integer, a floating point number, or an object implementing __abs__(). 
#If the argument is a complex number, its magnitude is returned.

print(all([True,  False,  True]))
#Return True if all elements of the iterable are true (or if the iterable is empty).

print(any([True,  False,  True]))
#Return True if any element of the iterable is true. If the iterable is empty, return False.

print(ascii([24]))
#As repr(), return a string containing a printable representation of an object, but escape the non-ASCII characters in the string returned by repr() using \x, \u or \U escapes.

print(bin(-4))
#Convert an integer number to a binary string prefixed with “0b”. The result is a valid Python expression. If x is not a Python int object, it has to define an __index__() method that returns an integer.

print(bool([1, 2, 0]))
#Return a Boolean value, i.e. one of True or False. x is converted using the standard truth testing procedure. If x is false or omitted, this returns False; otherwise it returns True.

#breakpoint()
#This function drops you into the debugger at the call site. Specifically, it calls sys.breakpointhook(), passing args and kws straight through. By default, sys.breakpointhook() calls pdb.set_trace() expecting no arguments. In this case, it is purely a convenience function so you don’t have to explicitly import pdb or type as much code to enter the debugger. However, sys.breakpointhook() can be set to some other function and breakpoint() will automatically call that, allowing you to drop into the debugger of choice.

print(bytearray([0, 1, 2, 3]))
#Return a new array of bytes. The bytearray class is a mutable sequence of integers in the range 0 <= x < 256. It has most of the usual methods of mutable sequences, described in Mutable Sequence Types, as well as most methods that the bytes type has

print(bytes([0, 1, 2]))
#Return a new “bytes” object, which is an immutable sequence of integers in the range 0 <= x < 256. bytes is an immutable version of bytearray – it has the same non-mutating methods and the same indexing and slicing behavior.

def foo(x):
    return x>2
print(callable(foo))
#Return True if the object argument appears callable, False if not. If this returns True, it is still possible that a call fails, but if it is False, calling object will never succeed.

print(chr(97))
#Return the string representing a character whose Unicode code point is the integer i. For example, chr(97) returns the string 'a', while chr(8364) returns the string '€'. This is the inverse of ord().

#classmethod
#Transform a method into a class method.
#A class method receives the class as implicit first argument, just like an instance method receives the instance. 

#compile(source, filename, mode, flags=0, dont_inherit=False, optimize=-1)
#Compile the source into a code or AST object. Code objects can be executed by exec() or eval(). source can either be a normal string, a byte string, or an AST object. 

print(complex('1+2j'))
#Return a complex number with the value real + imag*1j or convert a string or number to a complex number. If the first parameter is a string, it will be interpreted as a complex number and the function must be called without a second parameter.

class x:
    foobar='Hello World'
    bar=2
print(delattr(x, 'foobar'))
#This is a relative of setattr(). The arguments are an object and a string. The string must be the name of one of the object’s attributes. The function deletes the named attribute, provided the object allows it. For example, delattr(x, 'foobar') is equivalent to del x.foobar.

print(dict())
#Create a new dictionary. The dict object is the dictionary class.

print(dir())
class Shape:
    def __dir__(self):
        return ['area', 'perimeter', 'location']
print(dir(Shape()))
#Without arguments, return the list of names in the current local scope. With an argument, attempt to return a list of valid attributes for that object.

print(divmod(5, 7))
#Take two (non complex) numbers as arguments and return a pair of numbers consisting of their quotient and remainder when using integer division. With mixed operand types, the rules for binary arithmetic operators apply. For integers, the result is the same as (a // b, a % b). For floating point numbers the result is (q, a % b), where q is usually math.floor(a / b) but may be 1 less than that. In any case q * b + a % b is very close to a, if a % b is non-zero it has the same sign as b, and 0 <= abs(a % b) < abs(b).

seasons = ['Spring', 'Summer', 'Fall', 'Winter']
print(list(enumerate(seasons, start=1)))
#Return an enumerate object. iterable must be a sequence, an iterator, or some other object which supports iteration.

y=1
print(eval('y+1'))
#The arguments are a string and optional globals and locals. If provided, globals must be a dictionary. If provided, locals can be any mapping object.

print(exec('y+1'))
#This function supports dynamic execution of Python code. object must be either a string or a code object. If it is a string, the string is parsed as a suite of Python statements which is then executed (unless a syntax error occurs). 1 If it is a code object, it is simply executed. In all cases, the code that’s executed is expected to be valid as file input

print(list(filter(foo, [1, 2, 3])))
#Construct an iterator from those elements of iterable for which function returns true. iterable may be either a sequence, a container which supports iteration, or an iterator. If function is None, the identity function is assumed, that is, all elements of iterable that are false are removed.

print(float('-1.23'))
#Return a floating point number constructed from a number or string x.

print(format(-1.23))
#Convert a value to a “formatted” representation, as controlled by format_spec.

print(frozenset([1, 2, 3]))
#Return a new frozenset object, optionally with elements taken from iterable.

print(getattr(x, 'bar'))
#Return the value of the named attribute of object. name must be a string. If the string is the name of one of the object’s attributes, the result is the value of that attribute. For example, getattr(x, 'foobar') is equivalent to x.foobar.

print(list(globals()))
#Return a dictionary representing the current global symbol table.

print(hasattr(x, 'bar'))
#The arguments are an object and a string. The result is True if the string is the name of one of the object’s attributes, False if not.

print(hash(x))
#Return the hash value of the object (if it has one). Hash values are integers. They are used to quickly compare dictionary keys during a dictionary lookup.

#help()
#Invoke the built-in help system.
""""
AsyncFile           aifc                locale              struct
BreakpointWatch     antigravity         logging             subprocess
DCTestResult        argparse            lzma                sunau
DebugBase           array               macpath             symbol
DebugClient         ast                 mailbox             symtable
DebugClientBase     asynchat            mailcap             sys
DebugClientCapabilities asyncio             marshal             sysconfig
DebugConfig         asyncore            math                tabnanny
DebugUtilities      atexit              matplotlib          tarfile
DebugVariables      audioop             mimetypes           telnetlib
FlexCompleter       base64              mmap                tempfile
HelloWorld          bdb                 mmapfile            test
PyProfile           binascii            mmsystem            textwrap
PyQt5               binhex              modulefinder        this
ThreadExtension     bisect              msilib              threading
__future__          builtins            msvcrt              time
_abc                bz2                 multiprocessing     timeit
_ast                cProfile            netbios             timer
_asyncio            calendar            netrc               tkinter
_bisect             cgi                 nntplib             token
_blake2             cgitb               nt                  tokenize
_bootlocale         chunk               ntpath              trace
_bz2                cmath               ntsecuritycon       traceback
_codecs             cmd                 nturl2path          tracemalloc
_codecs_cn          code                numbers             tty
_codecs_hk          codecs              numpy               turtle
_codecs_iso2022     codeop              odbc                turtledemo
_codecs_jp          collections         opcode              types
_codecs_kr          colorsys            operator            typing
_codecs_tw          commctrl            optparse            unicodedata
_collections        compileall          os                  unittest
_collections_abc    concurrent          parser              urllib
_compat_pickle      configparser        pathlib             uu
_compression        contextlib          pdb                 uuid
_contextvars        contextvars         perfmon             venv
_csv                copy                pickle              warnings
_ctypes             copyreg             pickletools         wave
_ctypes_test        coverage            pip                 weakref
_datetime           crypt               pipes               webbrowser
_decimal            csv                 pkg_resources       win2kras
_distutils_findvs   ctypes              pkgutil             win32api
_dummy_thread       curses              platform            win32clipboard
_elementtree        cycler              plistlib            win32com
_functools          dataclasses         poplib              win32con
_hashlib            datetime            posixpath           win32console
_heapq              dateutil            pprint              win32cred
_imp                dbi                 profile             win32crypt
_io                 dbm                 pstats              win32cryptcon
_json               dde                 pty                 win32event
_locale             decimal             py_compile          win32evtlog
_lsprof             difflib             pyclbr              win32evtlogutil
_lzma               dis                 pydoc               win32file
_markupbase         distutils           pydoc_data          win32gui
_md5                doctest             pyexpat             win32gui_struct
_msi                dummy_threading     pylab               win32help
_multibytecodec     easy_install        pyparsing           win32inet
_multiprocessing    email               pythoncom           win32inetcon
_opcode             encodings           pywin               win32job
_operator           ensurepip           pywin32_bootstrap   win32lz
_osx_support        enum                pywin32_testutil    win32net
_overlapped         eric6               pywintypes          win32netcon
_pickle             eric6config         queue               win32pdh
_py_abc             eric6dbgstub        quopri              win32pdhquery
_pydecimal          eric6plugins        random              win32pdhutil
_pyio               errno               rasutil             win32pipe
_queue              faulthandler        re                  win32print
_random             filecmp             regcheck            win32process
_sha1               fileinput           regutil             win32profile
_sha256             fnmatch             reprlib             win32ras
_sha3               formatter           rlcompleter         win32rcparser
_sha512             fractions           runpy               win32security
_signal             ftplib              sched               win32service
_sitebuiltins       functools           scipy               win32serviceutil
_socket             gc                  secrets             win32timezone
_sqlite3            genericpath         select              win32trace
_sre                getopt              selectors           win32traceutil
_ssl                getpass             servicemanager      win32transaction
_stat               gettext             setuptools          win32ts
_string             glob                shelve              win32ui
_strptime           gzip                shlex               win32uiole
_struct             hashlib             shutil              win32verstamp
_symtable           heapq               signal              win32wnet
_testbuffer         hmac                site                winerror
_testcapi           html                six                 winioctlcon
_testconsole        http                smtpd               winnt
_testimportmultiple idlelib             smtplib             winperf
_testmultiphase     imaplib             sndhdr              winreg
_thread             imghdr              socket              winsound
_threading_local    imp                 socketserver        winxpgui
_tkinter            importlib           sqlite3             winxptheme
_tracemalloc        inspect             sre_compile         wsgiref
_warnings           io                  sre_constants       xdrlib
_weakref            ipaddress           sre_parse           xml
_weakrefset         isapi               ssl                 xmlrpc
_win32sysloader     itertools           sspi                xxsubtype
_winapi             json                sspicon             zipapp
_winxptheme         keyword             stat                zipfile
abc                 kiwisolver          statistics          zipimport
adodbapi            lib2to3             string              zlib
afxres              linecache           stringprep          
"""

print(hex(255))
#Convert an integer number to a lowercase hexadecimal string prefixed with “0x”.

print(id(x))
#Return the “identity” of an object.

print(input('-->'))
#If the prompt argument is present, it is written to standard output without a trailing newline. The function then reads a line from input, converts it to a string (stripping a trailing newline), and returns that.

print(int(3.4))
#Return an integer object constructed from a number or string x, or return 0 if no arguments are given.

y=x()
print(isinstance(y, x))
#Return True if the object argument is an instance of the classinfo argument, or of a (direct, indirect or virtual) subclass thereof.

print(issubclass(x, x))
#Return True if class is a subclass (direct, indirect or virtual) of classinfo.

print(iter([0, 1, 2]))
#Return an iterator object. The first argument is interpreted very differently depending on the presence of the second argument.

print(len([1, 2, 3]))
#Return the length (the number of items) of an object.

print(list([1, 2, 3]))
#Rather than being a function, list is actually a mutable sequence type, as documented in Lists and Sequence Types — list, tuple, range.

print(list(locals()))
#Update and return a dictionary representing the current local symbol table.

print(list(map(foo, [2, 4, 5, 1])))
#Return an iterator that applies function to every item of iterable, yielding the results.

print(max(1, 2, 4, -3.2))
#Return the largest item in an iterable or the largest of two or more arguments.

#print(memoryview([1, 2, 4]))
#Return a “memory view” object created from the given argument.

print(min(-4.2, 1, 7))
#Return the smallest item in an iterable or the smallest of two or more arguments.

print(next(iter([0, 1, 2])))
#Retrieve the next item from the iterator by calling its __next__() method. If default is given, it is returned if the iterator is exhausted, otherwise StopIteration is raised.

#object
#Return a new featureless object. object is a base for all classes. It has the methods that are common to all instances of Python classes.

print(oct(8))
#Convert an integer number to an octal string prefixed with “0o”.

#open(file, mode='r', buffering=-1, encoding=None, errors=None, newline=None, closefd=True, opener=None)
#Open file and return a corresponding file object.

print(ord('a'))
#Given a string representing one Unicode character, return an integer representing the Unicode code point of that character.

print(pow(2, 3))
#Return base to the power exp; if mod is present, return base to the power exp, modulo mod (computed more efficiently than pow(base, exp) % mod). The two-argument form pow(base, exp) is equivalent to using the power operator: base**exp.

#print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
#Print objects to the text stream file, separated by sep and followed by end. sep, end, file and flush, if present, must be given as keyword arguments.

class C:
    def __init__(self):
        self._x = None
    
    def getx(self):
        return self._x
    
    def setx(self, value):
        self._x = value
    
    def delx(self):
        del self._x
    x = property(getx, setx, delx, "I'm the 'x' property.")
#property(fget=None, fset=None, fdel=None, doc=None)
#Return a property attribute.
#fget is a function for getting an attribute value. fset is a function for setting an attribute value. fdel is a function for deleting an attribute value. And doc creates a docstring for the attribute.

r=range(1, 10)
print(r)
#Rather than being a function, range is actually an immutable sequence type, as documented in Ranges and Sequence Types — list, tuple, range.

print(repr(range(1, 10)))
#Return a string containing a printable representation of an object. 

print(reversed(r))
#Return a reverse iterator. seq must be an object which has a __reversed__() method or supports the sequence protocol (the __len__() method and the __getitem__() method with integer arguments starting at 0).

print(round(3.1418, 2))
#Return number rounded to ndigits precision after the decimal point. If ndigits is omitted or is None, it returns the nearest integer to its input.

print(set([1, 2, 3]))
#Return a new set object, optionally with elements taken from iterable.

print(setattr(x, 'foobar', 2))
print(x)
#This is the counterpart of getattr(). The arguments are an object, a string and an arbitrary value. 

r=[1, 2, 3, 4, 5]
#print(repr(r.slice(1, 3, 1)))
#Return a slice object representing the set of indices specified by range(start, stop, step).

#print(sorted(r))¶
#Return a new sorted list from the items in iterable.

class D:
    @staticmethod
    def f(arg1, arg2):
        return False
#@staticmethod
#Transform a method into a static method.

print(str(2.34))
#Return a str version of object.

print(sum([1, 2, 3, 4]))
#Sums start and the items of an iterable from left to right and returns the total. The iterable’s items are normally numbers, and the start value is not allowed to be a string.

#super([type[, object-or-type]])
#Return a proxy object that delegates method calls to a parent or sibling class of type. This is useful for accessing inherited methods that have been overridden in a class.

print(tuple([1, 2, 3]))
#Rather than being a function, tuple is actually an immutable sequence type, as documented in Tuples and Sequence Types — list, tuple, range.

print(type(x))
#With one argument, return the type of an object. The return value is a type object and generally the same object as returned by object.__class__.

print(vars(x))
#Return the __dict__ attribute for a module, class, instance, or any other object with a __dict__ attribute.

print(list(zip(iter([3, 4, 5]), iter([1, 2, 3]))))
#Make an iterator that aggregates elements from each of the iterables.

#__import__(name, globals=None, locals=None, fromlist=(), level=0)
#This function is invoked by the import statement.
