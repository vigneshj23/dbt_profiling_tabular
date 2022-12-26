from dotenv import dotenv_values
config=dotenv_values(".env")
f = open('ci/sample.profiles.yml','r',encoding='utf-8')
data =f.read()
f.close()

data=data.replace('$','')

final =open('profiles.yml','w',encoding='utf-8')
final.write(data.format(**config))
final.close()