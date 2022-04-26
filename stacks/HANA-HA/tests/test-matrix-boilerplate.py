import json
import os
import shutil
from jinja2 import Template


def make_setup_main_tf(product_id, family, i):
    test_name = f'{product_id}-{family}'
    os.makedirs(f'setups/{test_name}', exist_ok=True)
    main_tf = open('setups/main.tf.tmpl').read()
    j2_template = Template(main_tf)
    data = {
        'os': family,
        'i': i,
        'product_id': product_id
    }
    with open(f'setups/{test_name}/main.tf', 'w') as setup_tf:
        setup_tf.write(j2_template.render(data))


def make_test_playbook(product_id, family, project):
    playbook_str = open('playbook.yml.tmpl').read()
    playbook_str = playbook_str.replace('FAMILY', family)
    playbook_str = playbook_str.replace('PROJECT', project)
    playbook_str = playbook_str.replace('PRODUCT_ID', product_id)
    with open(f'{product_id}-{family}.yml', 'w') as playbook:
        playbook.write(playbook_str)


def make_forminator_tf(product_id, family):
    test_name = f'{product_id}-{family}'
    os.makedirs(f'tf/{test_name}', exist_ok=True)
    source_folder = 'tf/forminator_tf/'
    destination_folder = f'tf/{test_name}/'
    for file_name in os.listdir(source_folder):
        # construct full file path
        source = source_folder + file_name
        destination = destination_folder + file_name
        shutil.copy(source, destination)


def main():
    matrix = json.load(open('test_matrix.js', 'r'))
    for test_group in matrix:
        i=0
        product_id = test_group['product_id']
        for system in test_group['os']:
            make_test_playbook(product_id, system['family'], system['project'])
            make_setup_main_tf(product_id, system['family'], i)
            make_forminator_tf(product_id, system['family'])
            i += 1

main()