import os
import csv

def processFile(filename, input, output):
#    print(filename)
    if not os.path.isfile(filename): return

    with open(filename) as f:
        s = f.read()
    if input not in s:
        return

    print(filename + " changed " + input)
    s = s.replace(input, output)
    with open(filename, 'w') as f:
        f.write(s)

def processFolder(folderpath, input, output):
    for path,dirs,files in os.walk(folderpath):
        for filename in files:
            filepath = os.path.join(path + "/" + filename)
            if filepath.endswith(".swift"):
                processFile(filepath, input, output)
    return;

def processKey(folderpath, input, output):
    defKeyIn = 'static let ' + input + ' = '
    defKeyOut = 'static let ' + output + ' = '

    useKeyIn = 'AppTextKey.' + input + ')'
    useKeyOut = 'AppTextKey.' + output + ')'

    processFolder(folderpath, defKeyIn, defKeyOut)
    processFolder(folderpath, useKeyIn, useKeyOut)
    return;

path = 'QOT/Sources'

tsv = 'app_text_service_replace.csv'
with open(tsv) as csvfile:
    reader = csv.reader(csvfile, delimiter=',')
    for row in reader:
        keyIn = row[0]
        keyOut = row[1]
        if keyIn != keyOut:
            processKey(path, keyIn, keyOut)

##keyIn = 'my_qot_my_profile_alert_continue_button'
#keyOut = 'my_qot_my_profile_alert_button_continue'
#processKey(path, 'create_account_email_verification_view_button_yes', 'create_account_email_verification_view_yes_yes_yes_give_it_to_me')
