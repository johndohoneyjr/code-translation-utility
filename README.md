# code-translation-utility

## Preparation
There are 3 things to setup to use this program

1. Obtain a OpenAI API key, and load it into an Azure Key Vault

2. Create an AAD Service Principal, use the values to set environment variables
```
tenant_id = os.environ.get("PT_TENANT_ID")
client_id = os.environ.get("PT_CLIENT_ID")
client_secret = os.environ.get("PT_CLIENT_SECRET")
```
Be sure to grant your service principal the "Key Vault Secrets User" role and access to the key vault.  This can be done in the Azure Portal and be sure to add an access policy to the key vault.

3. Modify the launch.json for Visual Studio Code for the command line arguments to pass into the program.  This can be done with a Linux Script as well.
```
input_dir = sys.argv[1]
output_dir = sys.argv[2]
key_vault_url = sys.argv[3]
openai_key_secret_name = sys.argv[4]
reject_dir = sys.argv[5]
```

## Program Usage
Load the files to translate into the input directory (sys.argv[1]).  The program will translate the files and place them in the output directory(sys.argv[2]).  If the translation is rejected, the file will be placed in the reject directory (sys.argv[5]).

Typically, "rejection" is due to the file being too large.  If that is the case, you can modify the program by splitting it into 2-3 files, and then re-running the program.  Append a "-1" to the file name.  The program retains the file name prefix, and only changes the suffix or file extension (.sh).