import os
import sys
import requests
import msal
from azure.keyvault.secrets import SecretClient
from azure.identity import ClientSecretCredential
import openai
import json
import re


# escape double quotes in a string
def escape_quotes(s):
    temp = s.replace("\n", "\\n").replace("\t", "").replace('"','\'').replace('"{','{').replace('}"','}') 
    return s

# Get command line arguments
input_dir = sys.argv[1]
output_dir = sys.argv[2]
key_vault_url = sys.argv[3]
openai_key_secret_name = sys.argv[4]
reject_dir = sys.argv[5]

# Read Windows Service Principal parameters from environment variables
tenant_id = os.environ.get("PT_TENANT_ID")
client_id = os.environ.get("PT_CLIENT_ID")
client_secret = os.environ.get("PT_CLIENT_SECRET")

# Create a credential object using MSAL for Python
credential = ClientSecretCredential(tenant_id, client_id, client_secret)

secret_client = SecretClient(vault_url=key_vault_url, credential=credential)
openai_key_secret = secret_client.get_secret(openai_key_secret_name)
openai.api_key = openai_key_secret.value

# OpenAI API endpoint URL
openai_url = "https://api.openai.com/v1/completions"
# OpenAI API request parameters
openai_api_key = openai_key_secret.value
openai_model = "text-davinci-003"
openai_temperature = 0
openai_max_tokens = 2048

# Read input files into dictionary
file_list = {}
for filename in os.listdir(input_dir):
    input_file_path = os.path.join(input_dir, filename)
    with open(input_file_path, "r") as input_file:
        file_contents = input_file.read()
        file_list[filename] = file_contents

# Process input files
for filename, file_contents in file_list.items():
    output_file = os.path.join(output_dir, f"{filename}.sh")
    output_file_path = output_file.replace(".bat", "")

    clean_payload = escape_quotes(file_contents);
    p_data = "Translate to linux bash: " + clean_payload;
    
    if len(p_data) > 4096:
        openai_max_tokens = 0
    else:
      openai_max_tokens = 4096 - len(p_data)

    myStr = json.dumps(p_data, ensure_ascii=True)


    # Call OpenAI to translate Windows batch file to Linux bash shell script
    openai_payload = {
        "prompt": p_data,
        "temperature": openai_temperature,
        "model": openai_model,
        "temperature": 0,
        "max_tokens": openai_max_tokens,
        "logprobs": 0,
        "top_p": 1,
        "n": 1
    }

    openai_headers = {"Content-Type": "application/json", "Authorization": f"Bearer {openai_api_key}"}
    openai_response = requests.post(openai_url, headers=openai_headers, json=openai_payload )
    if openai_response.status_code != 200:
        print(f"OpenAI API call failed: {openai_response.text}")
        reject_file_path = os.path.join(reject_dir, f"{filename}")
        with open(reject_file_path, "w") as reject_file:
          reject_file.write("******************************************************************")
          reject_file.write(openai_response.text)
          reject_file.write("******************************************************************\n")
          reject_file.write(file_contents)
        continue    

    p_data = openai_response.json()
    resp_text = openai_response.text

    dict=json.loads(resp_text)
    p_data = dict['choices'][0]['text']

    # Write translated file contents to output file
    with open(output_file_path, "w") as output_file:
        output_file.write(p_data)