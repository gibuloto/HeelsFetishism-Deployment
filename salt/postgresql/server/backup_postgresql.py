from datetime import datetime
import os
import subprocess

from boto.s3.connection import S3Connection
from boto.s3.key import Key


POSTGRESQL_DB = "{{ pillar['postgresql']['db'] }}"

AWS_ACCESS_KEY_ID = "{{ pillar['aws']['access_key'] }}"
AWS_SECRET_ACCESS_KEY = "{{ pillar['aws']['secret_key'] }}"
AWS_STORAGE_BUCKET_NAME = "{{ pillar['aws']['bucket'] }}"

now = datetime.now()
filename = 'postgresql_%s.sql.gz' % (now.strftime('%Y-%m-%d_%H-%M'))
filepath = os.path.join('/tmp', filename)

command = 'pg_dump %s | gzip > %s' % (POSTGRESQL_DB, filepath)
try:
    subprocess.check_call(command, shell=True)
    print command
except subprocess.CalledProcessError:
    print 'fail'
else:
    connection = S3Connection(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
    bucket = connection.get_bucket(AWS_STORAGE_BUCKET_NAME)
    k = Key(bucket)
    k.key = 'backup/%s' % (filename)
    k.set_contents_from_filename(filepath)

    print 'done'
