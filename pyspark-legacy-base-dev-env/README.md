Build the env with
```
nix develop
```

pyspark will be available in the python build:
```
python
>>> import pyspark
>>> pyspark = pyspark.sql.SparkSession.builder.getOrCreate()
```
