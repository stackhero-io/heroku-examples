# SQLAlchemy example

import os
from sqlalchemy import create_engine

print("Trying to connect to " + os.environ['STACKHERO_MYSQL_HOST']);

e = create_engine(
  'mysql+pymysql://root:{password}@{host}'.format(password=os.environ['STACKHERO_MYSQL_ROOT_PASSWORD'], host=os.environ['STACKHERO_MYSQL_HOST']),
  connect_args={ "ssl": { "fake_flag_to_enable_tls": True } }
)
c = e.connect()

print("Connection success!")
