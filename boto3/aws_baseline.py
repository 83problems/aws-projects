import boto3
import argparse
import configparser
import logging
import sys


def get_vpc_id(session):
    ec2c = session.client('ec2')
    vpcs = ec2c.describe_vpcs(
        Filters=[
            {
                'Name': 'tag:Name',
                'Values': ['vpc_primary']
            },
            {
                'Name': 'tag:Boto3',
                'Values': ['true']
            },
        ],
    )
    try:
        vpc_id = vpcs['Vpcs'][0]['VpcId']
        return vpc_id
    except IndexError:
        return False


def vpc_create(session, region):
    ec2 = session.resource('ec2')
    ec2c = session.client('ec2')
    vpc_id = get_vpc_id(session)
    print(region)

    if not vpc_id:
        logging.info('Creating VPC.')
        ec2.create_vpc(
            CidrBlock='10.0.0.0/16',
            TagSpecifications=[
                {
                    'ResourceType': 'vpc',
                    'Tags': [
                        {
                            'Key': 'Boto3',
                            'Value': 'true'
                        },
                        {
                            'Key': 'Name',
                            'Value': 'vpc_primary'
                        },
                    ]
                },
            ]
        )
        logging.info('VPC created.')
        vpc_id = get_vpc_id(session)
        logging.info('Creating subnets.')
        ec2c.create_subnet(
            TagSpecifications=[
                {
                    'ResourceType': 'subnet',
                    'Tags': [
                        {
                            'Key': 'Boto3',
                            'Value': 'true'
                        },
                        {
                            'Key': 'Name',
                            'Value': 'vpc_primary_subpub_1a'
                        },
                    ]
                },
            ],
            AvailabilityZone=f'{region}a',
            CidrBlock='10.0.1.0/24',
            VpcId=vpc_id
        )
        ec2c.create_subnet(
            TagSpecifications=[
                {
                    'ResourceType': 'subnet',
                    'Tags': [
                        {
                            'Key': 'Boto3',
                            'Value': 'true'
                        },
                        {
                            'Key': 'Name',
                            'Value': 'vpc_primary_subpub_1b'
                        },
                    ]
                },
            ],
            AvailabilityZone=f'{region}b',
            CidrBlock='10.0.3.0/24',
            VpcId=vpc_id
        )
        ec2c.create_subnet(
            TagSpecifications=[
                {
                    'ResourceType': 'subnet',
                    'Tags': [
                        {
                            'Key': 'Boto3',
                            'Value': 'true'
                        },
                        {
                            'Key': 'Name',
                            'Value': 'vpc_primary_subpri_1a'
                        },
                    ]
                },
            ],
            AvailabilityZone=f'{region}a',
            CidrBlock='10.0.2.0/24',
            VpcId=vpc_id
        )
        ec2c.create_subnet(
            TagSpecifications=[
                {
                    'ResourceType': 'subnet',
                    'Tags': [
                        {
                            'Key': 'Boto3',
                            'Value': 'true'
                        },
                        {
                            'Key': 'Name',
                            'Value': 'vpc_primary_subpri_1b'
                        },
                    ]
                },
            ],
            AvailabilityZone=f'{region}b',
            CidrBlock='10.0.4.0/24',
            VpcId=vpc_id
        )
        logging.info('Subnets created.')

        logging.info('Creating Internet Gateway.')
        igw = ec2.create_internet_gateway(
                TagSpecifications=[
                    {
                        'ResourceType': 'internet-gateway',
                        'Tags': [
                            {
                                'Key': 'Boto3',
                                'Value': 'true'
                            },
                            {
                                'Key': 'Name',
                                'Value': 'vpc_primary_internet_gateway'
                            },
                        ]
                    },
                ],
            )
        logging.info('Internet Gateway created.')

        logging.info('Attaching Internet Gateway.')
        ec2c.attach_internet_gateway(
            InternetGatewayId=igw.id,
            VpcId=vpc_id
        )
        logging.info('Internet Gateway Attached.')


def cleanup(session, aws_domain_name):
    ec2c = session.client('ec2')
    vpcs = ec2c.describe_vpcs(
        Filters=[
            {
                'Name': 'tag:Name',
                'Values': ['vpc_primary']
            },
            {
                'Name': 'tag:Boto3',
                'Values': ['true']
            },
        ],
    )

    if vpcs['Vpcs']:
        vpc_id = vpcs['Vpcs'][0]['VpcId']
    else:
        logging.info('No VPCs to delete.')
        return

    logging.info('Deleting Gateway.')
    igw = ec2c.describe_internet_gateways(
        Filters=[
            {
                'Name': 'tag:Name',
                'Values': ['vpc_primary_internet_gateway']
            },
        ],

    )
    igw_id = igw['InternetGateways'][0]['InternetGatewayId']

    ec2c.delete_internet_gateway(
        InternetGatewayId=igw_id
    )
    logging.info('Gateway deleted.')

    subnets = ec2c.describe_subnets(
        Filters=[
            {
                'Name': 'vpc-id',
                'Values': [vpc_id]
            },
        ],
    )
    for subnet in subnets['Subnets']:
        # print(subnet['SubnetId'])
        logging.info('Deleting Subnet.')
        ec2c.delete_subnet(
            SubnetId=subnet['SubnetId']
        )
        logging.info('Subnet deleted.')

    logging.info('Deleting VPC.')
    ec2c.delete_vpc(
        VpcId=vpc_id,
    )
    logging.info('VPC deleted.')


def parse_args():
    parser = argparse.ArgumentParser(description='Create AWS project'
                                                 ' baseline.')
    parser.add_argument("-c", "--cleanup", action="store_true",
                        help="Cleanup AWS baseline resources",
                        default=False)
    return parser.parse_args()


def main():
    args = parse_args()
    logging.basicConfig(level=logging.INFO)
    config = configparser.ConfigParser()
    config.read('config.ini')
    aws_domain_name = config.get('default', 'domain_name')
    aws_region_name = config.get('default', 'region_name')
    aws_profile_name = config.get('default', 'profile_name')

    session = boto3.Session(
        profile_name=aws_profile_name,
        region_name=aws_region_name
    )

    if args.cleanup:
        cleanup(session, aws_domain_name)
        sys.exit()
    vpc_create(session, aws_region_name)


if __name__ == "__main__":
    """ This is executed when run from the command line. """
    main()
