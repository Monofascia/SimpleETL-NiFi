import json
import polars as pl
import os
import re

# Define wdir
wdir = r"\\wsl.localhost\Ubuntu\home\piezzi\\data\\"  # 'r' stands for raw string
# Define schema
schema = pl.Schema(
    {
        "id": pl.Int64(),
        "first_name": pl.String(),
        "last_name": pl.String(),
        "ts": pl.String(),
    }
)
# Pass schema to an empty df
data = pl.DataFrame(schema=schema)
# For loop in directory
for i in os.listdir(wdir):
    try:
        # a = pl.read_json(wdir + r"\\" + str(i))
        a = pl.read_json(wdir + str(i))
        data = pl.concat([data, a], how="vertical")
    except Exception as e:
        print("{} caused by {}".format(e, i))
        continue
print(data.count())
data.write_json(wdir + "mockaroo_final.json")
