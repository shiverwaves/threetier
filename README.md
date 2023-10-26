# Basic Three Tier Web App
Need Terraform installed if running locally...
Need Ansible installed if running locally...
Need AWS access and secret keys provisioned and credentials configured if running locally...

# This project attempts to do some automation in regards to managing ssh configurations and keys for accessing the created ec2 instances.
***The goal of the project is to dynamically determine the $USER running terraform and create ssh key config/keypair in the default .ssh directory for the $USER. This is not working currently, needs a little tweaking***
For now...
You will want to execute this terraform project on a linux machine on the root account. (sudo su -)
Make sure the /root/.ssh/ directory exists, if not, create it ahead of time.
When the terraform project is applied, terraform will generate a new set of ssh keys and add them to your aws keypair (public) key on AWS. The private key pair will be generated in the default .ssh directory. (/root/.ssh/) 
When the terraform project is applied, an ssh config file will be created in the /root/.ssh/ directory that leverages the keypair created. This is meant for ansible to access the ec2 instances for configuration management.


# Terraform Project Structure
![WCD_Project2_structure drawio](https://github.com/shiverwaves/threetier/assets/118776591/ce1e3001-f856-4fb8-af3c-cab141eceb95)
