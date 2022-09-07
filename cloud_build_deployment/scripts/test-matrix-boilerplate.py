#!/usr/bin/env python
import yaml
import argparse
from jinja2 import Template


def make_cloud_build_conf(tests, template, output):
    cb_tmpl_file = open(template).read()
    cb_tmpl = Template(cb_tmpl_file)
    data = {
        'tests': tests
    }
    with open(output, 'w') as cloudbuild_conf:
        cloudbuild_conf.write(cb_tmpl.render(data))


def parse_args():
    parser = argparse.ArgumentParser(description='Create cloud build config for integration tests. '
                                                 'The output will be cloudbuild-int-tests.yaml')
    parser.add_argument('-m', '--matrix', help='YAML Test Matrix', default='test-matrix.yaml')
    parser.add_argument('-t', '--template', help='CloudBuild config template', default='cloudbuild-int-tests.yaml.tmpl')
    parser.add_argument('-o', '--output', help='CloudBuild output config', default='cloudbuild-int-tests.yaml')
    return parser.parse_args()


def main():
    args = parse_args()
    print(f'Creating {args.output} based on {args.matrix} test matrix and {args.template} template')
    tests = yaml.load(open(args.matrix, 'r'), Loader=yaml.FullLoader)
    make_cloud_build_conf(tests, args.template, args.output)
    print(f"DONE\nTotal Tests: {len(tests)}")
    print(f"Result in: {args.output}")


main()
