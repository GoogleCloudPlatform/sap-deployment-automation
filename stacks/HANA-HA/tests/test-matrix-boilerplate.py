import json
import os
from jinja2 import Template


def make_setup_main_tf(product_id, family, i):
    test_name = f'{product_id}-{family}'
    os.makedirs(f'setups/{test_name}', exist_ok=True)
    main_tf = open('setups/main.tf.tmpl').read()
    j2_template = Template(main_tf)
    data = {
        'os': family.replace('sles-', 's').replace('-sap', '').replace('rhel-', 'rh').replace('-ha', ''),
        'i': i,
        'product_id': product_id.lower()
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
    dest_dir = os.open(destination_folder, os.O_RDONLY)
    for file_name in os.listdir(source_folder):
        try:
            os.symlink(f'../forminator_tf/{file_name}', file_name, dir_fd=dest_dir)
        except FileExistsError:
            # symlink already created
            pass


def make_cloud_build_conf(tests):
    cb_tmpl_file = open('cloudbuild.yml.tmpl').read()
    cb_tmpl = Template(cb_tmpl_file)
    data = {
        'tests': tests
    }
    with open(f'test-hana-ha.cloudbuild.yaml', 'w') as cloudbuild_conf:
        cloudbuild_conf.write(cb_tmpl.render(data))


def main():
    matrix = json.load(open('test-matrix.json', 'r'))
    tests = []
    i = 0
    for test_group in matrix:
        product_id = test_group['product_id']
        for system in test_group['os']:
            make_test_playbook(product_id, system['family'], system['project'])
            make_setup_main_tf(product_id, system['family'], i)
            make_forminator_tf(product_id, system['family'])
            i += 1
            tests.append(f'{product_id}-{system["family"]}')
    make_cloud_build_conf(tests)


main()
