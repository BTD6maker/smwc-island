import struct, sys

sys.argv=["texteditor.py","orig.smc","import"]

#These arrays convert between special symbols and hex.
hextoarray=[0x26,0x27,0x2B,0x36,0x37,0x38,0x39,0x3A,0x3B,0x3C,0x3D,0x3E,0x3F,0xC4,0xC5,0xC6,0xC7,0xC8,0xC9,0xCE,0xCF,0xD1,0xF3]
arraytoascii=[":",";","'","=",",","e","i","t","r","h","f","n",".","(",")","?","!","_","-","~",",","\"","."]
hextoarray2=[0x00,0x01,0x02,0x03,0x04,0x05,0x06,0x07,0x08,0x09,0x10,0x11,0x12,0x13,0x14,0x15,0x16,0x2C,0x2D,0x2E,0x2F,0x30,0x40,0x41,0x42,0x43,0x44,0x45,0x46,0x47,0x48,0x49,0x4A,0x4B,0xCC,0xCD,0xD2,0xD3,0xD4,0xD7,0xF2,0xFA]
arraytoascii2=["/\\a","/^a","/,c","/\\e","//e","/^e","/^i","/^o","/,u","/^u","/:a","/:o","/:u","/ss","/:A","/:O","/:U","/a^","/b<","/b>","/b^","/bv","/-A","/^A","/,I","/vC","//E","/,E","/^I","/^O","//U","/,U","/^I","/^i","/..","/*o","/\"\"","/*.","/a>","/*x","/a<","/av"]
symbols2=[0x18,0x1A,0x1C,0x1E,0x34,0xCA,0xD5,0xF4,0xF6,0xF8]
symbols2toascii=["/SA","/SB","/SY","/SX","/Y^","/SD","/YY","/Y?","/Y*","/Y!"]
symbols3=[0x20,0x23,0x28,0x31]
symbols3toascii=["/SE","/SL","/SR","/ST"]
hexchars = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"]

#Special case (purely for MINE,MINE in SMWCI):
mineminehex = [0xFF,0x05,0xB1,0xEC,0xDF,0xC6,0xC6,
0xFF,0x06,0xB1,0xE4,0xE4,0xC6,0xC7,0xC7,0xC6,
0xFF,0x07,0xB6,0xE4,0xE4,0xE4,0xE4,0xC7,0xC7,0xC7,0xC7,0xC6,0xC7,
0xFF,0x08,
0xFF,0x0E,0xC0,0xDF,0xD8,0xEB,0xD0,0xE2,0xE0,0xE5,0xDB,0xD0,0xE6,0xDD,0xD0,0xDE,0xEE,0xDC,0xDC,0xE5,
0xFF,0x0A,
0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,
0xFF,0x0E,0xDB,0xE6,0xE5,0xE2,0xDC,0xF0,0xD0,0xE0,0xEA,0xD0,0xDB,0xD8,0xEB,0xC6,
0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,
0xFF,0x0E,0xB5,0xE6,0xE6,0xE2,0xEA,0xD0,0xEE,0xF0,0xE2,0xDC,0xD0,0xDD,0xEC,0xE5,0xC7,
0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,
0xFF,0x0E,0xB6,0xDC,0xD0,0xEE,0xD8,0xE5,0xE5,0xD8,0xD0,0xE9,0xE0,0xC9,0xE0,0xDB,0xDC,0xC7,0xC7,0xC7,
0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,
0xFF,0x0E,0xFF,0x0A,
0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,
0xFF,0x0E,0xFF,0x08,0xFF,0x31,0xB6,0xB2,0xB7,0xAE,0xC7,0xC7,
0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,
0xFF,0x0E,
0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,
0xFF,0x0E,0xFF,0x08,0xB6,0xB2,0xB7,0xAE,0xC7,0xC7,0xC7,
0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,0xFF,0x12,
0xFF,0x0F,0xFF,0xFF]

#This is the junk data after translevel names. I do not know if this does something important.
junkdata = [0xFF,0x1E,0x57,0x9A,0x61,0xC9,0x50,0x51,0x88,0x5F,0x87,0xFE,0x10,0x19,0xC4,0x00,0x20,0x41,0x0C,0x14,0x02,0x1D,0x0F,0xC5,0xFD]

#From romutils
def open_rom(file):
    with open(file, "rb") as f:
        data = f.read()
    if len(data) > 0x200000:
        return data[0x200:]
    return data

#Allows pointers for a translevel message to be found
def find_pointer(pointerdata, translevel, coords):
    pointer1 = pointerdata[translevel*8+coords*2]
    pointer2 = pointerdata[translevel*8+coords*2+1]
    pointerloc = 0x110000+(pointer2*256)+pointer1
    return pointerloc

#Allows pointers for a translevel name to be found
def find_translevel_pointer (pointerdata, translevel):
    pointer1 = pointerdata[translevel*2]
    pointer2 = pointerdata[translevel*2+1]
    pointerloc = 0x110000+(pointer2*256)+pointer1
    return pointerloc

#Checks whether a pointer leads to a genuine message
def check_message_pointer(rom, pointer):
    if rom[pointer] == 0xFF and (rom[pointer+1] > 0x04 and rom[pointer+1] < 0x09):
        return True
    return False

#Check whether a pointer leads to a genuine translevel name
def check_translevel_pointer(rom, pointer):
    if rom[pointer] == 0xFF and rom[pointer+1] == 0x00:
        return True
    return False

#Given an initial pointer, returns the message in raw hex
def get_message(rom, pointer):
    ended = False
    i = pointer
    while not ended:
        i += 1
        if rom[i] == 0xFF and (rom[i+1] == 0x0F or (rom[i+1] > 0x4F and rom[i+1] < 0x53)) and rom[i+2] == 0xFF and rom[i+3] == 0xFF:
            ended=True
    message = rom[pointer:i+4]
    return message

#Given an initial pointer, returns the translevel name in raw hex
def get_translevel(rom, pointer):
    ended = False
    i = pointer
    while not ended:
        i += 1
        if rom[i] == 0xFD:
            ended=True
    message = rom[pointer:i+1]
    return message

#Converts single symbols from hex to ASCII
def hex_to_ascii(symbol):
    if symbol > 0xA9 and symbol < 0xC4:
        return str(chr(symbol-105))
    if symbol > 0xD7 and symbol < 0xF2:
        return str(chr(symbol-119))
    if symbol > 0x9F and symbol < 0xAA:
            return str(chr(symbol-112))
    if advancedmode:
        if symbol == 0xD0:
            return " "
    else:
        if (symbol > 0x09 and symbol < 0x10) or (symbol > 0x4B and symbol < 0xA0) or (symbol > 0xFA and symbol < 0xFD) or symbol == 0x17 or symbol == 0xD0:
            return " "
        for i in range(23):
            if hextoarray[i] == symbol:
                return arraytoascii[i]
        for i in range(42):
            if hextoarray2[i] == symbol:
                return arraytoascii2[i]
    hex1 = symbol // 16
    hex2 = symbol % 16
    return "/"+hexchars[hex1]+hexchars[hex2]

#Converts a message from hex to text
def message_hex_to_text(message):
    i=2
    if advancedmode:
        if message[1] == 0x06:
            messagetext = "/\\6"
        elif message[1] == 0x07:
            messagetext = "/\\7"
        elif message[1] == 0x08:
            messagetext = "/\\8"
        else:
            messagetext = "/\\\\"
    else:
        messagetext = "/\\\\"
    while i < len(message):
        oldi = i
        if message[i] == 0xFF:
            i += 1
            if message[i] != 0x05 and message[i] != 0x0A and message[i] != 0x0F and message[i] != 0x12 and (message[i] < 0x30 or message[i] > 0x3B) and (message[i] < 0x3D or message[i] > 0x3F) and message[i] != 0x60 and (message[i] < 0x50 or message[i] > 0x52):
                messagetext=messagetext+"\n"
            elif message[i] == 0x0F:
                messagetext=messagetext+"///"
                return messagetext
            elif message[i] > 0x29 and message[i] < 0x3C:
                hex2 = message[i] % 16
                messagetext=messagetext+"/TS/3"+hexchars[hex2]
            elif message[i] == 0x3D:
                if message[i+1] == 0xFF and message[i+2] == 0x3E and message[i+3] == 0xFF and message[i+4] == 0x3F:
                    messagetext=messagetext+"/LL"
                    i += 4
                else:
                    messagetext=messagetext+"/L1"
            elif message[i] == 0x3E:
                messagetext=messagetext+"/L2"
            elif message[i] == 0x3F:
                messagetext=messagetext+"/L3"
            elif message[i] == 0x50:
                messagetext=messagetext+"/_D"
                return messagetext
            elif message[i] == 0x51:
                messagetext=messagetext+"/_C"
                return messagetext
            elif message[i] == 0x52:
                messagetext=messagetext+"/_E"
                return messagetext
            elif message[i] == 0x60:
                if message[i+1] + message[i+3] + message[i+6] == 0x00 and message[i+4] == 0x80 and message[i+5] == 0x30 and message[i+7] == 0x10:
                    if message[i+2] == 0x00:
                        messagetext=messagetext+"/ME"
                        i += 7
                    if message[i+2] == 0x30:
                        messagetext=messagetext+"/GP"
                        i += 7
                    if message[i+2] == 0x80:
                        messagetext=messagetext+"/TE"
                        i += 7
        elif message[i] in symbols2 and not(advancedmode):
            for j in range(10):
                if symbols2[j] == message[i] and symbols2[j]+1 == message[i+1]:
                    messagetext=messagetext+symbols2toascii[j]
                    i += 1
            if oldi == i:
                messagetext=messagetext+hex_to_ascii(message[i])
        elif message[i] in symbols3 and not(advancedmode):
            for j in range(4):
                if symbols3[j] == message[i] and symbols3[j]+1 == message[i+1] and symbols3[j]+2 == message[i+2]:
                    messagetext=messagetext+symbols3toascii[j]
                    i += 2
            if oldi == i:
                messagetext=messagetext+hex_to_ascii(message[i])
        else:
            messagetext=messagetext+hex_to_ascii(message[i])
        i += 1

#Converts a translevel name from hex to text
def translevel_hex_to_text(message):
    i=2
    line=True
    messagetext=""
    while i < len(message)-1:
        oldi = i
        if message[i] == 0xFE and message[i+1] == 0x10 and line:
            messagetext=messagetext+"\n"
            if message[i+2] > 0 and advancedmode:
                messagetext=messagetext+"/--"+hex_to_ascii(message[i+2])
            i += 2
            line=False
        elif message[i] in symbols2 and not(advancedmode):
            for j in range(10):
                if symbols2[j] == message[i] and symbols2[j]+1 == message[i+1]:
                    messagetext=messagetext+symbols2toascii[j]
                    i += 1
            if oldi == i:
                messagetext=messagetext+hex_to_ascii(message[i])
        elif message[i] in symbols3 and not(advancedmode):
            for j in range(4):
                if symbols3[j] == message[i] and symbols3[j]+1 == message[i+1] and symbols3[j]+2 == message[i+2]:
                    messagetext=messagetext+symbols3toascii[j]
                    i += 2
            if oldi == i:
                messagetext=messagetext+hex_to_ascii(message[i])
        else:
            messagetext=messagetext+hex_to_ascii(message[i])
        i += 1
    if line:
        messagetext=messagetext+"\n"
    return messagetext

#Removes old messages in the ROM
def clear_rom(file, hexmessages, hexptrs):
    rom = file
    for i in range(len(hexmessages)):
        for j in range(len(hexmessages[i])):
            rom[hexptrs[i]+j] = 0xFF
    return rom

#Removes old translevel names in the ROM
def clear_translevel(file, hextranslvls, hextransptrs, junktransptr):
    rom = file
    for i in range(len(hextranslvls)):
        for j in range(len(hextranslvls[i])):
            rom[hextransptrs[i]+j] = 0xFF
    if rom[junktransptr:junktransptr+25] == bytearray(junkdata):
        for i in range(25):
            rom[junktransptr+i] = 0xFF
    return rom

#Converts an array of text to a list of text messages.
def file_to_text_messages(file):
    messages = []
    messaging = False
    for i in file:
        if i.startswith("/\\\\") or i.startswith("/\\6") or i.startswith("/\\7") or i.startswith("/\\8"):
            messaging = True
            messages.append(i)
        elif messaging:
            lastmessage = messages[len(messages)-1]
            lastmessage = lastmessage+i
            if i.endswith("///\n") or i.endswith("/_C\n") or i.endswith("/_D\n") or i.endswith("/_E\n"):
                lastmessage = lastmessage.rstrip("\n")
                messaging = False
            messages[len(messages)-1] = lastmessage
    return messages

#Gets a list of pointers from an array of text.
def file_to_pointers(file):
    pointers = []
    pointerstarted = False
    j = -1
    for i in file:
        if pointerstarted:
            j += 1
            if j % 8 > 3:
                pointers.append(int(i.rstrip("\n"))-1)
        if i == "/__\n":
            pointerstarted = True
    return pointers

#Converts an array of text to a list of translevel names.
def file_to_translevels(file):
    translvls = []
    translvlstarted = False
    counter = 0
    for i in file:
        if i == "/__\n":
            translvlstarted = True
        if translvlstarted:
            if counter % 8 == 3:
                translvls.append(i)
            if counter % 8 == 4:
                translvls[-1] = translvls[-1] + i.rstrip("\n")
            counter += 1
    return translvls

#Converts a message from text to hex
def message_text_to_hex(textmessage):
    hexmessage = bytearray()
    #Special case for SMWCI
    if textmessage.startswith("/\\Huh??")
        hexmessage = mineminehex
        return hexmessage    
    hexmessage = [0xFF, 0x05]
    if textmessage[:3] == "/\\\\":
        textmessage = textmessage[3:]
    elif textmessage[:3] == "/\\6":
        hexmessage = [0xFF, 0x06]
        textmessage = textmessage[3:]
    elif textmessage[:3] == "/\\7":
        hexmessage = [0xFF, 0x07]
        textmessage = textmessage[3:]
    elif textmessage[:3] == "/\\8":
        hexmessage = [0xFF, 0x08]
        textmessage = textmessage[3:]
    lines = 0
    height = 1
    while textmessage != "":
        char = textmessage[:1]
        textmessage = textmessage[1:]
        if char == " ":
            hexmessage.append(0xD0)
        elif ord(char) > 64 and ord(char) < 91:
            hexmessage.append(ord(char)+105)
        elif ord(char) > 96 and ord(char) < 123:
            hexmessage.append(ord(char)+119)
        elif ord(char) > 47 and ord(char) < 58:
            hexmessage.append(ord(char)+112)
        elif char in arraytoascii:
            for i in range(23):
                if arraytoascii[i] == char and i != 4 and i != 12:
                    hexmessage.append(hextoarray[i])
        elif char == "/":
            char = char+textmessage[:2]
            textmessage = textmessage[2:]
            if char in arraytoascii2:
                for i in range(42):
                    if arraytoascii2[i] == char:
                        hexmessage.append(hextoarray2[i])
            elif char in symbols2toascii:
                for i in range(10):
                    if symbols2toascii[i] == char:
                        hexmessage.extend([symbols2[i],symbols2[i]+1])
            elif char in symbols3toascii:
                for i in range(4):
                    if symbols3toascii[i] == char:
                        hexmessage.extend([symbols3[i],symbols3[i]+1,symbols3[i]+2])
            elif char == "///":
                if lines > 3:
                    for i in range(8):
                        hexmessage.extend([0xFF,0x12])
                hexmessage.extend([0xFF,0x0F,0xFF,0xFF])
            elif char == "/_C":
                if lines > 3:
                    for i in range(8):
                        hexmessage.extend([0xFF,0x12])
                hexmessage.extend([0xFF,0x51,0xFF,0xFF])
            elif char == "/_D":
                if lines > 3:
                    for i in range(8):
                        hexmessage.extend([0xFF,0x12])
                hexmessage.extend([0xFF,0x50,0xFF,0xFF])
            elif char == "/_E":
                if lines > 3:
                    for i in range(8):
                        hexmessage.extend([0xFF,0x12])
                hexmessage.extend([0xFF,0x52,0xFF,0xFF])
            elif char == "/TS":
                char = textmessage[:3]
                textmessage = textmessage[3:]
                for i in range(16):
                    if hexchars[i] == char[2]:
                        hexval = 48+i
                        hexmessage.extend([0xFF, hexval])
                        if i == 0 or i == 4:
                            height = 1
                        elif i == 1 or i == 5:
                            height = 2
                        elif i == 2 or i == 6:
                            height = 3
                        elif i == 3 or i == 7:
                            height = 4
            elif char == "/LL":
                hexmessage.extend([0xFF,0x3D,0xFF,0x3E,0xFF,0x3F])
            elif char == "/L1":
                hexmessage.extend([0xFF,0x3D])
            elif char == "/L2":
                hexmessage.extend([0xFF,0x3E])
            elif char == "/L3":
                hexmessage.extend([0xFF,0x3F])
            elif char == "/ME":
                hexmessage.extend([0xFF,0x60,0x00,0x00,0x00,0x80,0x30,0x00,0x10])
                lines += 3
            elif char == "/GP":
                hexmessage.extend([0xFF,0x60,0x00,0x30,0x00,0x80,0x30,0x00,0x10])
                lines += 3
            elif char == "/TE":
                hexmessage.extend([0xFF,0x60,0x00,0x80,0x00,0x80,0x30,0x00,0x10])    
                lines += 3
            else:
                for i in range(16):
                    if hexchars[i] == char[1]:
                        for j in range(16):
                            if hexchars[j] == char[2]:
                                hexval = (i*16)+j
                                if hexval != 255:
                                    hexmessage.append(hexval)
        elif char == "\n":
            lines = lines + height - 1
            if lines == 0:
                hexmessage.extend([0xFF,0x06])
            elif lines == 1:
                hexmessage.extend([0xFF,0x07])
            elif lines == 2:
                hexmessage.extend([0xFF,0x08])
            else:
                if (lines % 4) == 0:
                    hexmessage.extend([0xFF,0x0A])
                if lines > 3:
                    for i in range(8):
                        hexmessage.extend([0xFF,0x12])
                hexmessage.extend([0xFF,0x0E])
            lines += 1
    return hexmessage

#Converts a translevel name from text to hex
def translevel_text_to_hex(translvl):
    hextranslvl = bytearray()
    hextranslvl = [0xFF, 0x00]
    while translvl != "":
        char = translvl[:1]
        translvl = translvl[1:]
        if char == " ":
            hextranslvl.append(0xD0)
        elif ord(char) > 64 and ord(char) < 91:
            hextranslvl.append(ord(char)+105)
        elif ord(char) > 96 and ord(char) < 123:
            hextranslvl.append(ord(char)+119)
        elif ord(char) > 47 and ord(char) < 58:
            hextranslvl.append(ord(char)+112)
        elif char in arraytoascii:
            for i in range(23):
                if arraytoascii[i] == char and i != 4 and i != 12:
                    hextranslvl.append(hextoarray[i])
        elif char == "/":
            char = char+translvl[:2]
            translvl = translvl[2:]
            if char in arraytoascii2:
                for i in range(42):
                    if arraytoascii2[i] == char:
                        hextranslvl.append(hextoarray2[i])
            elif char in symbols2toascii:
                for i in range(10):
                    if symbols2toascii[i] == char:
                        hextranslvl.extend([symbols2[i],symbols2[i]+1])
            elif char in symbols3toascii:
                for i in range(4):
                    if symbols3toascii[i] == char:
                        hextranslvl.extend([symbols3[i],symbols3[i]+1,symbols3[i]+2])
            else:
                for i in range(16):
                    if hexchars[i] == char[1]:
                        for j in range(16):
                            if hexchars[j] == char[2]:
                                hexval = (i*16)+j
                                if hexval < 253:
                                    hextranslvl.append(hexval)
        elif char == "\n":
            if translvl != "":
                if translvl[:3] == "/--":
                    char = translvl[3:6]
                    translvl = translvl[6:]
                    linespace = 0
                    for i in range(16):
                        if hexchars[i] == char[1]:
                            for j in range(16):
                                if hexchars[j] == char[2]:
                                    linespace = (i*16)+j
                    hextranslvl.extend([0xFE,0x10,linespace])
                else:
                    hextranslvl.extend([0xFE,0x10,0x00])
    hextranslvl.append(0xFD)
    return hextranslvl

#Finds freespace for messages, instead of just overwriting and corrupting important level data
def find_freespace(rom, hexptrs):
    beginnings = []
    endings = []
    freespace = False
    freenums = 0
    if rom[0x111333] == 0xFF:
        beginnings = [0x111333]
        freespace = True
    for i in range(0x111333, 0x120000):
        if rom[i] == 0xFF:
            if not freespace:
                if freenums == 6 or i in hexptrs:
                    freespace = True
                    beginnings.append(i)
                else:
                    freenums += 1
        else:
            if freespace:
                freespace = False
                freenums = 0
                endings.append(i)
    if freespace:
        endings.append(0x120000)
    return [beginnings, endings]

#Inserts messages and translevel names into the ROM with specified pointers
def insert_messages(rom, messages, pointers):
    for i in range(len(messages)):
        for j in range(len(messages[i])):
            assert rom[pointers[i]+j] == 0xFF
            rom[pointers[i]+j] = messages[i][j]
    return rom

#Inserts pointer data into the ROM
def insert_pointers(rom, pointers, start):
    for i in range(len(pointers)):
        newptr = pointers[i] - 0x110000
        rom[start+(i*2)] = newptr % 256
        rom[start+1+(i*2)] = newptr // 256
    return rom

#Writes to a ROM
def write_rom(romname, data):
    with open(romname, "rb+") as f:
        oldrom = f.read()
    headered = False
    if len(oldrom) > 0x200000:
        headered = True
    if headered:
        header = bytearray(oldrom[:0x200])
        header.extend(data)
        rombytes = bytes(header)
    else:
        rombytes = bytes(data)
    rom = open(romname, "wb")
    rom.write(rombytes)
    rom.close()

#Main code
if __name__ == '__main__':
    error = False
    try:
        rom = open_rom(sys.argv[1])
    except ValueError:
        print("ROM not found.")
        error = True
    if len(sys.argv) < 2:
        print("Invalid command.")
    textimport = True
    advancedmode = False
    if sys.argv[2] == "export":
        textimport = False
    if sys.argv[2] == "export+":
        textimport = False
        advancedmode = True
    if textimport and sys.argv[2] != "import":
        print("Invalid command.")
        error = True
    writing = False
    if error == False:
        try:
            #Extracts hex messages and translevel names from ROM
            txtfile = 0
            ptrdata = rom[0x1110DB:0x11131B]
            pointerlocs = set()
            transptrdata = rom[0x1149BC:0x114A4C]
            transptrlocs = set()
            junktransptr = 0
            for i in range(72):
                for j in range(4):
                    pointerlocs.add(find_pointer(ptrdata, i, j))
                transptrlocs.add(find_translevel_pointer(transptrdata,i))
            discardlocs = set()
            for i in pointerlocs:
                if not check_message_pointer(rom, i):
                     discardlocs.add(i)
            pointerlocs -= discardlocs
            for i in transptrlocs:
                if not check_translevel_pointer(rom, i):
                     junktransptr = i
            transptrlocs.discard(junktransptr)
            hexmessages = []
            hexptrs = []
            for i in pointerlocs:
                hexmessages.append(get_message(rom, i))
                hexptrs.append(i)
            hextranslvls = []
            hextransptrs = []
            for i in transptrlocs:
                hextranslvls.append(get_translevel(rom, i))
                hextransptrs.append(i)
            sortedptrs = sorted(hexptrs)
            sortedmessages = []
            for i in range(len(sortedptrs)):
                for j in range(len(hexptrs)):
                    if sortedptrs[i] == hexptrs[j]:
                        sortedmessages.append(hexmessages[j])
            hexmessages = sortedmessages
            hexptrs = sortedptrs
            sortedptrs = sorted(hextransptrs)
            sortedmessages = []
            for i in range(len(sortedptrs)):
                for j in range(len(hextransptrs)):
                    if sortedptrs[i] == hextransptrs[j]:
                        sortedmessages.append(hextranslvls[j])
            hextranslvls = sortedmessages
            hextransptrs = sortedptrs
            if textimport:
                #Imports messages and level names from TextData.txt to ROM
                rom2 = bytearray(rom)
                rom2 = clear_rom(rom2, hexmessages, hexptrs)
                rom2 = clear_translevel(rom2, hextranslvls, hextransptrs, junktransptr)
                try:
                    txtfile = open("TextData.txt", "r")
                except ValueError:
                    print("TextData.txt not found.")
                    raise ValueError
                txtfilelines = []
                for line in txtfile:
                    txtfilelines.append(line)
                txtfile.close()
                messageslist = file_to_text_messages(txtfilelines)
                ptrslist = file_to_pointers(txtfilelines)
                nameslist = file_to_translevels(txtfilelines)
                hexlist = []
                for i in messageslist:
                    hexlist.append(message_text_to_hex(i))
                    newptrslist = []
                for i in ptrslist:
                    if i != -1 and not(i in newptrslist):
                        newptrslist.append(i)
                newptrslist = sorted(newptrslist)
                newhexlist = []
                for i in newptrslist:
                    newhexlist.append(hexlist[i])
                transhexlist = []
                for i in nameslist:
                    transhexlist.append(translevel_text_to_hex(i))
                freespace = find_freespace(rom2, hexptrs)
                beginnings = freespace[0]
                endings = freespace[1]
                j = 0
                freespacelist = []
                transfreespacelist = []
                junkfreespace = 0
                nospaceleft = False
                transromptrs = []
                junkromptr = 0
                for i in range(len(beginnings)):
                    if endings[i] > 0x114A4B:
                        freespaceleft = endings[i] - beginnings[i]
                        runout = False
                        while not runout:
                            if j < 72 and transhexlist[j] != [0xFF,0x00,0xFD]:
                                if len(transhexlist[j]) <= freespaceleft:
                                    freespaceleft -= len(transhexlist[j])
                                    transromptrs.append(beginnings[i])
                                    beginnings[i] += len(transhexlist[j])
                                    transfreespacelist.append(i)
                                    j += 1
                                else:
                                    runout = True
                            else:
                                if j < 72 and transhexlist[j] == [0xFF,0x00,0xFD]:
                                    j += 1
                                else:
                                    j == 72
                                    runout = True
                        if 25 <= freespaceleft and j == 72:
                            junkfreespace = i
                            junkromptr = beginnings[i]
                            beginnings[i] += 25
                            j = 73
                transromptrs.append(junkromptr)
                if j != 73:
                    nospaceleft = True
                else:
                    j = 0
                    for i in range(len(beginnings)):
                        freespaceleft = endings[i] - beginnings[i]
                        runout = False
                        while not runout:
                            if j < len(newhexlist):
                                if len(newhexlist[j]) <= freespaceleft:
                                    freespaceleft -= len(newhexlist[j])
                                    freespacelist.append(i)
                                    j += 1
                                else:
                                    runout = True
                            else:
                                runout = True
                    if j < len(newhexlist):
                        nospaceleft = True
                if nospaceleft:
                    print("There is not enough freespace in the ROM for all messages.")
                else:
                    romptrs = []
                    for i in range(len(newhexlist)):
                        if i == 0:
                            romptrs = [beginnings[freespacelist[0]]]
                        else:
                            if freespacelist[i] == freespacelist[i-1]:
                                romptrs.append(romptrs[i-1]+len(newhexlist[i-1]))
                            else:
                                romptrs.append(beginnings[freespacelist[i]])
                    newtranshexlist = []
                    for i in transhexlist:
                        if i != [0xFF,0x00,0xFD]:
                            newtranshexlist.append(i)
                    newtranshexlist.append(junkdata)
                    rom2 = insert_messages(rom2, newtranshexlist, transromptrs)
                    rom2 = insert_messages(rom2, newhexlist, romptrs)
                    insertptrs = []
                    for i in range(288):
                        if ptrslist[i] != -1:
                            for j in range(len(newptrslist)):
                                if newptrslist[j] == ptrslist[i]:
                                    insertptrs.append(romptrs[j])
                        else:
                            insertptrs.append(0x110000)
                    rom2 = insert_pointers(rom2, insertptrs, 0x1110DB)
                    inserttransptrs = []
                    j=0
                    for i in range(72):
                        if transhexlist[i] != [0xFF,0x00,0xFD]:
                            inserttransptrs.append(transromptrs[j])
                            j += 1
                        else:
                            inserttransptrs.append(junkromptr)
                    rom2 = insert_pointers(rom2, inserttransptrs, 0x1149BC)
                    writing = True
                    write_rom(sys.argv[1],rom2)
                    print("The text was imported successfully!")
            else:
                #Exports messages and level names from ROM to TextData.txt
                textmessages = []
                for i in hexmessages:
                    textmessages.append(message_hex_to_text(i))
                texttranslvls = []
                for i in hextranslvls:
                    texttranslvls.append(translevel_hex_to_text(i))
                writing = True
                txtfile = open("TextData.txt", "w+")
                writing = False
                for i in range(len(textmessages)):
                    txtfile.write(str(i+1)+"\n"+textmessages[i]+"\n\n")
                txtfile.write("/__\n")
                for i in range(72):
                    transleveltxt = str((i // 12)+1) + " - "
                    if i % 12 < 8:
                        transleveltxt = transleveltxt + str((i % 12) + 1)
                    elif i % 12 == 8:
                        transleveltxt = transleveltxt + "E"
                    else:
                        transleveltxt = transleveltxt + "?"
                    translevelname = False
                    for j in range(len(hextransptrs)):
                        if find_translevel_pointer(transptrdata, i) == hextransptrs[j]:
                            transleveltxt = transleveltxt+"\n"+texttranslvls[j]
                            translevelname = True
                    if not translevelname:
                        transleveltxt = transleveltxt+"\n\n"
                    txtfile.write("\n"+transleveltxt+"\n")
                    for j in range(4):
                        ptrnum = 0
                        if find_pointer(ptrdata, i, j) in hexptrs:
                            for k in range(len(hexptrs)):
                                if find_pointer(ptrdata, i, j) == hexptrs[k]:
                                    ptrnum = k+1
                        txtfile.write(str(ptrnum)+"\n")
                txtfile.close()
                if advancedmode:
                    print("The text was exported successfully in Advanced mode!")
                else:
                    print("The text was exported successfully!")
        except:
            if textimport:
                if txtfile == 0:
                    print("TextData.txt not found")
                elif writing:
                    print("There was an error in writing to the ROM.")
                    print("Check whether the folder is Read-Only or if the ROM is open in another program.")
                else:
                    print("There was an error in importing the text.")
            else:
                if writing:
                    print("There was an error in writing to TextData.txt.")
                    print("Check whether the folder is Read-Only or if TextData.txt is open in another program.")
                else:
                    print("There was an error in exporting the text.")
