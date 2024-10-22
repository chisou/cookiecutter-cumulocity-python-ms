import glob
import os
import subprocess

if __name__ == '__main__':

    print("Updating license ({{ cookiecutter.license }}) ...")
    os.rename('LICENSE-{{ cookiecutter.license }}'.upper(), 'LICENSE')

    for fn in glob.glob('LICENSE-*'):
        os.remove(fn)

    src = 'src/main'
    if '{{ cookiecutter.entrypoint }}' == 'Multi-Tenant Microservice':
        os.rename(f'{src}/multi_tenant.py', f'{src}/main.py')
    elif '{{ cookiecutter.entrypoint }}' == 'Single-Tenant Microservice':
        os.rename(f'{src}/single_tenant.py', f'{src}/main.py')


    if {{ cookiecutter.create_venv }}:
        dir = '.venv'
        print(f"Creating venv in directory '{dir}' ...")
        subprocess.run(['python3', '-m', 'venv', dir], check=True)
        print(f"Installing development dependencies ...")
        subprocess.run([f'{dir}/bin/python', '-m', 'pip', 'install', '-r', 'requirements.txt'], check=True)
        subprocess.run([f'{dir}/bin/python', '-m', 'pip', 'install', '-r', 'requirements-dev.txt'], check=True)

    print("\nProject successfully created: {{ cookiecutter.project_slug }}")