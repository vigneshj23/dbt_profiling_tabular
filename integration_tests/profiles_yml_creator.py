#import required package
from dotenv import dotenv_values
f = open('ci/sample.profiles.yml', 'r', encoding='utf-8')
data = f.read()
f.close()

try:
    
    # Read the env variables
    config = dotenv_values(".env")
    # Read the sample.profiles.yml file

    convert_data = data.replace('$', '')

    # Writing the actual profile.yml file
    final = open('profiles.yml', 'w', encoding='utf-8')
    final.write(convert_data.format(**config))
    final.close()

except:

    convert_data = data.replace('{', '').replace('}', '')
    # Writing the actual profile.yml file
    final = open('profiles.yml', 'w', encoding='utf-8')
    final.write(convert_data.format(**config))
    final.close()