from datetime import datetime

from boto.s3.connection import S3Connection
from boto.s3.key import Key


AWS_ACCESS_KEY_ID = "{{ pillar['aws']['access_key'] }}"
AWS_SECRET_ACCESS_KEY = "{{ pillar['aws']['secret_key'] }}"
AWS_STORAGE_BUCKET_NAME = "{{ pillar['aws']['bucket'] }}"

now = datetime.now()
filename = 'imgseek_%s.db' % (now.strftime('%Y-%m-%d_%H-%M'))

connection = S3Connection(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
bucket = connection.get_bucket(AWS_STORAGE_BUCKET_NAME)
k = Key(bucket)
k.key = 'backup/%s' % (filename)
k.set_contents_from_filename('/home/vinta/imgseek.db')

print 'done'
