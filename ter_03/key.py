import requests
import json

json_cred = {}
with open ('terraform.tfvars', 'r', encoding='UTF-8') as file_1:
    for line in file_1:
        json_cred[line.split('=')[0]] = line.split('=')[1]
    u = json_cred['do_token ']
u = u.replace('"', '')
u = u.replace('\n', '')

api_token = u.replace(' ', '')
api_url_base = 'https://api.digitalocean.com/v2/account/keys/?per_page=200'
headers = {'Content-Type': 'application/json',
        'Authorization': 'Bearer {0}'.format(api_token)
        }

response = requests.get(api_url_base, headers=headers).json()

json_data = {}

for el in response['ssh_keys']:
    if el['name'] == 'REBRAIN.SSH.PUB.KEY':
        json_data.update(el)

json_data['id'] = str(json_data['id'])
print(json.dumps(json_data))
